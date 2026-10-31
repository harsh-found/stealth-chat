import 'dart:async';
import 'dart:typed_data';
import 'package:drift/drift.dart';
import 'package:stealth_protocol/stealth_protocol.dart';
import 'package:stealth_sync/stealth_sync.dart';

import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Conversations,
    ConversationMembers,
    Messages,
    OutboxEntries,
    MediaFiles,
    Reactions,
    UsersCache,
    SyncStates,
  ],
)
class StealthDatabase extends _$StealthDatabase implements OutboxStorage {
  StealthDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          // SQLite FTS5 table for offline full-text search
          await customStatement(
            'CREATE VIRTUAL TABLE IF NOT EXISTS messages_fts USING fts5('
            'message_id UNINDEXED, '
            'conversation_id UNINDEXED, '
            'content'
            ');',
          );
          // Keyset index for Impeller 120 FPS reverse scrolling
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_messages_conversation_sort '
            'ON messages (conversation_id, sort_key DESC);',
          );
        },
      );

  // --- OutboxStorage implementation for stealth_sync ---

  @override
  Future<List<OutboxItem>> getPendingItems() async {
    final entries = await (select(outboxEntries)
          ..orderBy([(t) => OrderingTerm.asc(t.clientTsMs)]))
        .get();

    return entries.map((e) {
      return OutboxItem(
        id: e.id,
        messageId: e.messageId,
        conversationId: e.conversationId,
        kind: MessageKind.fromValue(e.kind),
        payload: e.payload,
        replyToId: e.replyToId,
        clientTsMs: e.clientTsMs.toInt(),
        attempts: e.attempts,
        nextTryAt: e.nextTryAt,
      );
    }).toList();
  }

  @override
  Future<void> saveItem(OutboxItem item) async {
    await into(outboxEntries).insertOnConflictUpdate(
      OutboxEntriesCompanion.insert(
        id: item.id,
        messageId: item.messageId,
        conversationId: item.conversationId,
        kind: Value(item.kind.value),
        payload: item.payload,
        replyToId: Value(item.replyToId),
        clientTsMs: BigInt.from(item.clientTsMs),
        attempts: Value(item.attempts),
        nextTryAt: Value(item.nextTryAt),
      ),
    );
  }

  @override
  Future<void> removeItem(String messageId) async {
    await (delete(outboxEntries)..where((t) => t.messageId.equals(messageId)))
        .go();
  }

  @override
  Future<void> markFailed(String messageId, {int? retryAfterMs}) async {
    final entry = await (select(outboxEntries)
          ..where((t) => t.messageId.equals(messageId)))
        .getSingleOrNull();

    if (entry != null) {
      final nextTry = retryAfterMs != null
          ? DateTime.now().add(Duration(milliseconds: retryAfterMs))
          : null;
      await (update(outboxEntries)..where((t) => t.messageId.equals(messageId)))
          .write(
        OutboxEntriesCompanion(
          attempts: Value(entry.attempts + 1),
          nextTryAt: Value(nextTry),
        ),
      );
    }
  }

  // --- Conversations Operations ---

  Stream<List<Conversation>> watchConversations() {
    return (select(conversations)
          ..orderBy([
            (t) => OrderingTerm.desc(t.pinnedAt),
            (t) => OrderingTerm.desc(t.lastMessageAt),
          ]))
        .watch();
  }

  Stream<Conversation?> watchConversation(String id) {
    return (select(conversations)..where((t) => t.id.equals(id)))
        .watchSingleOrNull();
  }

  Future<void> upsertConversation({
    required String id,
    String kind = 'direct',
    String? title,
    String? avatarRef,
    int lastSeq = 0,
    String? lastMessagePreview,
    DateTime? lastMessageAt,
    int unreadCount = 0,
  }) async {
    await into(conversations).insert(
      ConversationsCompanion.insert(
        id: id,
        kind: Value(kind),
        title: Value(title),
        avatarRef: Value(avatarRef),
        lastSeq: Value(BigInt.from(lastSeq)),
        lastMessagePreview: Value(lastMessagePreview),
        lastMessageAt: Value(lastMessageAt),
        unreadCount: Value(unreadCount),
      ),
      onConflict: DoUpdate((old) => ConversationsCompanion(
            title: title != null ? Value(title) : const Value.absent(),
            avatarRef:
                avatarRef != null ? Value(avatarRef) : const Value.absent(),
            lastSeq: lastSeq > 0
                ? Value(BigInt.from(lastSeq))
                : const Value.absent(),
            lastMessagePreview: lastMessagePreview != null
                ? Value(lastMessagePreview)
                : const Value.absent(),
            lastMessageAt: lastMessageAt != null
                ? Value(lastMessageAt)
                : const Value.absent(),
            unreadCount:
                unreadCount > 0 ? Value(unreadCount) : const Value.absent(),
          )),
    );
  }

  // --- Messages Operations ---

  Stream<List<Message>> watchMessagesPaged(
    String conversationId, {
    int limit = 40,
    BigInt? beforeSortKey,
  }) {
    final query = select(messages)
      ..where((t) => t.conversationId.equals(conversationId));

    if (beforeSortKey != null) {
      query.where((t) => t.sortKey.isSmallerThanValue(beforeSortKey));
    }

    query
      ..orderBy([(t) => OrderingTerm.desc(t.sortKey)])
      ..limit(limit);

    return query.watch();
  }

  /// Sends an optimistic message and records it in the outbox in ONE transaction.
  Future<Message> sendOptimisticMessage({
    required String messageId,
    required String conversationId,
    required String senderId,
    required Uint8List payload,
    MessageKind kind = MessageKind.text,
    String? replyToId,
    String? previewText,
  }) async {
    return transaction(() async {
      final conv = await (select(conversations)
            ..where((t) => t.id.equals(conversationId)))
          .getSingleOrNull();

      final currentLastSeq = conv?.lastSeq ?? BigInt.zero;
      // Pending sortKey: (highest known seq + 1) * 1024 + local counter (master plan Section 7)
      final pendingSortKey =
          (currentLastSeq + BigInt.one) * BigInt.from(1024) + BigInt.from(1);

      final now = DateTime.now();

      final messageCompanion = MessagesCompanion.insert(
        id: messageId,
        conversationId: conversationId,
        seq: const Value.absent(),
        sortKey: pendingSortKey,
        senderId: senderId,
        kind: Value(kind.value),
        payload: payload,
        searchText: Value(previewText),
        state: const Value('pending'),
        replyToId: Value(replyToId),
        createdLocalAt: now,
      );

      await into(messages).insert(messageCompanion);

      if (previewText != null && previewText.isNotEmpty) {
        await customStatement(
          'INSERT INTO messages_fts (message_id, conversation_id, content) VALUES (?, ?, ?);',
          [messageId, conversationId, previewText],
        );
      }

      await into(outboxEntries).insert(
        OutboxEntriesCompanion.insert(
          id: 'out_$messageId',
          messageId: messageId,
          conversationId: conversationId,
          kind: Value(kind.value),
          payload: payload,
          replyToId: Value(replyToId),
          clientTsMs: BigInt.from(now.millisecondsSinceEpoch),
        ),
      );

      await into(conversations).insert(
        ConversationsCompanion.insert(
          id: conversationId,
          lastMessagePreview: Value(previewText),
          lastMessageAt: Value(now),
        ),
        onConflict: DoUpdate((old) => ConversationsCompanion(
              lastMessagePreview: Value(previewText),
              lastMessageAt: Value(now),
            )),
      );

      return (select(messages)..where((t) => t.id.equals(messageId)))
          .getSingle();
    });
  }

  /// Reconciles an optimistic message when Ack arrives.
  Future<void> handleAck({
    required String messageId,
    required int seq,
    required int serverTsMs,
  }) async {
    final serverTs = DateTime.fromMillisecondsSinceEpoch(serverTsMs);
    final confirmedSortKey = BigInt.from(seq) * BigInt.from(1024);

    await transaction(() async {
      final msg = await (select(messages)..where((t) => t.id.equals(messageId)))
          .getSingleOrNull();

      if (msg != null) {
        await (update(messages)..where((t) => t.id.equals(messageId))).write(
          MessagesCompanion(
            seq: Value(BigInt.from(seq)),
            sortKey: Value(confirmedSortKey),
            state: const Value('sent'),
            serverTs: Value(serverTs),
          ),
        );

        final conv = await (select(conversations)
              ..where((t) => t.id.equals(msg.conversationId)))
            .getSingleOrNull();

        if (conv != null && BigInt.from(seq) > conv.lastSeq) {
          await (update(conversations)
                ..where((t) => t.id.equals(msg.conversationId)))
              .write(
            ConversationsCompanion(
              lastSeq: Value(BigInt.from(seq)),
            ),
          );
        }
      }

      await (delete(outboxEntries)..where((t) => t.messageId.equals(messageId)))
          .go();
    });
  }

  /// Inserts incoming live or synced message idempotently.
  Future<void> insertIncomingMessage(
    MessageNew incoming, {
    String? previewText,
  }) async {
    final confirmedSortKey = BigInt.from(incoming.seq) * BigInt.from(1024);
    final serverTs =
        DateTime.fromMillisecondsSinceEpoch(incoming.serverTsMs);

    await transaction(() async {
      await into(messages).insert(
        MessagesCompanion.insert(
          id: incoming.messageId,
          conversationId: incoming.conversationId,
          seq: Value(BigInt.from(incoming.seq)),
          sortKey: confirmedSortKey,
          senderId: incoming.senderId,
          kind: Value(incoming.kind.value),
          payload: incoming.payload,
          searchText: Value(previewText),
          state: const Value('sent'),
          replyToId: Value(incoming.replyToId),
          createdLocalAt: DateTime.now(),
          serverTs: Value(serverTs),
        ),
        onConflict: DoUpdate((old) => MessagesCompanion(
              seq: Value(BigInt.from(incoming.seq)),
              sortKey: Value(confirmedSortKey),
              state: const Value('sent'),
              serverTs: Value(serverTs),
              editVersion: Value(incoming.editVersion),
            )),
      );

      if (previewText != null && previewText.isNotEmpty) {
        await customStatement(
          'INSERT INTO messages_fts (message_id, conversation_id, content) VALUES (?, ?, ?);',
          [incoming.messageId, incoming.conversationId, previewText],
        );
      }

      await into(conversations).insert(
        ConversationsCompanion.insert(
          id: incoming.conversationId,
          lastSeq: Value(BigInt.from(incoming.seq)),
          lastMessagePreview: Value(previewText),
          lastMessageAt: Value(serverTs),
        ),
        onConflict: DoUpdate((old) => ConversationsCompanion(
              lastSeq: Value(BigInt.from(incoming.seq)),
              lastMessagePreview: Value(previewText),
              lastMessageAt: Value(serverTs),
            )),
      );
    });
  }

  /// Updates peer cursor when ReceiptUpdate arrives.
  Future<void> updatePeerReceipt({
    required String conversationId,
    required int deliveredUptoSeq,
    required int readUptoSeq,
  }) async {
    await (update(conversations)..where((t) => t.id.equals(conversationId)))
        .write(
      ConversationsCompanion(
        peerDeliveredSeq: Value(BigInt.from(deliveredUptoSeq)),
        peerReadSeq: Value(BigInt.from(readUptoSeq)),
      ),
    );
  }

  /// Offline search via FTS5.
  Future<List<Message>> searchMessages(String queryText) async {
    final rows = await customSelect(
      'SELECT message_id FROM messages_fts WHERE content MATCH ? LIMIT 50;',
      variables: [Variable.withString(queryText)],
    ).get();

    final ids = rows.map((r) => r.read<String>('message_id')).toList();
    if (ids.isEmpty) return [];

    return (select(messages)..where((t) => t.id.isIn(ids))).get();
  }
}
