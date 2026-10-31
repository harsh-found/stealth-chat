part of 'database.dart';

extension StealthDatabaseOutbox on StealthDatabase {
  Future<List<OutboxItem>> getPendingOutboxEntries() async {
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

  Future<void> saveOutboxEntry(OutboxItem item) async {
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

  Future<void> removeOutboxEntry(String messageId) async {
    await (delete(outboxEntries)..where((t) => t.messageId.equals(messageId)))
        .go();
  }

  Future<void> markOutboxFailed(String messageId, {int? retryAfterMs}) async {
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
}
