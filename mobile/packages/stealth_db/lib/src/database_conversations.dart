part of 'database.dart';

extension StealthDatabaseConversations on StealthDatabase {
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
}
