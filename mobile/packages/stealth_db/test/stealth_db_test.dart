import 'dart:convert';
import 'dart:typed_data';
import 'package:drift/native.dart';
import 'package:stealth_db/stealth_db.dart';
import 'package:stealth_protocol/stealth_protocol.dart';
import 'package:test/test.dart';

void main() {
  late StealthDatabase db;

  setUp(() {
    // In-memory native SQLite database
    db = StealthDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('StealthDatabase', () {
    test('sendOptimisticMessage inserts message and outbox row atomically',
        () async {
      await db.upsertConversation(
        id: 'conv_1',
        title: 'Alice',
        lastSeq: 5,
      );

      final msg = await db.sendOptimisticMessage(
        messageId: '018f0000-0000-7000-8000-000000000001',
        conversationId: 'conv_1',
        senderId: 'user_me',
        payload: Uint8List.fromList(utf8.encode('Hello Alice!')),
        previewText: 'Hello Alice!',
      );

      expect(msg.id, equals('018f0000-0000-7000-8000-000000000001'));
      expect(msg.state, equals('pending'));
      // Pending sortKey is (lastSeq + 1) * 1024 + 1 = 6 * 1024 + 1 = 6145
      expect(msg.sortKey, equals(BigInt.from(6145)));

      final pendingOutbox = await db.getPendingItems();
      expect(pendingOutbox.length, equals(1));
      expect(pendingOutbox.first.messageId, equals(msg.id));
    });

    test('handleAck updates message state to sent and removes outbox entry',
        () async {
      await db.upsertConversation(id: 'conv_1', lastSeq: 5);
      await db.sendOptimisticMessage(
        messageId: 'msg_ack_test',
        conversationId: 'conv_1',
        senderId: 'user_me',
        payload: Uint8List.fromList(utf8.encode('Ack me')),
        previewText: 'Ack me',
      );

      await db.handleAck(
        messageId: 'msg_ack_test',
        seq: 6,
        serverTsMs: 1700000000000,
      );

      final messages = await db.watchMessagesPaged('conv_1').first;
      expect(messages.length, equals(1));
      final msg = messages.first;
      expect(msg.state, equals('sent'));
      expect(msg.seq, equals(BigInt.from(6)));
      // Confirmed sortKey is seq * 1024 = 6 * 1024 = 6144
      expect(msg.sortKey, equals(BigInt.from(6144)));

      final pendingOutbox = await db.getPendingItems();
      expect(pendingOutbox, isEmpty);
    });

    test('insertIncomingMessage and peer receipts', () async {
      final incoming = MessageNew(
        conversationId: 'conv_1',
        seq: 7,
        messageId: 'msg_incoming_7',
        senderId: 'user_alice',
        payload: Uint8List.fromList(utf8.encode('Hey there!')),
        serverTsMs: 1700000001000,
      );

      await db.insertIncomingMessage(incoming, previewText: 'Hey there!');

      final messages = await db.watchMessagesPaged('conv_1').first;
      expect(messages.length, equals(1));
      expect(messages.first.id, equals('msg_incoming_7'));
      expect(messages.first.seq, equals(BigInt.from(7)));

      // Peer cursor update
      await db.updatePeerReceipt(
        conversationId: 'conv_1',
        deliveredUptoSeq: 7,
        readUptoSeq: 7,
      );

      final conv = await db.watchConversation('conv_1').first;
      expect(conv?.peerDeliveredSeq, equals(BigInt.from(7)));
      expect(conv?.peerReadSeq, equals(BigInt.from(7)));
    });

    test('offline FTS5 search finds messages by content', () async {
      await db.sendOptimisticMessage(
        messageId: 'msg_fts_1',
        conversationId: 'conv_1',
        senderId: 'user_me',
        payload:
            Uint8List.fromList(utf8.encode('Secret rendezvous at midnight')),
        previewText: 'Secret rendezvous at midnight',
      );

      await db.sendOptimisticMessage(
        messageId: 'msg_fts_2',
        conversationId: 'conv_1',
        senderId: 'user_me',
        payload: Uint8List.fromList(utf8.encode('Just a regular text')),
        previewText: 'Just a regular text',
      );

      final searchResults = await db.searchMessages('rendezvous');
      expect(searchResults.length, equals(1));
      expect(searchResults.first.id, equals('msg_fts_1'));
    });

    test('consecutive optimistic sends have strictly increasing sortKeys',
        () async {
      await db.upsertConversation(id: 'conv_fifo', lastSeq: 10);

      final msg1 = await db.sendOptimisticMessage(
        messageId: 'msg_1',
        conversationId: 'conv_fifo',
        senderId: 'user_me',
        payload: Uint8List.fromList(utf8.encode('First')),
        previewText: 'First',
      );

      final msg2 = await db.sendOptimisticMessage(
        messageId: 'msg_2',
        conversationId: 'conv_fifo',
        senderId: 'user_me',
        payload: Uint8List.fromList(utf8.encode('Second')),
        previewText: 'Second',
      );

      expect(msg2.sortKey > msg1.sortKey, isTrue);
      expect(msg2.sortKey, equals(msg1.sortKey + BigInt.one));
    });
  });
}
