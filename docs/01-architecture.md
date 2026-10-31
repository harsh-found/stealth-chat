# 01 Architecture: Stealth Chat

## Core Principles
1. **Client-Generated UUIDv7**: Eliminates optimistic reconcile bugs.
2. **Monotonic Conversation `seq`**: Server sequence numbers ensure deterministic ordering.
3. **Cursor-Based Receipts**: `last_delivered_seq` and `last_read_seq` replace per-message receipt tracking.
4. **Binary Wire Contract**: Versioned Protobuf messages exchanged over WebSocket.
5. **Direct Object Storage**: Media uploaded via presigned URLs directly to R2/S3.

## System Topology
```
           [ Mobile Client (Flutter + Drift) ]
                       │             ▲
              REST API │             │ Binary Protobuf WSS
                       ▼             │
             [ Fastify API ]   [ Gateway Node ]
                   │                  │
                   ▼                  ▼
             [ PostgreSQL 18 ] ─── [ Redis ] ─── [ BullMQ Worker ]
```
