import { sql, eq, and } from 'drizzle-orm';
import { conversations, messages, participants, outboxEvents } from '@stealth/db';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import * as schema from '@stealth/db';

export interface SendMessageParams {
  messageId: string;
  conversationId: string;
  senderId: string;
  senderDeviceId?: string;
  kind?: number;
  payload: string;
  replyToId?: string;
  clientTs: Date;
}

export interface SendMessageResult {
  messageId: string;
  conversationId: string;
  seq: number;
  serverTs: number;
  isDuplicate: boolean;
}

export class MessageService {
  constructor(private db: NodePgDatabase<typeof schema>) {}

  async sendMessage(params: SendMessageParams): Promise<SendMessageResult> {
    return await this.db.transaction(async (tx) => {
      // 1. Check idempotency: does messageId already exist?
      const existing = await tx
        .select()
        .from(messages)
        .where(eq(messages.id, params.messageId))
        .limit(1);

      if (existing.length > 0) {
        const found = existing[0];
        if (found.senderId !== params.senderId || found.conversationId !== params.conversationId) {
          throw new Error('FORBIDDEN: Message ID squatted or mismatch');
        }
        return {
          messageId: found.id,
          conversationId: found.conversationId,
          seq: found.seq,
          serverTs: found.createdAt.getTime(),
          isDuplicate: true,
        };
      }

      // 2. Increment conversation last_seq atomically
      const updatedConv = await tx
        .update(conversations)
        .set({
          lastSeq: sql`${conversations.lastSeq} + 1`,
          lastMessageId: params.messageId,
          lastMessageAt: sql`now()`,
        })
        .where(eq(conversations.id, params.conversationId))
        .returning({ lastSeq: conversations.lastSeq });

      if (updatedConv.length === 0) {
        throw new Error('NOT_FOUND: Conversation does not exist');
      }

      const assignedSeq = updatedConv[0].lastSeq;
      const now = new Date();

      // 3. Insert the message row
      await tx.insert(messages).values({
        id: params.messageId,
        conversationId: params.conversationId,
        seq: assignedSeq,
        senderId: params.senderId,
        senderDeviceId: params.senderDeviceId,
        kind: params.kind ?? 1,
        payload: params.payload,
        replyToId: params.replyToId,
        clientTs: params.clientTs,
        createdAt: now,
      });

      // 4. Bump participants version
      await tx
        .update(participants)
        .set({
          version: sql`${participants.version} + 1`,
          unreadCount: sql`CASE WHEN ${participants.userId} = ${params.senderId} THEN ${participants.unreadCount} ELSE ${participants.unreadCount} + 1 END`,
        })
        .where(eq(participants.conversationId, params.conversationId));

      // 5. Append outbox event for fanout / FCM
      await tx.insert(outboxEvents).values({
        topic: 'message.new',
        payload: {
          conversation_id: params.conversationId,
          seq: assignedSeq,
          message_id: params.messageId,
          sender_id: params.senderId,
          kind: params.kind ?? 1,
          payload: params.payload,
          reply_to_id: params.replyToId,
          server_ts_ms: now.getTime(),
        },
      });

      return {
        messageId: params.messageId,
        conversationId: params.conversationId,
        seq: assignedSeq,
        serverTs: now.getTime(),
        isDuplicate: false,
      };
    });
  }

  async updateReceipt(
    conversationId: string,
    userId: string,
    deliveredUptoSeq: number,
    readUptoSeq: number
  ): Promise<void> {
    await this.db.transaction(async (tx) => {
      await tx
        .update(participants)
        .set({
          lastDeliveredSeq: sql`GREATEST(${participants.lastDeliveredSeq}, ${deliveredUptoSeq})`,
          lastReadSeq: sql`GREATEST(${participants.lastReadSeq}, ${readUptoSeq})`,
          unreadCount: sql`CASE WHEN ${readUptoSeq} >= ${participants.lastReadSeq} THEN 0 ELSE ${participants.unreadCount} END`,
          version: sql`${participants.version} + 1`,
        })
        .where(
          and(
            eq(participants.conversationId, conversationId),
            eq(participants.userId, userId)
          )
        );

      await tx.insert(outboxEvents).values({
        topic: 'receipt.update',
        payload: {
          conversation_id: conversationId,
          user_id: userId,
          delivered_upto_seq: deliveredUptoSeq,
          read_upto_seq: readUptoSeq,
        },
      });
    });
  }
}
