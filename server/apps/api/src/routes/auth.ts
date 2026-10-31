import type { FastifyInstance } from 'fastify';
import {
  logger,
  signAccessToken,
  generateRefreshToken,
  hashToken,
  hashPassword,
  verifyPassword,
  uuidv7,
  otpProvider,
  type Config,
} from '@stealth/core';
import { users, devices, sessions, type createDbPool } from '@stealth/db';
import { eq } from 'drizzle-orm';

export function registerAuthRoutes(
  fastify: FastifyInstance,
  getDb: () => ReturnType<typeof createDbPool>['db'],
  config: Config
) {
  // Username & Password Registration
  const handleRegister = async (req: any, reply: any) => {
    const body = req.body as {
      username?: string;
      password?: string;
      display_name?: string;
      device_name?: string;
    };

    const cleanUsername = body?.username?.trim().toLowerCase();
    const cleanPassword = body?.password?.trim();
    const displayName = body?.display_name?.trim() || cleanUsername;

    if (!cleanUsername || cleanUsername.length < 3) {
      return reply.status(400).send({ error: 'Username must be at least 3 characters' });
    }
    if (!cleanPassword || cleanPassword.length < 6) {
      return reply.status(400).send({ error: 'Password must be at least 6 characters' });
    }

    const db = getDb();

    try {
      const existing = await db
        .select()
        .from(users)
        .where(eq(users.username, cleanUsername))
        .limit(1);

      if (existing.length > 0) {
        return reply.status(409).send({ error: 'Username is already taken' });
      }

      const userId = uuidv7();
      const deviceId = uuidv7();
      const passwordHash = hashPassword(cleanPassword);

      const [newUser] = await db
        .insert(users)
        .values({
          id: userId,
          username: cleanUsername,
          displayName: displayName || cleanUsername,
          passwordHash,
          about: 'Stealth Chat Operator',
        })
        .returning();

      await db.insert(devices).values({
        id: deviceId,
        userId: newUser.id,
        name: body.device_name || 'Android Device',
        platform: 'android',
      });

      const accessToken = signAccessToken(
        {
          userId: newUser.id,
          deviceId,
          username: newUser.username,
        },
        config.jwtSecret
      );

      const rawRefreshToken = generateRefreshToken();
      const familyId = uuidv7();
      const expiresAt = new Date(Date.now() + 30 * 24 * 60 * 60 * 1000);

      await db.insert(sessions).values({
        deviceId,
        familyId,
        refreshHash: hashToken(rawRefreshToken),
        expiresAt,
      });

      logger.info('User successfully registered', { userId: newUser.id });

      return {
        access_token: accessToken,
        refresh_token: rawRefreshToken,
        user: {
          id: newUser.id,
          username: newUser.username,
          display_name: newUser.displayName,
          about: newUser.about,
        },
        device_id: deviceId,
      };
    } catch (err: any) {
      logger.error('Registration failed', { error: err?.message });
      return reply.status(500).send({ error: 'Internal server error during registration' });
    }
  };

  fastify.post('/auth/register', handleRegister);
  fastify.post('/api/auth/register', handleRegister);

  // Username & Password Login
  const handleLogin = async (req: any, reply: any) => {
    const body = req.body as {
      username?: string;
      password?: string;
      device_name?: string;
    };

    const cleanUsername = body?.username?.trim().toLowerCase();
    const cleanPassword = body?.password?.trim();

    if (!cleanUsername || !cleanPassword) {
      return reply.status(400).send({ error: 'Username and password required' });
    }

    const db = getDb();

    try {
      const existing = await db
        .select()
        .from(users)
        .where(eq(users.username, cleanUsername))
        .limit(1);

      if (existing.length === 0) {
        return reply.status(401).send({ error: 'Invalid username or password' });
      }

      const user = existing[0];
      if (!user.passwordHash || !verifyPassword(cleanPassword, user.passwordHash)) {
        return reply.status(401).send({ error: 'Invalid username or password' });
      }

      const deviceId = uuidv7();
      await db.insert(devices).values({
        id: deviceId,
        userId: user.id,
        name: body.device_name || 'Android Device',
        platform: 'android',
      });

      const accessToken = signAccessToken(
        {
          userId: user.id,
          deviceId,
          username: user.username,
        },
        config.jwtSecret
      );

      const rawRefreshToken = generateRefreshToken();
      const familyId = uuidv7();
      const expiresAt = new Date(Date.now() + 30 * 24 * 60 * 60 * 1000);

      await db.insert(sessions).values({
        deviceId,
        familyId,
        refreshHash: hashToken(rawRefreshToken),
        expiresAt,
      });

      logger.info('User successfully logged in', { userId: user.id });

      return {
        access_token: accessToken,
        refresh_token: rawRefreshToken,
        user: {
          id: user.id,
          username: user.username,
          display_name: user.displayName,
          about: user.about,
        },
        device_id: deviceId,
      };
    } catch (err: any) {
      logger.error('Login failed', { error: err?.message });
      return reply.status(500).send({ error: 'Internal server error during login' });
    }
  };

  fastify.post('/auth/login', handleLogin);
  fastify.post('/api/auth/login', handleLogin);

  // OTP routes (kept for backwards compatibility)
  fastify.post('/auth/otp/send', async (req, reply) => {
    const body = req.body as { phone?: string };
    if (!body?.phone) {
      return reply.status(400).send({ error: 'Phone number required' });
    }
    const code = otpProvider.sendOtp(body.phone);
    return { success: true, message: 'OTP sent successfully', devCode: config.nodeEnv === 'development' ? code : undefined };
  });

  fastify.post('/auth/otp/verify', async (req, reply) => {
    const body = req.body as { phone?: string; code?: string; device_name?: string };
    if (!body?.phone || !body?.code) {
      return reply.status(400).send({ error: 'Phone and code required' });
    }
    const isValid = otpProvider.verifyOtp(body.phone, body.code);
    if (!isValid) {
      return reply.status(401).send({ error: 'Invalid or expired OTP' });
    }
    const db = getDb();
    const newUsername = 'stealth_' + body.phone.replace(/[^0-9]/g, '').slice(-6);
    const [user] = await db.insert(users).values({
      username: newUsername,
      displayName: 'Stealth Operator',
      phoneE164: body.phone,
    }).returning();
    const deviceId = uuidv7();
    await db.insert(devices).values({
      id: deviceId,
      userId: user.id,
      name: body.device_name || 'Android Device',
      platform: 'android',
    });
    const accessToken = signAccessToken({ userId: user.id, deviceId, username: user.username }, config.jwtSecret);
    return {
      access_token: accessToken,
      refresh_token: generateRefreshToken(),
      user: { id: user.id, username: user.username, display_name: user.displayName },
      device_id: deviceId,
    };
  });
}
