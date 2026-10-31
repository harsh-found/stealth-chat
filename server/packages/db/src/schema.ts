import {
  pgTable,
  uuid,
  text,
  timestamp,
  jsonb,
  integer,
  bigint,
  smallint,
  primaryKey,
  uniqueIndex,
  index,
  bigserial,
} from 'drizzle-orm/pg-core';

export const users = pgTable('users', {
  id: uuid('id').primaryKey().defaultRandom(),
  username: text('username').notNull().unique(),
  displayName: text('display_name').notNull(),
  about: text('about').notNull().default(''),
  avatarMediaId: uuid('avatar_media_id'),
  phoneE164: text('phone_e164').unique(),
  privacy: jsonb('privacy').notNull().default({}),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
  deletedAt: timestamp('deleted_at', { withTimezone: true }),
});

export const devices = pgTable('devices', {
  id: uuid('id').primaryKey().defaultRandom(),
  userId: uuid('user_id').notNull().references(() => users.id, { onDelete: 'cascade' }),
  name: text('name').notNull(),
  platform: text('platform').notNull().default('android'),
  fcmToken: text('fcm_token'),
  lastSeenAt: timestamp('last_seen_at', { withTimezone: true }),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
  revokedAt: timestamp('revoked_at', { withTimezone: true }),
});

export const sessions = pgTable('sessions', {
  id: uuid('id').primaryKey().defaultRandom(),
  deviceId: uuid('device_id').notNull().references(() => devices.id, { onDelete: 'cascade' }),
  familyId: uuid('family_id').notNull(),
  refreshHash: text('refresh_hash').notNull().unique(),
  expiresAt: timestamp('expires_at', { withTimezone: true }).notNull(),
  rotatedAt: timestamp('rotated_at', { withTimezone: true }),
  revokedAt: timestamp('revoked_at', { withTimezone: true }),
});

export const conversations = pgTable('conversations', {
  id: uuid('id').primaryKey().defaultRandom(),
  kind: text('kind').notNull().default('direct'), // 'direct', 'group', 'channel'
  directKey: text('direct_key').unique(),
  title: text('title'),
  avatarMediaId: uuid('avatar_media_id'),
  createdBy: uuid('created_by').references(() => users.id),
  lastSeq: bigint('last_seq', { mode: 'number' }).notNull().default(0),
  lastMessageId: uuid('last_message_id'),
  lastMessageAt: timestamp('last_message_at', { withTimezone: true }),
  settings: jsonb('settings').notNull().default({}),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
});

export const participants = pgTable(
  'participants',
  {
    conversationId: uuid('conversation_id').notNull().references(() => conversations.id, { onDelete: 'cascade' }),
    userId: uuid('user_id').notNull().references(() => users.id, { onDelete: 'cascade' }),
    role: text('role').notNull().default('member'), // 'owner', 'admin', 'member'
    joinedAt: timestamp('joined_at', { withTimezone: true }).notNull().defaultNow(),
    leftAt: timestamp('left_at', { withTimezone: true }),
    lastDeliveredSeq: bigint('last_delivered_seq', { mode: 'number' }).notNull().default(0),
    lastReadSeq: bigint('last_read_seq', { mode: 'number' }).notNull().default(0),
    unreadCount: integer('unread_count').notNull().default(0),
    mentionCount: integer('mention_count').notNull().default(0),
    mutedUntil: timestamp('muted_until', { withTimezone: true }),
    version: bigint('version', { mode: 'number' }).notNull().default(1),
  },
  (table) => ({
    pk: primaryKey({ columns: [table.conversationId, table.userId] }),
    userVersionIdx: index('participants_user_version_idx').on(table.userId, table.version),
  })
);

export const messages = pgTable(
  'messages',
  {
    id: uuid('id').primaryKey(), // Client-generated UUIDv7
    conversationId: uuid('conversation_id').notNull().references(() => conversations.id, { onDelete: 'cascade' }),
    seq: bigint('seq', { mode: 'number' }).notNull(),
    senderId: uuid('sender_id').notNull().references(() => users.id),
    senderDeviceId: uuid('sender_device_id').references(() => devices.id),
    kind: smallint('kind').notNull().default(1),
    payload: text('payload').notNull(), // Opaque payload string (base64 or json)
    replyToId: uuid('reply_to_id'),
    editVersion: integer('edit_version').notNull().default(0),
    deletedAt: timestamp('deleted_at', { withTimezone: true }),
    expiresAt: timestamp('expires_at', { withTimezone: true }),
    clientTs: timestamp('client_ts', { withTimezone: true }).notNull(),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (table) => ({
    convSeqIdx: uniqueIndex('messages_conv_seq_idx').on(table.conversationId, table.seq),
  })
);

export const outboxEvents = pgTable('outbox_events', {
  id: bigserial('id', { mode: 'number' }).primaryKey(),
  topic: text('topic').notNull(),
  payload: jsonb('payload').notNull(),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
  processedAt: timestamp('processed_at', { withTimezone: true }),
});
