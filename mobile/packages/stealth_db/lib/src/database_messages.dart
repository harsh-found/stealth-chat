part of 'database.dart';

extension StealthDatabaseMessages on StealthDatabase {
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
      final baseSortKey = (currentLastSeq + BigInt.one) * BigInt.from(1024);

      final highestMsg = await (select(messages)
            ..where((t) => t.conversationId.equals(conversationId))
            ..orderBy([(t) => OrderingTerm.desc(t.sortKey)])
            ..limit(1))
          .getSingleOrNull();

      final BigInt pendingSortKey;
      if (highestMsg != null && highestMsg.sortKey >= baseSortKey) {
        pendingSortKey = highestMsg.sortKey + BigInt.one;
      } else {
        pendingSortKey = baseSortKey + BigInt.one;
      }

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
    final serverTs = DateTime.fromMillisecondsSinceEpoch(incoming.serverTsMs);

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
