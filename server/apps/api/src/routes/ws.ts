import type { FastifyInstance } from 'fastify';
import { logger, verifyAccessToken, MessageService, type Config } from '@stealth/core';
import { decodeClientFrame, encodeServerFrame, type ServerFrame, type MessageNew } from '@stealth/contracts-ts';
import { conversations, messages, participants, type createDbPool } from '@stealth/db';
import { eq, and, sql } from 'drizzle-orm';
import type { WebSocket } from 'ws';

interface SocketCtx { ws: WebSocket; authenticated: boolean; userId?: string; deviceId?: string; }

export function registerWsGateway(
  fastify: FastifyInstance,
  getDb: () => ReturnType<typeof createDbPool>['db'],
  config: Config
) {
  const activeSockets = new Map<WebSocket, SocketCtx>();

  const send = (ws: WebSocket, frame: ServerFrame) => {
    if (ws.readyState === ws.OPEN) ws.send(encodeServerFrame(frame));
  };

  const sendToGroup = async (convId: string, frame: ServerFrame, skipWs?: WebSocket) => {
    try {
      const parts = await getDb().select({ uId: participants.userId }).from(participants).where(eq(participants.conversationId, convId));
      const set = new Set(parts.map((p) => p.uId));
      for (const [ws, c] of activeSockets.entries()) {
        if (ws !== skipWs && c.authenticated && (set.size === 0 || (c.userId && set.has(c.userId)))) {
          send(ws, frame);
        }
      }
    } catch {
      for (const [ws, c] of activeSockets.entries()) {
        if (ws !== skipWs && c.authenticated) send(ws, frame);
      }
    }
  };

  fastify.get('/ws', { websocket: true }, (socket) => {
    const ws = socket as unknown as WebSocket;
    const ctx: SocketCtx = { ws, authenticated: false };
    activeSockets.set(ws, ctx);

    ws.on('message', async (raw: Buffer) => {
      const frame = decodeClientFrame(raw);
      if (!frame) return;
      const { req_id, v } = frame;
      const db = getDb();

      if (frame.hello) {
        try {
          let userId = 'user_dev';
          try {
            userId = verifyAccessToken(frame.hello.access_token, config.jwtSecret).userId;
          } catch {
            if (config.nodeEnv === 'development') userId = 'dev_' + (frame.hello.device_id || 'anon').slice(0, 8);
            else throw new Error('UNAUTHENTICATED');
          }
          ctx.authenticated = true;
          ctx.userId = userId;
          ctx.deviceId = frame.hello.device_id;

          const convs = await db.select({
            cId: participants.conversationId, unread: participants.unreadCount,
            lastSeq: conversations.lastSeq, lastAt: conversations.lastMessageAt,
          }).from(participants).innerJoin(conversations, eq(participants.conversationId, conversations.id)).where(eq(participants.userId, userId));

          send(ws, {
            v: v || 1, req_id: req_id || '',
            hello_ok: {
              server_time_ms: Date.now(),
              changed_conversations: convs.map((c) => ({
                conversation_id: c.cId, last_seq: c.lastSeq || 0, unread_count: c.unread || 0,
                last_message_preview: '', last_message_at_ms: c.lastAt ? c.lastAt.getTime() : 0,
              })),
            },
          });
        } catch {
          send(ws, { v: v || 1, req_id: req_id || '', error: { req_id: req_id || '', code: 1, message: 'Authentication failed' } });
        }
        return;
      }

      if (frame.ping) {
        send(ws, { v: v || 1, req_id: req_id || '', pong: { timestamp_ms: Date.now() } });
        return;
      }

      if (!ctx.authenticated) {
        send(ws, { v: v || 1, req_id: req_id || '', error: { req_id: req_id || '', code: 1, message: 'Must authenticate first' } });
        return;
      }

      if (frame.send) {
        const { message_id, conversation_id, kind, payload, reply_to_id } = frame.send;
        const msgService = new MessageService(db as any);
        try {
          const conv = await db.select({ id: conversations.id }).from(conversations).where(eq(conversations.id, conversation_id)).limit(1);
          if (conv.length === 0) {
            await db.insert(conversations).values({ id: conversation_id, kind: 'direct', title: 'Direct Chat', createdBy: ctx.userId, lastSeq: 0 }).onConflictDoNothing();
            if (ctx.userId) await db.insert(participants).values({ conversationId: conversation_id, userId: ctx.userId, role: 'owner' }).onConflictDoNothing();
          }

          const payloadStr = typeof payload === 'string' ? payload : Buffer.from(payload as any).toString('base64');
          const isUuid = (id?: string) => !!id && /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(id);
          const res = await msgService.sendMessage({
            messageId: message_id, conversationId: conversation_id, senderId: ctx.userId || 'system',
            senderDeviceId: isUuid(ctx.deviceId) ? ctx.deviceId : undefined, kind: kind || 1, payload: payloadStr,
            replyToId: reply_to_id, clientTs: new Date(Number(frame.send.client_ts_ms) || Date.now()),
          });

          send(ws, { v: v || 1, req_id: req_id || '', ack: { message_id, seq: res.seq, server_ts_ms: res.serverTs } });

          await sendToGroup(conversation_id, {
            v: 1, message_new: {
              conversation_id, seq: res.seq, message_id, sender_id: ctx.userId || 'system',
              kind: (kind || 1) as any, payload: payloadStr, reply_to_id, server_ts_ms: res.serverTs, edit_version: 0,
            },
          });
        } catch (err: any) {
          logger.error('SendMessage error', { error: err?.message });
        }
        return;
      }

      if (frame.sync) {
        const { conversation_id, after_seq, limit } = frame.sync;
        const maxLimit = Math.min(Number(limit) || 50, 100);
        try {
          const rows = await db.select().from(messages).where(
            and(eq(messages.conversationId, conversation_id), sql`${messages.seq} > ${Number(after_seq) || 0}`)
          ).orderBy(messages.seq).limit(maxLimit);

          send(ws, {
            v: v || 1, req_id: req_id || '',
            sync_batch: {
              conversation_id, has_more: rows.length === maxLimit,
              messages: rows.map((r) => ({
                conversation_id: r.conversationId, seq: r.seq, message_id: r.id, sender_id: r.senderId,
                kind: r.kind as any, payload: r.payload, reply_to_id: r.replyToId || undefined,
                server_ts_ms: r.createdAt.getTime(), edit_version: r.editVersion || 0,
              })),
            },
          });
        } catch (err: any) {
          logger.error('SyncRequest error', { error: err?.message });
        }
        return;
      }

      if (frame.receipt) {
        const { conversation_id, delivered_upto_seq, read_upto_seq } = frame.receipt;
        try {
          await new MessageService(db as any).updateReceipt(
            conversation_id, ctx.userId || 'system', Number(delivered_upto_seq) || 0, Number(read_upto_seq) || 0
          );
        } catch (_) {}
        await sendToGroup(conversation_id, {
          v: 1, receipt: { conversation_id, user_id: ctx.userId || 'system', delivered_upto_seq, read_upto_seq },
        }, ws);
        return;
      }

      if (frame.typing) {
        await sendToGroup(frame.typing.conversation_id, { v: 1, typing: frame.typing }, ws);
      }
    });

    ws.on('close', () => {
      activeSockets.delete(ws);
    });
  });
}
