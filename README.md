# Signal (Stealth Chat)

A production-grade, privacy-first Android chat application and realtime backend built with Flutter, Fastify, PostgreSQL 18, Redis, and Protobuf wire contracts.

## Architecture Highlights
- **Binary Protobuf over WebSocket**: Zero-drift wire contracts defined in `contracts/`.
- **Client-generated UUIDv7**: True idempotency without fragile temp-to-server-id reconcile.
- **Server Monotonic `seq`**: Strictly ordered conversations; receipts are member-level cursors (`last_delivered_seq`, `last_read_seq`).
- **Encrypted Local Database**: SQLite3 Multiple Ciphers with Drift running on a dedicated isolate.
- **Optimistic Sends & Outbox**: Instant 120 FPS UI updates, background outbox sync with backoff.
- **Stealth Dark Design**: `#101010` backdrop, `#1C1C1C` cards, `#262626` bubble borders, `#2563EB` electric accent, swipe-to-reply, audio waveform scrubbers, and zero-flicker keyboard tray.

## Structure
```
├── contracts/       # Protobuf definitions and generated contracts
├── server/          # Node 24 Fastify REST API, WebSocket Gateway & BullMQ worker
├── mobile/          # Flutter Android application (Riverpod 3 + Drift + UI Kit)
├── tools/           # Mock gateway & testing harnesses
└── docs/            # Architecture, protocol, security, and UI specifications
```
