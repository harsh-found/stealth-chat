# 02 Realtime Protocol & Sync: Stealth Chat

## Wire Format
Binary Protobuf frames encapsulated in `stealth.v1.ClientFrame` and `stealth.v1.ServerFrame`.

### Key Frames
- `Hello`: Client initial handshake with `device_id` and auth token.
- `HelloOk`: Server ACK acknowledging handshake and returning sync info.
- `SendMessage`: Client sending a message with client-generated UUIDv7 `message_id`.
- `Ack`: Server ACK confirming `message_id`, monotonic `seq`, and server timestamp.
- `MessageNew`: Realtime broadcast to conversation participants with payload and `seq`.
- `ReceiptUpTo`: Client reporting receipt cursor (`delivered_upto_seq`, `read_upto_seq`).
- `ReceiptUpdate`: Server notification of peer receipt cursor advancement.
- `Typing`: Ephemeral typing beacon.
- `Ping` / `Pong`: Heartbeat keepalive every 25 seconds.
