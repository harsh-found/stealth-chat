import type { FastifyInstance } from 'fastify';
import { verifyAccessToken, type Config } from '@stealth/core';
import { users, type createDbPool } from '@stealth/db';
import { ilike, or, isNull } from 'drizzle-orm';

export function registerUsersRoutes(
  fastify: FastifyInstance,
  getDb: () => ReturnType<typeof createDbPool>['db'],
  config: Config
) {
  // Current user info
  const handleMe = async (req: any, reply: any) => {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return reply.status(401).send({ error: 'Unauthorized' });
    }

    const token = authHeader.slice(7);
    try {
      const payload = verifyAccessToken(token, config.jwtSecret);
      const db = getDb();
      const rows = await db
        .select()
        .from(users)
        .where(isNull(users.deletedAt))
        .limit(1);

      return {
        user_id: payload.userId,
        device_id: payload.deviceId,
        username: payload.username,
      };
    } catch {
      return reply.status(401).send({ error: 'Invalid or expired token' });
    }
  };

  fastify.get('/users/me', handleMe);
  fastify.get('/api/users/me', handleMe);

  // Search users by query
  const handleSearch = async (req: any, reply: any) => {
    const query = (req.query?.q as string)?.trim() || '';
    const db = getDb();

    try {
      if (!query) {
        // Return recent active users (limit 20)
        const recent = await db
          .select({
            id: users.id,
            username: users.username,
            displayName: users.displayName,
            about: users.about,
            avatarMediaId: users.avatarMediaId,
            createdAt: users.createdAt,
          })
          .from(users)
          .where(isNull(users.deletedAt))
          .limit(20);

        return { users: recent };
      }

      const pattern = `%${query}%`;
      const results = await db
        .select({
          id: users.id,
          username: users.username,
          displayName: users.displayName,
          about: users.about,
          avatarMediaId: users.avatarMediaId,
          createdAt: users.createdAt,
        })
        .from(users)
        .where(
          or(
            ilike(users.username, pattern),
            ilike(users.displayName, pattern)
          )
        )
        .limit(20);

      return { users: results };
    } catch (err: any) {
      return reply.status(500).send({ error: 'Failed to search users' });
    }
  };

  fastify.get('/users/search', handleSearch);
  fastify.get('/api/users/search', handleSearch);
}
