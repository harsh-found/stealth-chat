import Fastify from 'fastify';
import cors from '@fastify/cors';
import fastifyWebsocket from '@fastify/websocket';
import { loadConfig, logger, uuidv7 } from '@stealth/core';
import { createDbPool } from '@stealth/db';
import { registerAuthRoutes } from './routes/auth.js';
import { registerUsersRoutes } from './routes/users.js';
import { registerConversationRoutes } from './routes/conversations.js';
import { registerWsGateway } from './routes/ws.js';

const config = loadConfig();
const fastify = Fastify({ logger: false });

await fastify.register(cors, { origin: true });
await fastify.register(fastifyWebsocket);

// Lazy database connection
let dbPool: ReturnType<typeof createDbPool> | null = null;
function getDb() {
  if (!dbPool) {
    dbPool = createDbPool(config.databaseUrl);
  }
  return dbPool.db;
}

// Health route
fastify.get('/health', async () => {
  return { status: 'ok', service: 'stealth-api', timestamp: Date.now() };
});

// Presigned Media Upload Ticket
fastify.post('/media/upload-ticket', async (req, reply) => {
  const body = req.body as {
    conversation_id?: string;
    kind?: string;
    size_bytes?: number;
    mime?: string;
  };

  if (!body.conversation_id) {
    return reply.status(400).send({ error: 'conversation_id is required' });
  }

  const mediaId = uuidv7();
  const uploadUrl = `https://storage.stealth.local/uploads/${mediaId}?ticket=${Date.now()}`;

  return {
    media_id: mediaId,
    upload_url: uploadUrl,
    expires_in_seconds: 900,
  };
});

// Register modular feature routes
registerAuthRoutes(fastify, getDb, config);
registerUsersRoutes(fastify, getDb, config);
registerConversationRoutes(fastify, getDb, config);
registerWsGateway(fastify, getDb, config);

try {
  await fastify.listen({ port: config.port, host: '0.0.0.0' });
  logger.info(`Stealth Unified API & Gateway listening on 0.0.0.0:${config.port}`);
} catch (err) {
  logger.error('Failed to start Stealth API server', err);
  process.exit(1);
}
