import Fastify from 'fastify';
import fastifyWebsocket from '@fastify/websocket';
import { loadConfig, logger, verifyAccessToken } from '@stealth/core';
import {
  decodeClientFrame,
  encodeServerFrame,
  type ServerFrame,
  type ClientFrame,
  type MessageNew,
} from '@stealth/contracts-ts';
import type { WebSocket } from 'ws';

const config = loadConfig();
const fastify = Fastify({ logger: false });

await fastify.register(fastifyWebsocket);

// Track active client connections
interface SocketContext {
  ws: WebSocket;
  authenticated: boolean;
  userId?: string;
  deviceId?: string;
}

const activeSockets = new Map<WebSocket, SocketContext>();
// In-memory conversation sequence cache
const convSequences = new Map<string, number>();
// In-memory processed messages cache for idempotency
const processedMessages = new Map<string, { seq: number; serverTs: number; message: MessageNew }>();

function sendServerFrame(ws: WebSocket, frame: ServerFrame) {
  if (ws.readyState === ws.OPEN) {
    const data = encodeServerFrame(frame);
    ws.send(data);
  }
}

function broadcastFrame(frame: ServerFrame) {
  for (const [ws] of activeSockets.entries()) {
    sendServerFrame(ws, frame);
  }
}

fastify.get('/health', async () => {
  return { status: 'ok', service: 'stealth-gateway', connections: activeSockets.size };
});

fastify.get('/ws', { websocket: true }, (socket, req) => {
  const ws = socket as unknown as WebSocket;
  const ctx: SocketContext = { ws, authenticated: false };
  activeSockets.set(ws, ctx);
  logger.info('WebSocket connection opened', { total: activeSockets.size });

  ws.on('message', (raw: Buffer) => {
    const frame = decodeClientFrame(raw);
    if (!frame) {
      logger.warn('Failed to decode ClientFrame');
      return;
    }

    const { req_id, v } = frame;

    // 1. Hello handshake
    if (frame.hello) {
      const { access_token, device_id, sync_token } = frame.hello;
      try {
        let userId = 'user_dev';
        try {
          const verified = verifyAccessToken(access_token, config.jwtSecret);
          userId = verified.userId;
        } catch {
          // Allow dev fallback if token is testing dummy
          if (config.nodeEnv === 'development') {
            userId = 'dev_' + (device_id || 'anonymous').slice(0, 8);
          } else {
            throw new Error('UNAUTHENTICATED');
          }
        }

        ctx.authenticated = true;
        ctx.userId = userId;
        ctx.deviceId = device_id;

        logger.info('Gateway client authenticated', { userId, deviceId: device_id });

        sendServerFrame(ws, {
          v: v || 1,
          req_id: req_id || '',
          hello_ok: {
            server_time_ms: Date.now(),
            changed_conversations: [],
          },
        });
      } catch (err) {
        sendServerFrame(ws, {
          v: v || 1,
          req_id: req_id || '',
          error: {
            req_id: req_id || '',
            code: 1, // UNAUTHENTICATED
            message: 'Authentication failed',
          },
        });
      }
      return;
    }

    // 2. Ping / Pong
    if (frame.ping) {
      sendServerFrame(ws, {
        v: v || 1,
        req_id: req_id || '',
        pong: { timestamp_ms: Date.now() },
      });
      return;
    }

    // Require auth for subsequent operations
    if (!ctx.authenticated) {
      sendServerFrame(ws, {
        v: v || 1,
        req_id: req_id || '',
        error: {
          req_id: req_id || '',
          code: 1,
          message: 'Must authenticate first with Hello frame',
        },
      });
      return;
    }

    // 3. SendMessage
    if (frame.send) {
      const { message_id, conversation_id, kind, payload, reply_to_id } = frame.send;

      // Check idempotency: duplicate message_id returns original Ack without duplicate row
      const existing = processedMessages.get(message_id);
      if (existing) {
        logger.info('Duplicate message_id received, returning idempotent Ack', { message_id, seq: existing.seq });
        sendServerFrame(ws, {
          v: v || 1,
          req_id: req_id || '',
          ack: {
            message_id,
            seq: existing.seq,
            server_ts_ms: existing.serverTs,
          },
        });
        return;
      }

      const currentSeq = convSequences.get(conversation_id) || 0;
      const nextSeq = currentSeq + 1;
      convSequences.set(conversation_id, nextSeq);

      const serverTs = Date.now();
      logger.info('Message processed', { conversation_id, seq: nextSeq, message_id });

      const newMsg: MessageNew = {
        conversation_id,
        seq: nextSeq,
        message_id,
        sender_id: ctx.userId || 'system',
        kind: kind || 1,
        payload,
        reply_to_id,
        server_ts_ms: serverTs,
        edit_version: 0,
      };

      processedMessages.set(message_id, {
        seq: nextSeq,
        serverTs,
        message: newMsg,
      });

      // Reply with Ack immediately
      sendServerFrame(ws, {
        v: v || 1,
        req_id: req_id || '',
        ack: {
          message_id,
          seq: nextSeq,
          server_ts_ms: serverTs,
        },
      });

      // Broadcast MessageNew to all listeners
      broadcastFrame({
        v: 1,
        message_new: newMsg,
      });
      return;
    }

    // 4. ReceiptUpTo
    if (frame.receipt) {
      const { conversation_id, delivered_upto_seq, read_upto_seq } = frame.receipt;
      logger.info('Receipt cursor updated', { conversation_id, delivered: delivered_upto_seq, read: read_upto_seq });

      broadcastFrame({
        v: 1,
        receipt: {
          conversation_id,
          user_id: ctx.userId || 'system',
          delivered_upto_seq,
          read_upto_seq,
        },
      });
      return;
    }

    // 5. Typing
    if (frame.typing) {
      const { conversation_id, is_typing } = frame.typing;
      for (const [otherWs] of activeSockets.entries()) {
        if (otherWs !== ws) {
          sendServerFrame(otherWs, {
            v: 1,
            typing: { conversation_id, is_typing },
          });
        }
      }
      return;
    }
  });

  ws.on('close', () => {
    activeSockets.delete(ws);
    logger.info('WebSocket connection closed', { remaining: activeSockets.size });
  });
});

try {
  await fastify.listen({ port: config.gatewayPort, host: '0.0.0.0' });
  logger.info(`Stealth Gateway listening on 0.0.0.0:${config.gatewayPort}`);
} catch (err) {
  logger.error('Failed to start Stealth Gateway', err);
  process.exit(1);
}
