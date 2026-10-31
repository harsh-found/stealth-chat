import type { FastifyInstance } from 'fastify';
import { logger, verifyAccessToken, type Config } from '@stealth/core';
import {
  decodeClientFrame,
  encodeServerFrame,
  type ServerFrame,
  type MessageNew,
} from '@stealth/contracts-ts';
import { conversations, messages, receipts, participants, type createDbPool } from '@stealth/db';
import { eq, sql } from 'drizzle-orm';
import type { WebSocket } from 'ws';

interface SocketContext {
  ws: WebSocket;
  authenticated: boolean;
  userId?: string;
  deviceId?: string;
}

export function registerWsGateway(
  fastify: FastifyInstance,
  getDb: () => ReturnType<typeof createDbPool>['db'],
  config: Config
) {
  const activeSockets = new Map<WebSocket, SocketContext>();
  const convSequences = new Map<string, number>();
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

  fastify.get('/ws', { websocket: true }, (socket, req) => {
    const ws = socket as unknown as WebSocket;
    const ctx: SocketContext = { ws, authenticated: false };
    activeSockets.set(ws, ctx);
    logger.info('WebSocket client connected', { total: activeSockets.size });

    ws.on('message', async (raw: Buffer) => {
      const frame = decodeClientFrame(raw);
      if (!frame) {
        logger.warn('Failed to decode ClientFrame');
        return;
      }

      const { req_id, v } = frame;

      // 1. Hello handshake
      if (frame.hello) {
        const { access_token, device_id } = frame.hello;
        try {
          let userId = 'user_dev';
          try {
            const verified = verifyAccessToken(access_token, config.jwtSecret);
            userId = verified.userId;
          } catch {
            if (config.nodeEnv === 'development') {
              userId = 'dev_' + (device_id || 'anon').slice(0, 8);
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
        } catch {
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

      // Require auth
      if (!ctx.authenticated) {
        sendServerFrame(ws, {
          v: v || 1,
          req_id: req_id || '',
          error: {
            req_id: req_id || '',
            code: 1,
            message: 'Must authenticate with Hello frame first',
          },
        });
        return;
      }

      // 3. SendMessage
      if (frame.send) {
        const { message_id, conversation_id, kind, payload, reply_to_id } = frame.send;

        // In-memory or DB idempotency check
        const existing = processedMessages.get(message_id);
        if (existing) {
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

        const serverTs = Date.now();
        let nextSeq = (convSequences.get(conversation_id) || 0) + 1;
        convSequences.set(conversation_id, nextSeq);

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

        // Persist asynchronously to Neon DB
        try {
          const db = getDb();
          await db
            .insert(messages)
            .values({
              id: message_id,
              conversationId: conversation_id,
              seq: nextSeq,
              senderId: ctx.userId || 'system',
              kind: kind || 1,
              payload,
              replyToId: reply_to_id,
              clientTs: new Date(serverTs),
            })
            .onConflictDoNothing();

          await db
            .update(conversations)
            .set({
              lastSeq: nextSeq,
              lastMessageId: message_id,
              lastMessageAt: new Date(serverTs),
            })
            .where(eq(conversations.id, conversation_id));
        } catch (dbErr) {
          logger.warn('Failed to persist message to Postgres', { error: dbErr });
        }

        // Send Ack
        sendServerFrame(ws, {
          v: v || 1,
          req_id: req_id || '',
          ack: {
            message_id,
            seq: nextSeq,
            server_ts_ms: serverTs,
          },
        });

        // Broadcast to all active sockets
        broadcastFrame({
          v: 1,
          message_new: newMsg,
        });
        return;
      }

      // 4. ReceiptUpTo
      if (frame.receipt) {
        const { conversation_id, delivered_upto_seq, read_upto_seq } = frame.receipt;
        try {
          const db = getDb();
          await db
            .update(participants)
            .set({
              lastDeliveredSeq: delivered_upto_seq,
              lastReadSeq: read_upto_seq,
            })
            .where(eq(participants.conversationId, conversation_id));
        } catch (dbErr) {
          logger.warn('Failed to update receipt in Postgres', { error: dbErr });
        }

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
      logger.info('WebSocket client disconnected', { remaining: activeSockets.size });
    });
  });
}
