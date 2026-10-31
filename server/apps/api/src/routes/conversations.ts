import type { FastifyInstance } from 'fastify';
import { verifyAccessToken, uuidv7, type Config } from '@stealth/core';
import { conversations, participants, messages, users, type createDbPool } from '@stealth/db';
import { eq, and, desc } from 'drizzle-orm';

function getAuthUserId(req: any, jwtSecret: string): string | null {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith('Bearer ')) return null;
  try {
    const payload = verifyAccessToken(authHeader.slice(7), jwtSecret);
    return payload.userId;
  } catch {
    return null;
  }
}

export function registerConversationRoutes(
  fastify: FastifyInstance,
  getDb: () => ReturnType<typeof createDbPool>['db'],
  config: Config
) {
  // Create or get direct conversation
  const handleCreateOrGet = async (req: any, reply: any) => {
    const currentUserId = getAuthUserId(req, config.jwtSecret);
    if (!currentUserId) {
      return reply.status(401).send({ error: 'Unauthorized' });
    }

    const body = req.body as { peer_id?: string; peer_username?: string; title?: string };
    const db = getDb();

    let peerId = body.peer_id;
    if (!peerId && body.peer_username) {
      const found = await db
        .select()
        .from(users)
        .where(eq(users.username, body.peer_username.trim().toLowerCase()))
        .limit(1);
      if (found.length > 0) {
        peerId = found[0].id;
      }
    }

    if (!peerId) {
      return reply.status(400).send({ error: 'Valid peer_id or peer_username required' });
    }

    if (peerId === currentUserId) {
      return reply.status(400).send({ error: 'Cannot start conversation with yourself' });
    }

    // Direct key ensures one conversation per direct user pair
    const directKey = [currentUserId, peerId].sort().join(':');

    try {
      const existing = await db
        .select()
        .from(conversations)
        .where(eq(conversations.directKey, directKey))
        .limit(1);

      if (existing.length > 0) {
        return { conversation: existing[0] };
      }

      // Find peer display name
      const peerUsers = await db
        .select()
        .from(users)
        .where(eq(users.id, peerId))
        .limit(1);
      const peer = peerUsers[0];
      const conversationTitle = body.title || peer?.displayName || 'Direct Chat';

      const conversationId = uuidv7();

      const [newConv] = await db
        .insert(conversations)
        .values({
          id: conversationId,
          kind: 'direct',
          directKey,
          title: conversationTitle,
          createdBy: currentUserId,
          lastSeq: 0,
        })
        .returning();

      // Insert both participants
      await db.insert(participants).values([
        {
          conversationId,
          userId: currentUserId,
          role: 'owner',
        },
        {
          conversationId,
          userId: peerId,
          role: 'member',
        },
      ]);

      return {
        conversation: {
          ...newConv,
          peer: peer
            ? {
                id: peer.id,
                username: peer.username,
                display_name: peer.displayName,
              }
            : undefined,
        },
      };
    } catch (err: any) {
      return reply.status(500).send({ error: 'Failed to create conversation' });
    }
  };

  fastify.post('/conversations', handleCreateOrGet);
  fastify.post('/api/conversations', handleCreateOrGet);

  // List conversations for user
  const handleList = async (req: any, reply: any) => {
    const currentUserId = getAuthUserId(req, config.jwtSecret);
    if (!currentUserId) {
      return reply.status(401).send({ error: 'Unauthorized' });
    }

    const db = getDb();
    try {
      const userParticipants = await db
        .select({
          conversationId: participants.conversationId,
          unreadCount: participants.unreadCount,
          lastReadSeq: participants.lastReadSeq,
        })
        .from(participants)
        .where(eq(participants.userId, currentUserId));

      const conversationList = [];
      for (const p of userParticipants) {
        const convRows = await db
          .select()
          .from(conversations)
          .where(eq(conversations.id, p.conversationId))
          .limit(1);

        if (convRows.length > 0) {
          conversationList.push({
            ...convRows[0],
            unread_count: p.unreadCount,
          });
        }
      }

      return { conversations: conversationList };
    } catch (err: any) {
      return reply.status(500).send({ error: 'Failed to fetch conversations' });
    }
  };

  fastify.get('/conversations', handleList);
  fastify.get('/api/conversations', handleList);

  // List messages for a conversation
  const handleMessages = async (req: any, reply: any) => {
    const conversationId = req.params?.id;
    if (!conversationId) {
      return reply.status(400).send({ error: 'conversation id required' });
    }

    const db = getDb();
    try {
      const msgs = await db
        .select()
        .from(messages)
        .where(eq(messages.conversationId, conversationId))
        .orderBy(desc(messages.seq))
        .limit(50);

      return { messages: msgs.reverse() };
    } catch (err: any) {
      return reply.status(500).send({ error: 'Failed to fetch messages' });
    }
  };

  fastify.get('/conversations/:id/messages', handleMessages);
  fastify.get('/api/conversations/:id/messages', handleMessages);
}
