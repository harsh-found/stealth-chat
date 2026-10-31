import 'dart:async';
import 'package:drift/drift.dart';
import 'package:stealth_protocol/stealth_protocol.dart';
import 'package:stealth_sync/stealth_sync.dart';

import 'tables.dart';

part 'database.g.dart';
part 'database_outbox.dart';
part 'database_conversations.dart';
part 'database_messages.dart';

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
  Future<List<OutboxItem>> getPendingItems() => getPendingOutboxEntries();

  @override
  Future<void> saveItem(OutboxItem item) => saveOutboxEntry(item);

  @override
  Future<void> removeItem(String messageId) => removeOutboxEntry(messageId);

  @override
  Future<void> markFailed(String messageId, {int? retryAfterMs}) =>
      markOutboxFailed(messageId, retryAfterMs: retryAfterMs);
}
