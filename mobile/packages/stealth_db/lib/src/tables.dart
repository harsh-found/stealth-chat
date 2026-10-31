import 'package:drift/drift.dart';

class Conversations extends Table {
  TextColumn get id => text()();
  TextColumn get kind => text().withDefault(const Constant('direct'))();
  TextColumn get title => text().nullable()();
  TextColumn get avatarRef => text().nullable()();
  Int64Column get lastSeq => int64().clientDefault(() => BigInt.zero)();
  TextColumn get lastMessagePreview => text().nullable()();
  DateTimeColumn get lastMessageAt => dateTime().nullable()();
  IntColumn get unreadCount => integer().withDefault(const Constant(0))();
  IntColumn get mentionCount => integer().withDefault(const Constant(0))();
  Int64Column get peerDeliveredSeq =>
      int64().clientDefault(() => BigInt.zero)();
  Int64Column get peerReadSeq => int64().clientDefault(() => BigInt.zero)();
  DateTimeColumn get mutedUntil => dateTime().nullable()();
  DateTimeColumn get pinnedAt => dateTime().nullable()();
  DateTimeColumn get archivedAt => dateTime().nullable()();
  TextColumn get draftText => text().nullable()();
  Int64Column get syncVersion => int64().clientDefault(() => BigInt.zero)();

  @override
  Set<Column> get primaryKey => {id};
}

class ConversationMembers extends Table {
  TextColumn get conversationId => text()();
  TextColumn get userId => text()();
  TextColumn get role => text().withDefault(const Constant('member'))();
  Int64Column get deliveredSeq => int64().clientDefault(() => BigInt.zero)();
  Int64Column get readSeq => int64().clientDefault(() => BigInt.zero)();

  @override
  Set<Column> get primaryKey => {conversationId, userId};
}

class Messages extends Table {
  TextColumn get id => text()(); // UUIDv7
  TextColumn get conversationId => text()();
  Int64Column get seq => int64().nullable()();
  Int64Column get sortKey => int64()();
  TextColumn get senderId => text()();
  IntColumn get kind => integer().withDefault(const Constant(1))();
  BlobColumn get payload => blob()();
  TextColumn get searchText => text().nullable()();
  TextColumn get state => text().withDefault(
      const Constant('pending'))(); // pending, sending, sent, failed
  TextColumn get replyToId => text().nullable()();
  IntColumn get editVersion => integer().withDefault(const Constant(0))();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdLocalAt => dateTime()();
  DateTimeColumn get serverTs => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class OutboxEntries extends Table {
  TextColumn get id => text()();
  TextColumn get messageId => text()();
  TextColumn get conversationId => text()();
  IntColumn get kind => integer().withDefault(const Constant(1))();
  BlobColumn get payload => blob()();
  TextColumn get replyToId => text().nullable()();
  Int64Column get clientTsMs => int64()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  DateTimeColumn get nextTryAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class MediaFiles extends Table {
  TextColumn get mediaId => text()();
  TextColumn get localPath => text().nullable()();
  TextColumn get state => text()();
  IntColumn get bytesDone => integer().withDefault(const Constant(0))();
  TextColumn get fileKey => text().nullable()();

  @override
  Set<Column> get primaryKey => {mediaId};
}

class Reactions extends Table {
  TextColumn get messageId => text()();
  TextColumn get userId => text()();
  TextColumn get emoji => text()();

  @override
  Set<Column> get primaryKey => {messageId, userId};
}

class UsersCache extends Table {
  TextColumn get id => text()();
  TextColumn get username => text()();
  TextColumn get displayName => text()();
  TextColumn get avatarRef => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class SyncStates extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
