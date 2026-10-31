# 03 Data Model: PostgreSQL & Drift

## Server (PostgreSQL 18)
- `users`: id (uuidv7), username (citext), display_name, phone_e164, privacy (jsonb)
- `devices`: id (uuidv7), user_id, fcm_token, platform, last_seen_at
- `sessions`: id (uuidv7), device_id, family_id, refresh_hash, expires_at
- `conversations`: id (uuidv7), kind ('direct'|'group'|'channel'), direct_key, last_seq, settings
- `participants`: conversation_id, user_id, role, last_delivered_seq, last_read_seq, unread_count, version
- `messages`: id (uuidv7 client key), conversation_id, seq, sender_id, kind, payload (bytea), client_ts, created_at

## Mobile (Drift SQLite3 Multiple Ciphers)
- `conversations`: id, kind, title, avatar_ref, last_seq, unread_count, peer_delivered_seq, peer_read_seq
- `messages`: id, conversation_id, seq, sort_key, sender_id, kind, payload, state ('pending'|'sending'|'sent'|'failed')
- `outbox`: id, message_id, op, payload, attempts, next_try_at
