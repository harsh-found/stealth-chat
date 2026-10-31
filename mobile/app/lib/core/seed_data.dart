import 'package:stealth_db/stealth_db.dart';
import 'package:stealth_protocol/stealth_protocol.dart';

/// Seed initial conversations and messages directly into Drift SQLite
Future<void> seedInitialData(StealthDatabase db) async {
  final now = DateTime.now();

  // 1. Harsh (Lead)
  await db.upsertConversation(
    id: 'conv-01',
    title: 'Harsh (Lead)',
    lastSeq: 2,
    lastMessagePreview:
        'Local database is source of truth, receipts are monotonic cursors.',
    lastMessageAt: now.subtract(const Duration(minutes: 4)),
    unreadCount: 0,
  );
  await db.insertIncomingMessage(
    MessageNew(
      conversationId: 'conv-01',
      seq: 1,
      messageId: '018f0000-0000-7000-8000-000000000001',
      senderId: 'user-harsh',
      payload: const MessageBody(
        text:
            'All operational traffic is routed through encrypted SQLite and binary Protobuf.',
      ).toBytes(),
      serverTsMs:
          now.subtract(const Duration(minutes: 5)).millisecondsSinceEpoch,
    ),
    previewText:
        'All operational traffic is routed through encrypted SQLite and binary Protobuf.',
  );
  await db.insertIncomingMessage(
    MessageNew(
      conversationId: 'conv-01',
      seq: 2,
      messageId: '018f0000-0000-7000-8000-000000000002',
      senderId: 'user_me',
      payload: const MessageBody(
        text:
            'Local database is source of truth, receipts are monotonic cursors.',
      ).toBytes(),
      serverTsMs:
          now.subtract(const Duration(minutes: 4)).millisecondsSinceEpoch,
    ),
    previewText:
        'Local database is source of truth, receipts are monotonic cursors.',
  );
  await db.updatePeerReceipt(
    conversationId: 'conv-01',
    deliveredUptoSeq: 2,
    readUptoSeq: 2,
  );

  // 2. Stealth Gateway Alpha
  await db.upsertConversation(
    id: 'conv-02',
    title: 'Stealth Gateway Alpha',
    lastSeq: 2,
    lastMessagePreview:
        'Binary Protobuf frame sync established over WebSocket.',
    lastMessageAt: now.subtract(const Duration(hours: 1)),
    unreadCount: 2,
  );
  await db.insertIncomingMessage(
    MessageNew(
      conversationId: 'conv-02',
      seq: 1,
      messageId: '018f0000-0000-7000-8000-000000000003',
      senderId: 'gateway-node',
      payload: const MessageBody(
        text: 'Gateway online on port 3001. Ready for client handshake.',
      ).toBytes(),
      serverTsMs: now.subtract(const Duration(hours: 2)).millisecondsSinceEpoch,
    ),
    previewText: 'Gateway online on port 3001. Ready for client handshake.',
  );
  await db.insertIncomingMessage(
    MessageNew(
      conversationId: 'conv-02',
      seq: 2,
      messageId: '018f0000-0000-7000-8000-000000000004',
      senderId: 'gateway-node',
      payload: const MessageBody(
        text: 'Binary Protobuf frame sync established over WebSocket.',
      ).toBytes(),
      serverTsMs: now.subtract(const Duration(hours: 1)).millisecondsSinceEpoch,
    ),
    previewText: 'Binary Protobuf frame sync established over WebSocket.',
  );

  // 3. Core Ops Group
  await db.upsertConversation(
    id: 'conv-03',
    kind: 'group',
    title: 'Core Ops Group',
    lastSeq: 1,
    lastMessagePreview: 'Target SDK 36 edge-to-edge layout validated.',
    lastMessageAt: now.subtract(const Duration(days: 1)),
    unreadCount: 0,
  );
  await db.insertIncomingMessage(
    MessageNew(
      conversationId: 'conv-03',
      seq: 1,
      messageId: '018f0000-0000-7000-8000-000000000005',
      senderId: 'ops-lead',
      payload: const MessageBody(
        text: 'Target SDK 36 edge-to-edge layout validated.',
      ).toBytes(),
      serverTsMs: now.subtract(const Duration(days: 1)).millisecondsSinceEpoch,
    ),
    previewText: 'Target SDK 36 edge-to-edge layout validated.',
  );
}
