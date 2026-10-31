// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ConversationsTable extends Conversations
    with TableInfo<$ConversationsTable, Conversation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConversationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
      'kind', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('direct'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _avatarRefMeta =
      const VerificationMeta('avatarRef');
  @override
  late final GeneratedColumn<String> avatarRef = GeneratedColumn<String>(
      'avatar_ref', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastSeqMeta =
      const VerificationMeta('lastSeq');
  @override
  late final GeneratedColumn<BigInt> lastSeq = GeneratedColumn<BigInt>(
      'last_seq', aliasedName, false,
      type: DriftSqlType.bigInt,
      requiredDuringInsert: false,
      clientDefault: () => BigInt.zero);
  static const VerificationMeta _lastMessagePreviewMeta =
      const VerificationMeta('lastMessagePreview');
  @override
  late final GeneratedColumn<String> lastMessagePreview =
      GeneratedColumn<String>('last_message_preview', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastMessageAtMeta =
      const VerificationMeta('lastMessageAt');
  @override
  late final GeneratedColumn<DateTime> lastMessageAt =
      GeneratedColumn<DateTime>('last_message_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _unreadCountMeta =
      const VerificationMeta('unreadCount');
  @override
  late final GeneratedColumn<int> unreadCount = GeneratedColumn<int>(
      'unread_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _mentionCountMeta =
      const VerificationMeta('mentionCount');
  @override
  late final GeneratedColumn<int> mentionCount = GeneratedColumn<int>(
      'mention_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _peerDeliveredSeqMeta =
      const VerificationMeta('peerDeliveredSeq');
  @override
  late final GeneratedColumn<BigInt> peerDeliveredSeq = GeneratedColumn<BigInt>(
      'peer_delivered_seq', aliasedName, false,
      type: DriftSqlType.bigInt,
      requiredDuringInsert: false,
      clientDefault: () => BigInt.zero);
  static const VerificationMeta _peerReadSeqMeta =
      const VerificationMeta('peerReadSeq');
  @override
  late final GeneratedColumn<BigInt> peerReadSeq = GeneratedColumn<BigInt>(
      'peer_read_seq', aliasedName, false,
      type: DriftSqlType.bigInt,
      requiredDuringInsert: false,
      clientDefault: () => BigInt.zero);
  static const VerificationMeta _mutedUntilMeta =
      const VerificationMeta('mutedUntil');
  @override
  late final GeneratedColumn<DateTime> mutedUntil = GeneratedColumn<DateTime>(
      'muted_until', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _pinnedAtMeta =
      const VerificationMeta('pinnedAt');
  @override
  late final GeneratedColumn<DateTime> pinnedAt = GeneratedColumn<DateTime>(
      'pinned_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _archivedAtMeta =
      const VerificationMeta('archivedAt');
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
      'archived_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _draftTextMeta =
      const VerificationMeta('draftText');
  @override
  late final GeneratedColumn<String> draftText = GeneratedColumn<String>(
      'draft_text', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _syncVersionMeta =
      const VerificationMeta('syncVersion');
  @override
  late final GeneratedColumn<BigInt> syncVersion = GeneratedColumn<BigInt>(
      'sync_version', aliasedName, false,
      type: DriftSqlType.bigInt,
      requiredDuringInsert: false,
      clientDefault: () => BigInt.zero);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        kind,
        title,
        avatarRef,
        lastSeq,
        lastMessagePreview,
        lastMessageAt,
        unreadCount,
        mentionCount,
        peerDeliveredSeq,
        peerReadSeq,
        mutedUntil,
        pinnedAt,
        archivedAt,
        draftText,
        syncVersion
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'conversations';
  @override
  VerificationContext validateIntegrity(Insertable<Conversation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
          _kindMeta, kind.isAcceptableOrUnknown(data['kind']!, _kindMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('avatar_ref')) {
      context.handle(_avatarRefMeta,
          avatarRef.isAcceptableOrUnknown(data['avatar_ref']!, _avatarRefMeta));
    }
    if (data.containsKey('last_seq')) {
      context.handle(_lastSeqMeta,
          lastSeq.isAcceptableOrUnknown(data['last_seq']!, _lastSeqMeta));
    }
    if (data.containsKey('last_message_preview')) {
      context.handle(
          _lastMessagePreviewMeta,
          lastMessagePreview.isAcceptableOrUnknown(
              data['last_message_preview']!, _lastMessagePreviewMeta));
    }
    if (data.containsKey('last_message_at')) {
      context.handle(
          _lastMessageAtMeta,
          lastMessageAt.isAcceptableOrUnknown(
              data['last_message_at']!, _lastMessageAtMeta));
    }
    if (data.containsKey('unread_count')) {
      context.handle(
          _unreadCountMeta,
          unreadCount.isAcceptableOrUnknown(
              data['unread_count']!, _unreadCountMeta));
    }
    if (data.containsKey('mention_count')) {
      context.handle(
          _mentionCountMeta,
          mentionCount.isAcceptableOrUnknown(
              data['mention_count']!, _mentionCountMeta));
    }
    if (data.containsKey('peer_delivered_seq')) {
      context.handle(
          _peerDeliveredSeqMeta,
          peerDeliveredSeq.isAcceptableOrUnknown(
              data['peer_delivered_seq']!, _peerDeliveredSeqMeta));
    }
    if (data.containsKey('peer_read_seq')) {
      context.handle(
          _peerReadSeqMeta,
          peerReadSeq.isAcceptableOrUnknown(
              data['peer_read_seq']!, _peerReadSeqMeta));
    }
    if (data.containsKey('muted_until')) {
      context.handle(
          _mutedUntilMeta,
          mutedUntil.isAcceptableOrUnknown(
              data['muted_until']!, _mutedUntilMeta));
    }
    if (data.containsKey('pinned_at')) {
      context.handle(_pinnedAtMeta,
          pinnedAt.isAcceptableOrUnknown(data['pinned_at']!, _pinnedAtMeta));
    }
    if (data.containsKey('archived_at')) {
      context.handle(
          _archivedAtMeta,
          archivedAt.isAcceptableOrUnknown(
              data['archived_at']!, _archivedAtMeta));
    }
    if (data.containsKey('draft_text')) {
      context.handle(_draftTextMeta,
          draftText.isAcceptableOrUnknown(data['draft_text']!, _draftTextMeta));
    }
    if (data.containsKey('sync_version')) {
      context.handle(
          _syncVersionMeta,
          syncVersion.isAcceptableOrUnknown(
              data['sync_version']!, _syncVersionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Conversation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Conversation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      kind: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kind'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title']),
      avatarRef: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar_ref']),
      lastSeq: attachedDatabase.typeMapping
          .read(DriftSqlType.bigInt, data['${effectivePrefix}last_seq'])!,
      lastMessagePreview: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}last_message_preview']),
      lastMessageAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_message_at']),
      unreadCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}unread_count'])!,
      mentionCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}mention_count'])!,
      peerDeliveredSeq: attachedDatabase.typeMapping.read(
          DriftSqlType.bigInt, data['${effectivePrefix}peer_delivered_seq'])!,
      peerReadSeq: attachedDatabase.typeMapping
          .read(DriftSqlType.bigInt, data['${effectivePrefix}peer_read_seq'])!,
      mutedUntil: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}muted_until']),
      pinnedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}pinned_at']),
      archivedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}archived_at']),
      draftText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}draft_text']),
      syncVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.bigInt, data['${effectivePrefix}sync_version'])!,
    );
  }

  @override
  $ConversationsTable createAlias(String alias) {
    return $ConversationsTable(attachedDatabase, alias);
  }
}

class Conversation extends DataClass implements Insertable<Conversation> {
  final String id;
  final String kind;
  final String? title;
  final String? avatarRef;
  final BigInt lastSeq;
  final String? lastMessagePreview;
  final DateTime? lastMessageAt;
  final int unreadCount;
  final int mentionCount;
  final BigInt peerDeliveredSeq;
  final BigInt peerReadSeq;
  final DateTime? mutedUntil;
  final DateTime? pinnedAt;
  final DateTime? archivedAt;
  final String? draftText;
  final BigInt syncVersion;
  const Conversation(
      {required this.id,
      required this.kind,
      this.title,
      this.avatarRef,
      required this.lastSeq,
      this.lastMessagePreview,
      this.lastMessageAt,
      required this.unreadCount,
      required this.mentionCount,
      required this.peerDeliveredSeq,
      required this.peerReadSeq,
      this.mutedUntil,
      this.pinnedAt,
      this.archivedAt,
      this.draftText,
      required this.syncVersion});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['kind'] = Variable<String>(kind);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || avatarRef != null) {
      map['avatar_ref'] = Variable<String>(avatarRef);
    }
    map['last_seq'] = Variable<BigInt>(lastSeq);
    if (!nullToAbsent || lastMessagePreview != null) {
      map['last_message_preview'] = Variable<String>(lastMessagePreview);
    }
    if (!nullToAbsent || lastMessageAt != null) {
      map['last_message_at'] = Variable<DateTime>(lastMessageAt);
    }
    map['unread_count'] = Variable<int>(unreadCount);
    map['mention_count'] = Variable<int>(mentionCount);
    map['peer_delivered_seq'] = Variable<BigInt>(peerDeliveredSeq);
    map['peer_read_seq'] = Variable<BigInt>(peerReadSeq);
    if (!nullToAbsent || mutedUntil != null) {
      map['muted_until'] = Variable<DateTime>(mutedUntil);
    }
    if (!nullToAbsent || pinnedAt != null) {
      map['pinned_at'] = Variable<DateTime>(pinnedAt);
    }
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    if (!nullToAbsent || draftText != null) {
      map['draft_text'] = Variable<String>(draftText);
    }
    map['sync_version'] = Variable<BigInt>(syncVersion);
    return map;
  }

  ConversationsCompanion toCompanion(bool nullToAbsent) {
    return ConversationsCompanion(
      id: Value(id),
      kind: Value(kind),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      avatarRef: avatarRef == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarRef),
      lastSeq: Value(lastSeq),
      lastMessagePreview: lastMessagePreview == null && nullToAbsent
          ? const Value.absent()
          : Value(lastMessagePreview),
      lastMessageAt: lastMessageAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastMessageAt),
      unreadCount: Value(unreadCount),
      mentionCount: Value(mentionCount),
      peerDeliveredSeq: Value(peerDeliveredSeq),
      peerReadSeq: Value(peerReadSeq),
      mutedUntil: mutedUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(mutedUntil),
      pinnedAt: pinnedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(pinnedAt),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      draftText: draftText == null && nullToAbsent
          ? const Value.absent()
          : Value(draftText),
      syncVersion: Value(syncVersion),
    );
  }

  factory Conversation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Conversation(
      id: serializer.fromJson<String>(json['id']),
      kind: serializer.fromJson<String>(json['kind']),
      title: serializer.fromJson<String?>(json['title']),
      avatarRef: serializer.fromJson<String?>(json['avatarRef']),
      lastSeq: serializer.fromJson<BigInt>(json['lastSeq']),
      lastMessagePreview:
          serializer.fromJson<String?>(json['lastMessagePreview']),
      lastMessageAt: serializer.fromJson<DateTime?>(json['lastMessageAt']),
      unreadCount: serializer.fromJson<int>(json['unreadCount']),
      mentionCount: serializer.fromJson<int>(json['mentionCount']),
      peerDeliveredSeq: serializer.fromJson<BigInt>(json['peerDeliveredSeq']),
      peerReadSeq: serializer.fromJson<BigInt>(json['peerReadSeq']),
      mutedUntil: serializer.fromJson<DateTime?>(json['mutedUntil']),
      pinnedAt: serializer.fromJson<DateTime?>(json['pinnedAt']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
      draftText: serializer.fromJson<String?>(json['draftText']),
      syncVersion: serializer.fromJson<BigInt>(json['syncVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'kind': serializer.toJson<String>(kind),
      'title': serializer.toJson<String?>(title),
      'avatarRef': serializer.toJson<String?>(avatarRef),
      'lastSeq': serializer.toJson<BigInt>(lastSeq),
      'lastMessagePreview': serializer.toJson<String?>(lastMessagePreview),
      'lastMessageAt': serializer.toJson<DateTime?>(lastMessageAt),
      'unreadCount': serializer.toJson<int>(unreadCount),
      'mentionCount': serializer.toJson<int>(mentionCount),
      'peerDeliveredSeq': serializer.toJson<BigInt>(peerDeliveredSeq),
      'peerReadSeq': serializer.toJson<BigInt>(peerReadSeq),
      'mutedUntil': serializer.toJson<DateTime?>(mutedUntil),
      'pinnedAt': serializer.toJson<DateTime?>(pinnedAt),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
      'draftText': serializer.toJson<String?>(draftText),
      'syncVersion': serializer.toJson<BigInt>(syncVersion),
    };
  }

  Conversation copyWith(
          {String? id,
          String? kind,
          Value<String?> title = const Value.absent(),
          Value<String?> avatarRef = const Value.absent(),
          BigInt? lastSeq,
          Value<String?> lastMessagePreview = const Value.absent(),
          Value<DateTime?> lastMessageAt = const Value.absent(),
          int? unreadCount,
          int? mentionCount,
          BigInt? peerDeliveredSeq,
          BigInt? peerReadSeq,
          Value<DateTime?> mutedUntil = const Value.absent(),
          Value<DateTime?> pinnedAt = const Value.absent(),
          Value<DateTime?> archivedAt = const Value.absent(),
          Value<String?> draftText = const Value.absent(),
          BigInt? syncVersion}) =>
      Conversation(
        id: id ?? this.id,
        kind: kind ?? this.kind,
        title: title.present ? title.value : this.title,
        avatarRef: avatarRef.present ? avatarRef.value : this.avatarRef,
        lastSeq: lastSeq ?? this.lastSeq,
        lastMessagePreview: lastMessagePreview.present
            ? lastMessagePreview.value
            : this.lastMessagePreview,
        lastMessageAt:
            lastMessageAt.present ? lastMessageAt.value : this.lastMessageAt,
        unreadCount: unreadCount ?? this.unreadCount,
        mentionCount: mentionCount ?? this.mentionCount,
        peerDeliveredSeq: peerDeliveredSeq ?? this.peerDeliveredSeq,
        peerReadSeq: peerReadSeq ?? this.peerReadSeq,
        mutedUntil: mutedUntil.present ? mutedUntil.value : this.mutedUntil,
        pinnedAt: pinnedAt.present ? pinnedAt.value : this.pinnedAt,
        archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
        draftText: draftText.present ? draftText.value : this.draftText,
        syncVersion: syncVersion ?? this.syncVersion,
      );
  Conversation copyWithCompanion(ConversationsCompanion data) {
    return Conversation(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      title: data.title.present ? data.title.value : this.title,
      avatarRef: data.avatarRef.present ? data.avatarRef.value : this.avatarRef,
      lastSeq: data.lastSeq.present ? data.lastSeq.value : this.lastSeq,
      lastMessagePreview: data.lastMessagePreview.present
          ? data.lastMessagePreview.value
          : this.lastMessagePreview,
      lastMessageAt: data.lastMessageAt.present
          ? data.lastMessageAt.value
          : this.lastMessageAt,
      unreadCount:
          data.unreadCount.present ? data.unreadCount.value : this.unreadCount,
      mentionCount: data.mentionCount.present
          ? data.mentionCount.value
          : this.mentionCount,
      peerDeliveredSeq: data.peerDeliveredSeq.present
          ? data.peerDeliveredSeq.value
          : this.peerDeliveredSeq,
      peerReadSeq:
          data.peerReadSeq.present ? data.peerReadSeq.value : this.peerReadSeq,
      mutedUntil:
          data.mutedUntil.present ? data.mutedUntil.value : this.mutedUntil,
      pinnedAt: data.pinnedAt.present ? data.pinnedAt.value : this.pinnedAt,
      archivedAt:
          data.archivedAt.present ? data.archivedAt.value : this.archivedAt,
      draftText: data.draftText.present ? data.draftText.value : this.draftText,
      syncVersion:
          data.syncVersion.present ? data.syncVersion.value : this.syncVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Conversation(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('title: $title, ')
          ..write('avatarRef: $avatarRef, ')
          ..write('lastSeq: $lastSeq, ')
          ..write('lastMessagePreview: $lastMessagePreview, ')
          ..write('lastMessageAt: $lastMessageAt, ')
          ..write('unreadCount: $unreadCount, ')
          ..write('mentionCount: $mentionCount, ')
          ..write('peerDeliveredSeq: $peerDeliveredSeq, ')
          ..write('peerReadSeq: $peerReadSeq, ')
          ..write('mutedUntil: $mutedUntil, ')
          ..write('pinnedAt: $pinnedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('draftText: $draftText, ')
          ..write('syncVersion: $syncVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      kind,
      title,
      avatarRef,
      lastSeq,
      lastMessagePreview,
      lastMessageAt,
      unreadCount,
      mentionCount,
      peerDeliveredSeq,
      peerReadSeq,
      mutedUntil,
      pinnedAt,
      archivedAt,
      draftText,
      syncVersion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Conversation &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.title == this.title &&
          other.avatarRef == this.avatarRef &&
          other.lastSeq == this.lastSeq &&
          other.lastMessagePreview == this.lastMessagePreview &&
          other.lastMessageAt == this.lastMessageAt &&
          other.unreadCount == this.unreadCount &&
          other.mentionCount == this.mentionCount &&
          other.peerDeliveredSeq == this.peerDeliveredSeq &&
          other.peerReadSeq == this.peerReadSeq &&
          other.mutedUntil == this.mutedUntil &&
          other.pinnedAt == this.pinnedAt &&
          other.archivedAt == this.archivedAt &&
          other.draftText == this.draftText &&
          other.syncVersion == this.syncVersion);
}

class ConversationsCompanion extends UpdateCompanion<Conversation> {
  final Value<String> id;
  final Value<String> kind;
  final Value<String?> title;
  final Value<String?> avatarRef;
  final Value<BigInt> lastSeq;
  final Value<String?> lastMessagePreview;
  final Value<DateTime?> lastMessageAt;
  final Value<int> unreadCount;
  final Value<int> mentionCount;
  final Value<BigInt> peerDeliveredSeq;
  final Value<BigInt> peerReadSeq;
  final Value<DateTime?> mutedUntil;
  final Value<DateTime?> pinnedAt;
  final Value<DateTime?> archivedAt;
  final Value<String?> draftText;
  final Value<BigInt> syncVersion;
  final Value<int> rowid;
  const ConversationsCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.title = const Value.absent(),
    this.avatarRef = const Value.absent(),
    this.lastSeq = const Value.absent(),
    this.lastMessagePreview = const Value.absent(),
    this.lastMessageAt = const Value.absent(),
    this.unreadCount = const Value.absent(),
    this.mentionCount = const Value.absent(),
    this.peerDeliveredSeq = const Value.absent(),
    this.peerReadSeq = const Value.absent(),
    this.mutedUntil = const Value.absent(),
    this.pinnedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.draftText = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConversationsCompanion.insert({
    required String id,
    this.kind = const Value.absent(),
    this.title = const Value.absent(),
    this.avatarRef = const Value.absent(),
    this.lastSeq = const Value.absent(),
    this.lastMessagePreview = const Value.absent(),
    this.lastMessageAt = const Value.absent(),
    this.unreadCount = const Value.absent(),
    this.mentionCount = const Value.absent(),
    this.peerDeliveredSeq = const Value.absent(),
    this.peerReadSeq = const Value.absent(),
    this.mutedUntil = const Value.absent(),
    this.pinnedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.draftText = const Value.absent(),
    this.syncVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<Conversation> custom({
    Expression<String>? id,
    Expression<String>? kind,
    Expression<String>? title,
    Expression<String>? avatarRef,
    Expression<BigInt>? lastSeq,
    Expression<String>? lastMessagePreview,
    Expression<DateTime>? lastMessageAt,
    Expression<int>? unreadCount,
    Expression<int>? mentionCount,
    Expression<BigInt>? peerDeliveredSeq,
    Expression<BigInt>? peerReadSeq,
    Expression<DateTime>? mutedUntil,
    Expression<DateTime>? pinnedAt,
    Expression<DateTime>? archivedAt,
    Expression<String>? draftText,
    Expression<BigInt>? syncVersion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (title != null) 'title': title,
      if (avatarRef != null) 'avatar_ref': avatarRef,
      if (lastSeq != null) 'last_seq': lastSeq,
      if (lastMessagePreview != null)
        'last_message_preview': lastMessagePreview,
      if (lastMessageAt != null) 'last_message_at': lastMessageAt,
      if (unreadCount != null) 'unread_count': unreadCount,
      if (mentionCount != null) 'mention_count': mentionCount,
      if (peerDeliveredSeq != null) 'peer_delivered_seq': peerDeliveredSeq,
      if (peerReadSeq != null) 'peer_read_seq': peerReadSeq,
      if (mutedUntil != null) 'muted_until': mutedUntil,
      if (pinnedAt != null) 'pinned_at': pinnedAt,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (draftText != null) 'draft_text': draftText,
      if (syncVersion != null) 'sync_version': syncVersion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConversationsCompanion copyWith(
      {Value<String>? id,
      Value<String>? kind,
      Value<String?>? title,
      Value<String?>? avatarRef,
      Value<BigInt>? lastSeq,
      Value<String?>? lastMessagePreview,
      Value<DateTime?>? lastMessageAt,
      Value<int>? unreadCount,
      Value<int>? mentionCount,
      Value<BigInt>? peerDeliveredSeq,
      Value<BigInt>? peerReadSeq,
      Value<DateTime?>? mutedUntil,
      Value<DateTime?>? pinnedAt,
      Value<DateTime?>? archivedAt,
      Value<String?>? draftText,
      Value<BigInt>? syncVersion,
      Value<int>? rowid}) {
    return ConversationsCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      title: title ?? this.title,
      avatarRef: avatarRef ?? this.avatarRef,
      lastSeq: lastSeq ?? this.lastSeq,
      lastMessagePreview: lastMessagePreview ?? this.lastMessagePreview,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      unreadCount: unreadCount ?? this.unreadCount,
      mentionCount: mentionCount ?? this.mentionCount,
      peerDeliveredSeq: peerDeliveredSeq ?? this.peerDeliveredSeq,
      peerReadSeq: peerReadSeq ?? this.peerReadSeq,
      mutedUntil: mutedUntil ?? this.mutedUntil,
      pinnedAt: pinnedAt ?? this.pinnedAt,
      archivedAt: archivedAt ?? this.archivedAt,
      draftText: draftText ?? this.draftText,
      syncVersion: syncVersion ?? this.syncVersion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (avatarRef.present) {
      map['avatar_ref'] = Variable<String>(avatarRef.value);
    }
    if (lastSeq.present) {
      map['last_seq'] = Variable<BigInt>(lastSeq.value);
    }
    if (lastMessagePreview.present) {
      map['last_message_preview'] = Variable<String>(lastMessagePreview.value);
    }
    if (lastMessageAt.present) {
      map['last_message_at'] = Variable<DateTime>(lastMessageAt.value);
    }
    if (unreadCount.present) {
      map['unread_count'] = Variable<int>(unreadCount.value);
    }
    if (mentionCount.present) {
      map['mention_count'] = Variable<int>(mentionCount.value);
    }
    if (peerDeliveredSeq.present) {
      map['peer_delivered_seq'] = Variable<BigInt>(peerDeliveredSeq.value);
    }
    if (peerReadSeq.present) {
      map['peer_read_seq'] = Variable<BigInt>(peerReadSeq.value);
    }
    if (mutedUntil.present) {
      map['muted_until'] = Variable<DateTime>(mutedUntil.value);
    }
    if (pinnedAt.present) {
      map['pinned_at'] = Variable<DateTime>(pinnedAt.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (draftText.present) {
      map['draft_text'] = Variable<String>(draftText.value);
    }
    if (syncVersion.present) {
      map['sync_version'] = Variable<BigInt>(syncVersion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConversationsCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('title: $title, ')
          ..write('avatarRef: $avatarRef, ')
          ..write('lastSeq: $lastSeq, ')
          ..write('lastMessagePreview: $lastMessagePreview, ')
          ..write('lastMessageAt: $lastMessageAt, ')
          ..write('unreadCount: $unreadCount, ')
          ..write('mentionCount: $mentionCount, ')
          ..write('peerDeliveredSeq: $peerDeliveredSeq, ')
          ..write('peerReadSeq: $peerReadSeq, ')
          ..write('mutedUntil: $mutedUntil, ')
          ..write('pinnedAt: $pinnedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('draftText: $draftText, ')
          ..write('syncVersion: $syncVersion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ConversationMembersTable extends ConversationMembers
    with TableInfo<$ConversationMembersTable, ConversationMember> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConversationMembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _conversationIdMeta =
      const VerificationMeta('conversationId');
  @override
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
      'conversation_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('member'));
  static const VerificationMeta _deliveredSeqMeta =
      const VerificationMeta('deliveredSeq');
  @override
  late final GeneratedColumn<BigInt> deliveredSeq = GeneratedColumn<BigInt>(
      'delivered_seq', aliasedName, false,
      type: DriftSqlType.bigInt,
      requiredDuringInsert: false,
      clientDefault: () => BigInt.zero);
  static const VerificationMeta _readSeqMeta =
      const VerificationMeta('readSeq');
  @override
  late final GeneratedColumn<BigInt> readSeq = GeneratedColumn<BigInt>(
      'read_seq', aliasedName, false,
      type: DriftSqlType.bigInt,
      requiredDuringInsert: false,
      clientDefault: () => BigInt.zero);
  @override
  List<GeneratedColumn> get $columns =>
      [conversationId, userId, role, deliveredSeq, readSeq];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'conversation_members';
  @override
  VerificationContext validateIntegrity(Insertable<ConversationMember> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('conversation_id')) {
      context.handle(
          _conversationIdMeta,
          conversationId.isAcceptableOrUnknown(
              data['conversation_id']!, _conversationIdMeta));
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    }
    if (data.containsKey('delivered_seq')) {
      context.handle(
          _deliveredSeqMeta,
          deliveredSeq.isAcceptableOrUnknown(
              data['delivered_seq']!, _deliveredSeqMeta));
    }
    if (data.containsKey('read_seq')) {
      context.handle(_readSeqMeta,
          readSeq.isAcceptableOrUnknown(data['read_seq']!, _readSeqMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {conversationId, userId};
  @override
  ConversationMember map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConversationMember(
      conversationId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}conversation_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      deliveredSeq: attachedDatabase.typeMapping
          .read(DriftSqlType.bigInt, data['${effectivePrefix}delivered_seq'])!,
      readSeq: attachedDatabase.typeMapping
          .read(DriftSqlType.bigInt, data['${effectivePrefix}read_seq'])!,
    );
  }

  @override
  $ConversationMembersTable createAlias(String alias) {
    return $ConversationMembersTable(attachedDatabase, alias);
  }
}

class ConversationMember extends DataClass
    implements Insertable<ConversationMember> {
  final String conversationId;
  final String userId;
  final String role;
  final BigInt deliveredSeq;
  final BigInt readSeq;
  const ConversationMember(
      {required this.conversationId,
      required this.userId,
      required this.role,
      required this.deliveredSeq,
      required this.readSeq});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['conversation_id'] = Variable<String>(conversationId);
    map['user_id'] = Variable<String>(userId);
    map['role'] = Variable<String>(role);
    map['delivered_seq'] = Variable<BigInt>(deliveredSeq);
    map['read_seq'] = Variable<BigInt>(readSeq);
    return map;
  }

  ConversationMembersCompanion toCompanion(bool nullToAbsent) {
    return ConversationMembersCompanion(
      conversationId: Value(conversationId),
      userId: Value(userId),
      role: Value(role),
      deliveredSeq: Value(deliveredSeq),
      readSeq: Value(readSeq),
    );
  }

  factory ConversationMember.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConversationMember(
      conversationId: serializer.fromJson<String>(json['conversationId']),
      userId: serializer.fromJson<String>(json['userId']),
      role: serializer.fromJson<String>(json['role']),
      deliveredSeq: serializer.fromJson<BigInt>(json['deliveredSeq']),
      readSeq: serializer.fromJson<BigInt>(json['readSeq']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'conversationId': serializer.toJson<String>(conversationId),
      'userId': serializer.toJson<String>(userId),
      'role': serializer.toJson<String>(role),
      'deliveredSeq': serializer.toJson<BigInt>(deliveredSeq),
      'readSeq': serializer.toJson<BigInt>(readSeq),
    };
  }

  ConversationMember copyWith(
          {String? conversationId,
          String? userId,
          String? role,
          BigInt? deliveredSeq,
          BigInt? readSeq}) =>
      ConversationMember(
        conversationId: conversationId ?? this.conversationId,
        userId: userId ?? this.userId,
        role: role ?? this.role,
        deliveredSeq: deliveredSeq ?? this.deliveredSeq,
        readSeq: readSeq ?? this.readSeq,
      );
  ConversationMember copyWithCompanion(ConversationMembersCompanion data) {
    return ConversationMember(
      conversationId: data.conversationId.present
          ? data.conversationId.value
          : this.conversationId,
      userId: data.userId.present ? data.userId.value : this.userId,
      role: data.role.present ? data.role.value : this.role,
      deliveredSeq: data.deliveredSeq.present
          ? data.deliveredSeq.value
          : this.deliveredSeq,
      readSeq: data.readSeq.present ? data.readSeq.value : this.readSeq,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConversationMember(')
          ..write('conversationId: $conversationId, ')
          ..write('userId: $userId, ')
          ..write('role: $role, ')
          ..write('deliveredSeq: $deliveredSeq, ')
          ..write('readSeq: $readSeq')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(conversationId, userId, role, deliveredSeq, readSeq);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConversationMember &&
          other.conversationId == this.conversationId &&
          other.userId == this.userId &&
          other.role == this.role &&
          other.deliveredSeq == this.deliveredSeq &&
          other.readSeq == this.readSeq);
}

class ConversationMembersCompanion extends UpdateCompanion<ConversationMember> {
  final Value<String> conversationId;
  final Value<String> userId;
  final Value<String> role;
  final Value<BigInt> deliveredSeq;
  final Value<BigInt> readSeq;
  final Value<int> rowid;
  const ConversationMembersCompanion({
    this.conversationId = const Value.absent(),
    this.userId = const Value.absent(),
    this.role = const Value.absent(),
    this.deliveredSeq = const Value.absent(),
    this.readSeq = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConversationMembersCompanion.insert({
    required String conversationId,
    required String userId,
    this.role = const Value.absent(),
    this.deliveredSeq = const Value.absent(),
    this.readSeq = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : conversationId = Value(conversationId),
        userId = Value(userId);
  static Insertable<ConversationMember> custom({
    Expression<String>? conversationId,
    Expression<String>? userId,
    Expression<String>? role,
    Expression<BigInt>? deliveredSeq,
    Expression<BigInt>? readSeq,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (conversationId != null) 'conversation_id': conversationId,
      if (userId != null) 'user_id': userId,
      if (role != null) 'role': role,
      if (deliveredSeq != null) 'delivered_seq': deliveredSeq,
      if (readSeq != null) 'read_seq': readSeq,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConversationMembersCompanion copyWith(
      {Value<String>? conversationId,
      Value<String>? userId,
      Value<String>? role,
      Value<BigInt>? deliveredSeq,
      Value<BigInt>? readSeq,
      Value<int>? rowid}) {
    return ConversationMembersCompanion(
      conversationId: conversationId ?? this.conversationId,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      deliveredSeq: deliveredSeq ?? this.deliveredSeq,
      readSeq: readSeq ?? this.readSeq,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (deliveredSeq.present) {
      map['delivered_seq'] = Variable<BigInt>(deliveredSeq.value);
    }
    if (readSeq.present) {
      map['read_seq'] = Variable<BigInt>(readSeq.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConversationMembersCompanion(')
          ..write('conversationId: $conversationId, ')
          ..write('userId: $userId, ')
          ..write('role: $role, ')
          ..write('deliveredSeq: $deliveredSeq, ')
          ..write('readSeq: $readSeq, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MessagesTable extends Messages with TableInfo<$MessagesTable, Message> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _conversationIdMeta =
      const VerificationMeta('conversationId');
  @override
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
      'conversation_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _seqMeta = const VerificationMeta('seq');
  @override
  late final GeneratedColumn<BigInt> seq = GeneratedColumn<BigInt>(
      'seq', aliasedName, true,
      type: DriftSqlType.bigInt, requiredDuringInsert: false);
  static const VerificationMeta _sortKeyMeta =
      const VerificationMeta('sortKey');
  @override
  late final GeneratedColumn<BigInt> sortKey = GeneratedColumn<BigInt>(
      'sort_key', aliasedName, false,
      type: DriftSqlType.bigInt, requiredDuringInsert: true);
  static const VerificationMeta _senderIdMeta =
      const VerificationMeta('senderId');
  @override
  late final GeneratedColumn<String> senderId = GeneratedColumn<String>(
      'sender_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<int> kind = GeneratedColumn<int>(
      'kind', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _payloadMeta =
      const VerificationMeta('payload');
  @override
  late final GeneratedColumn<Uint8List> payload = GeneratedColumn<Uint8List>(
      'payload', aliasedName, false,
      type: DriftSqlType.blob, requiredDuringInsert: true);
  static const VerificationMeta _searchTextMeta =
      const VerificationMeta('searchText');
  @override
  late final GeneratedColumn<String> searchText = GeneratedColumn<String>(
      'search_text', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
      'state', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _replyToIdMeta =
      const VerificationMeta('replyToId');
  @override
  late final GeneratedColumn<String> replyToId = GeneratedColumn<String>(
      'reply_to_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _editVersionMeta =
      const VerificationMeta('editVersion');
  @override
  late final GeneratedColumn<int> editVersion = GeneratedColumn<int>(
      'edit_version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _deletedMeta =
      const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
      'deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdLocalAtMeta =
      const VerificationMeta('createdLocalAt');
  @override
  late final GeneratedColumn<DateTime> createdLocalAt =
      GeneratedColumn<DateTime>('created_local_at', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _serverTsMeta =
      const VerificationMeta('serverTs');
  @override
  late final GeneratedColumn<DateTime> serverTs = GeneratedColumn<DateTime>(
      'server_ts', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        conversationId,
        seq,
        sortKey,
        senderId,
        kind,
        payload,
        searchText,
        state,
        replyToId,
        editVersion,
        deleted,
        createdLocalAt,
        serverTs
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'messages';
  @override
  VerificationContext validateIntegrity(Insertable<Message> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('conversation_id')) {
      context.handle(
          _conversationIdMeta,
          conversationId.isAcceptableOrUnknown(
              data['conversation_id']!, _conversationIdMeta));
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('seq')) {
      context.handle(
          _seqMeta, seq.isAcceptableOrUnknown(data['seq']!, _seqMeta));
    }
    if (data.containsKey('sort_key')) {
      context.handle(_sortKeyMeta,
          sortKey.isAcceptableOrUnknown(data['sort_key']!, _sortKeyMeta));
    } else if (isInserting) {
      context.missing(_sortKeyMeta);
    }
    if (data.containsKey('sender_id')) {
      context.handle(_senderIdMeta,
          senderId.isAcceptableOrUnknown(data['sender_id']!, _senderIdMeta));
    } else if (isInserting) {
      context.missing(_senderIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
          _kindMeta, kind.isAcceptableOrUnknown(data['kind']!, _kindMeta));
    }
    if (data.containsKey('payload')) {
      context.handle(_payloadMeta,
          payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta));
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('search_text')) {
      context.handle(
          _searchTextMeta,
          searchText.isAcceptableOrUnknown(
              data['search_text']!, _searchTextMeta));
    }
    if (data.containsKey('state')) {
      context.handle(
          _stateMeta, state.isAcceptableOrUnknown(data['state']!, _stateMeta));
    }
    if (data.containsKey('reply_to_id')) {
      context.handle(
          _replyToIdMeta,
          replyToId.isAcceptableOrUnknown(
              data['reply_to_id']!, _replyToIdMeta));
    }
    if (data.containsKey('edit_version')) {
      context.handle(
          _editVersionMeta,
          editVersion.isAcceptableOrUnknown(
              data['edit_version']!, _editVersionMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    if (data.containsKey('created_local_at')) {
      context.handle(
          _createdLocalAtMeta,
          createdLocalAt.isAcceptableOrUnknown(
              data['created_local_at']!, _createdLocalAtMeta));
    } else if (isInserting) {
      context.missing(_createdLocalAtMeta);
    }
    if (data.containsKey('server_ts')) {
      context.handle(_serverTsMeta,
          serverTs.isAcceptableOrUnknown(data['server_ts']!, _serverTsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Message map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Message(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      conversationId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}conversation_id'])!,
      seq: attachedDatabase.typeMapping
          .read(DriftSqlType.bigInt, data['${effectivePrefix}seq']),
      sortKey: attachedDatabase.typeMapping
          .read(DriftSqlType.bigInt, data['${effectivePrefix}sort_key'])!,
      senderId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sender_id'])!,
      kind: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}kind'])!,
      payload: attachedDatabase.typeMapping
          .read(DriftSqlType.blob, data['${effectivePrefix}payload'])!,
      searchText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}search_text']),
      state: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}state'])!,
      replyToId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reply_to_id']),
      editVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}edit_version'])!,
      deleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
      createdLocalAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}created_local_at'])!,
      serverTs: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}server_ts']),
    );
  }

  @override
  $MessagesTable createAlias(String alias) {
    return $MessagesTable(attachedDatabase, alias);
  }
}

class Message extends DataClass implements Insertable<Message> {
  final String id;
  final String conversationId;
  final BigInt? seq;
  final BigInt sortKey;
  final String senderId;
  final int kind;
  final Uint8List payload;
  final String? searchText;
  final String state;
  final String? replyToId;
  final int editVersion;
  final bool deleted;
  final DateTime createdLocalAt;
  final DateTime? serverTs;
  const Message(
      {required this.id,
      required this.conversationId,
      this.seq,
      required this.sortKey,
      required this.senderId,
      required this.kind,
      required this.payload,
      this.searchText,
      required this.state,
      this.replyToId,
      required this.editVersion,
      required this.deleted,
      required this.createdLocalAt,
      this.serverTs});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['conversation_id'] = Variable<String>(conversationId);
    if (!nullToAbsent || seq != null) {
      map['seq'] = Variable<BigInt>(seq);
    }
    map['sort_key'] = Variable<BigInt>(sortKey);
    map['sender_id'] = Variable<String>(senderId);
    map['kind'] = Variable<int>(kind);
    map['payload'] = Variable<Uint8List>(payload);
    if (!nullToAbsent || searchText != null) {
      map['search_text'] = Variable<String>(searchText);
    }
    map['state'] = Variable<String>(state);
    if (!nullToAbsent || replyToId != null) {
      map['reply_to_id'] = Variable<String>(replyToId);
    }
    map['edit_version'] = Variable<int>(editVersion);
    map['deleted'] = Variable<bool>(deleted);
    map['created_local_at'] = Variable<DateTime>(createdLocalAt);
    if (!nullToAbsent || serverTs != null) {
      map['server_ts'] = Variable<DateTime>(serverTs);
    }
    return map;
  }

  MessagesCompanion toCompanion(bool nullToAbsent) {
    return MessagesCompanion(
      id: Value(id),
      conversationId: Value(conversationId),
      seq: seq == null && nullToAbsent ? const Value.absent() : Value(seq),
      sortKey: Value(sortKey),
      senderId: Value(senderId),
      kind: Value(kind),
      payload: Value(payload),
      searchText: searchText == null && nullToAbsent
          ? const Value.absent()
          : Value(searchText),
      state: Value(state),
      replyToId: replyToId == null && nullToAbsent
          ? const Value.absent()
          : Value(replyToId),
      editVersion: Value(editVersion),
      deleted: Value(deleted),
      createdLocalAt: Value(createdLocalAt),
      serverTs: serverTs == null && nullToAbsent
          ? const Value.absent()
          : Value(serverTs),
    );
  }

  factory Message.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Message(
      id: serializer.fromJson<String>(json['id']),
      conversationId: serializer.fromJson<String>(json['conversationId']),
      seq: serializer.fromJson<BigInt?>(json['seq']),
      sortKey: serializer.fromJson<BigInt>(json['sortKey']),
      senderId: serializer.fromJson<String>(json['senderId']),
      kind: serializer.fromJson<int>(json['kind']),
      payload: serializer.fromJson<Uint8List>(json['payload']),
      searchText: serializer.fromJson<String?>(json['searchText']),
      state: serializer.fromJson<String>(json['state']),
      replyToId: serializer.fromJson<String?>(json['replyToId']),
      editVersion: serializer.fromJson<int>(json['editVersion']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      createdLocalAt: serializer.fromJson<DateTime>(json['createdLocalAt']),
      serverTs: serializer.fromJson<DateTime?>(json['serverTs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'conversationId': serializer.toJson<String>(conversationId),
      'seq': serializer.toJson<BigInt?>(seq),
      'sortKey': serializer.toJson<BigInt>(sortKey),
      'senderId': serializer.toJson<String>(senderId),
      'kind': serializer.toJson<int>(kind),
      'payload': serializer.toJson<Uint8List>(payload),
      'searchText': serializer.toJson<String?>(searchText),
      'state': serializer.toJson<String>(state),
      'replyToId': serializer.toJson<String?>(replyToId),
      'editVersion': serializer.toJson<int>(editVersion),
      'deleted': serializer.toJson<bool>(deleted),
      'createdLocalAt': serializer.toJson<DateTime>(createdLocalAt),
      'serverTs': serializer.toJson<DateTime?>(serverTs),
    };
  }

  Message copyWith(
          {String? id,
          String? conversationId,
          Value<BigInt?> seq = const Value.absent(),
          BigInt? sortKey,
          String? senderId,
          int? kind,
          Uint8List? payload,
          Value<String?> searchText = const Value.absent(),
          String? state,
          Value<String?> replyToId = const Value.absent(),
          int? editVersion,
          bool? deleted,
          DateTime? createdLocalAt,
          Value<DateTime?> serverTs = const Value.absent()}) =>
      Message(
        id: id ?? this.id,
        conversationId: conversationId ?? this.conversationId,
        seq: seq.present ? seq.value : this.seq,
        sortKey: sortKey ?? this.sortKey,
        senderId: senderId ?? this.senderId,
        kind: kind ?? this.kind,
        payload: payload ?? this.payload,
        searchText: searchText.present ? searchText.value : this.searchText,
        state: state ?? this.state,
        replyToId: replyToId.present ? replyToId.value : this.replyToId,
        editVersion: editVersion ?? this.editVersion,
        deleted: deleted ?? this.deleted,
        createdLocalAt: createdLocalAt ?? this.createdLocalAt,
        serverTs: serverTs.present ? serverTs.value : this.serverTs,
      );
  Message copyWithCompanion(MessagesCompanion data) {
    return Message(
      id: data.id.present ? data.id.value : this.id,
      conversationId: data.conversationId.present
          ? data.conversationId.value
          : this.conversationId,
      seq: data.seq.present ? data.seq.value : this.seq,
      sortKey: data.sortKey.present ? data.sortKey.value : this.sortKey,
      senderId: data.senderId.present ? data.senderId.value : this.senderId,
      kind: data.kind.present ? data.kind.value : this.kind,
      payload: data.payload.present ? data.payload.value : this.payload,
      searchText:
          data.searchText.present ? data.searchText.value : this.searchText,
      state: data.state.present ? data.state.value : this.state,
      replyToId: data.replyToId.present ? data.replyToId.value : this.replyToId,
      editVersion:
          data.editVersion.present ? data.editVersion.value : this.editVersion,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      createdLocalAt: data.createdLocalAt.present
          ? data.createdLocalAt.value
          : this.createdLocalAt,
      serverTs: data.serverTs.present ? data.serverTs.value : this.serverTs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Message(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('seq: $seq, ')
          ..write('sortKey: $sortKey, ')
          ..write('senderId: $senderId, ')
          ..write('kind: $kind, ')
          ..write('payload: $payload, ')
          ..write('searchText: $searchText, ')
          ..write('state: $state, ')
          ..write('replyToId: $replyToId, ')
          ..write('editVersion: $editVersion, ')
          ..write('deleted: $deleted, ')
          ..write('createdLocalAt: $createdLocalAt, ')
          ..write('serverTs: $serverTs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      conversationId,
      seq,
      sortKey,
      senderId,
      kind,
      $driftBlobEquality.hash(payload),
      searchText,
      state,
      replyToId,
      editVersion,
      deleted,
      createdLocalAt,
      serverTs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Message &&
          other.id == this.id &&
          other.conversationId == this.conversationId &&
          other.seq == this.seq &&
          other.sortKey == this.sortKey &&
          other.senderId == this.senderId &&
          other.kind == this.kind &&
          $driftBlobEquality.equals(other.payload, this.payload) &&
          other.searchText == this.searchText &&
          other.state == this.state &&
          other.replyToId == this.replyToId &&
          other.editVersion == this.editVersion &&
          other.deleted == this.deleted &&
          other.createdLocalAt == this.createdLocalAt &&
          other.serverTs == this.serverTs);
}

class MessagesCompanion extends UpdateCompanion<Message> {
  final Value<String> id;
  final Value<String> conversationId;
  final Value<BigInt?> seq;
  final Value<BigInt> sortKey;
  final Value<String> senderId;
  final Value<int> kind;
  final Value<Uint8List> payload;
  final Value<String?> searchText;
  final Value<String> state;
  final Value<String?> replyToId;
  final Value<int> editVersion;
  final Value<bool> deleted;
  final Value<DateTime> createdLocalAt;
  final Value<DateTime?> serverTs;
  final Value<int> rowid;
  const MessagesCompanion({
    this.id = const Value.absent(),
    this.conversationId = const Value.absent(),
    this.seq = const Value.absent(),
    this.sortKey = const Value.absent(),
    this.senderId = const Value.absent(),
    this.kind = const Value.absent(),
    this.payload = const Value.absent(),
    this.searchText = const Value.absent(),
    this.state = const Value.absent(),
    this.replyToId = const Value.absent(),
    this.editVersion = const Value.absent(),
    this.deleted = const Value.absent(),
    this.createdLocalAt = const Value.absent(),
    this.serverTs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MessagesCompanion.insert({
    required String id,
    required String conversationId,
    this.seq = const Value.absent(),
    required BigInt sortKey,
    required String senderId,
    this.kind = const Value.absent(),
    required Uint8List payload,
    this.searchText = const Value.absent(),
    this.state = const Value.absent(),
    this.replyToId = const Value.absent(),
    this.editVersion = const Value.absent(),
    this.deleted = const Value.absent(),
    required DateTime createdLocalAt,
    this.serverTs = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        conversationId = Value(conversationId),
        sortKey = Value(sortKey),
        senderId = Value(senderId),
        payload = Value(payload),
        createdLocalAt = Value(createdLocalAt);
  static Insertable<Message> custom({
    Expression<String>? id,
    Expression<String>? conversationId,
    Expression<BigInt>? seq,
    Expression<BigInt>? sortKey,
    Expression<String>? senderId,
    Expression<int>? kind,
    Expression<Uint8List>? payload,
    Expression<String>? searchText,
    Expression<String>? state,
    Expression<String>? replyToId,
    Expression<int>? editVersion,
    Expression<bool>? deleted,
    Expression<DateTime>? createdLocalAt,
    Expression<DateTime>? serverTs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (conversationId != null) 'conversation_id': conversationId,
      if (seq != null) 'seq': seq,
      if (sortKey != null) 'sort_key': sortKey,
      if (senderId != null) 'sender_id': senderId,
      if (kind != null) 'kind': kind,
      if (payload != null) 'payload': payload,
      if (searchText != null) 'search_text': searchText,
      if (state != null) 'state': state,
      if (replyToId != null) 'reply_to_id': replyToId,
      if (editVersion != null) 'edit_version': editVersion,
      if (deleted != null) 'deleted': deleted,
      if (createdLocalAt != null) 'created_local_at': createdLocalAt,
      if (serverTs != null) 'server_ts': serverTs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MessagesCompanion copyWith(
      {Value<String>? id,
      Value<String>? conversationId,
      Value<BigInt?>? seq,
      Value<BigInt>? sortKey,
      Value<String>? senderId,
      Value<int>? kind,
      Value<Uint8List>? payload,
      Value<String?>? searchText,
      Value<String>? state,
      Value<String?>? replyToId,
      Value<int>? editVersion,
      Value<bool>? deleted,
      Value<DateTime>? createdLocalAt,
      Value<DateTime?>? serverTs,
      Value<int>? rowid}) {
    return MessagesCompanion(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      seq: seq ?? this.seq,
      sortKey: sortKey ?? this.sortKey,
      senderId: senderId ?? this.senderId,
      kind: kind ?? this.kind,
      payload: payload ?? this.payload,
      searchText: searchText ?? this.searchText,
      state: state ?? this.state,
      replyToId: replyToId ?? this.replyToId,
      editVersion: editVersion ?? this.editVersion,
      deleted: deleted ?? this.deleted,
      createdLocalAt: createdLocalAt ?? this.createdLocalAt,
      serverTs: serverTs ?? this.serverTs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (seq.present) {
      map['seq'] = Variable<BigInt>(seq.value);
    }
    if (sortKey.present) {
      map['sort_key'] = Variable<BigInt>(sortKey.value);
    }
    if (senderId.present) {
      map['sender_id'] = Variable<String>(senderId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<int>(kind.value);
    }
    if (payload.present) {
      map['payload'] = Variable<Uint8List>(payload.value);
    }
    if (searchText.present) {
      map['search_text'] = Variable<String>(searchText.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (replyToId.present) {
      map['reply_to_id'] = Variable<String>(replyToId.value);
    }
    if (editVersion.present) {
      map['edit_version'] = Variable<int>(editVersion.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (createdLocalAt.present) {
      map['created_local_at'] = Variable<DateTime>(createdLocalAt.value);
    }
    if (serverTs.present) {
      map['server_ts'] = Variable<DateTime>(serverTs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessagesCompanion(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('seq: $seq, ')
          ..write('sortKey: $sortKey, ')
          ..write('senderId: $senderId, ')
          ..write('kind: $kind, ')
          ..write('payload: $payload, ')
          ..write('searchText: $searchText, ')
          ..write('state: $state, ')
          ..write('replyToId: $replyToId, ')
          ..write('editVersion: $editVersion, ')
          ..write('deleted: $deleted, ')
          ..write('createdLocalAt: $createdLocalAt, ')
          ..write('serverTs: $serverTs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OutboxEntriesTable extends OutboxEntries
    with TableInfo<$OutboxEntriesTable, OutboxEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutboxEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _messageIdMeta =
      const VerificationMeta('messageId');
  @override
  late final GeneratedColumn<String> messageId = GeneratedColumn<String>(
      'message_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _conversationIdMeta =
      const VerificationMeta('conversationId');
  @override
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
      'conversation_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<int> kind = GeneratedColumn<int>(
      'kind', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _payloadMeta =
      const VerificationMeta('payload');
  @override
  late final GeneratedColumn<Uint8List> payload = GeneratedColumn<Uint8List>(
      'payload', aliasedName, false,
      type: DriftSqlType.blob, requiredDuringInsert: true);
  static const VerificationMeta _replyToIdMeta =
      const VerificationMeta('replyToId');
  @override
  late final GeneratedColumn<String> replyToId = GeneratedColumn<String>(
      'reply_to_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _clientTsMsMeta =
      const VerificationMeta('clientTsMs');
  @override
  late final GeneratedColumn<BigInt> clientTsMs = GeneratedColumn<BigInt>(
      'client_ts_ms', aliasedName, false,
      type: DriftSqlType.bigInt, requiredDuringInsert: true);
  static const VerificationMeta _attemptsMeta =
      const VerificationMeta('attempts');
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
      'attempts', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _nextTryAtMeta =
      const VerificationMeta('nextTryAt');
  @override
  late final GeneratedColumn<DateTime> nextTryAt = GeneratedColumn<DateTime>(
      'next_try_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        messageId,
        conversationId,
        kind,
        payload,
        replyToId,
        clientTsMs,
        attempts,
        nextTryAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'outbox_entries';
  @override
  VerificationContext validateIntegrity(Insertable<OutboxEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('message_id')) {
      context.handle(_messageIdMeta,
          messageId.isAcceptableOrUnknown(data['message_id']!, _messageIdMeta));
    } else if (isInserting) {
      context.missing(_messageIdMeta);
    }
    if (data.containsKey('conversation_id')) {
      context.handle(
          _conversationIdMeta,
          conversationId.isAcceptableOrUnknown(
              data['conversation_id']!, _conversationIdMeta));
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
          _kindMeta, kind.isAcceptableOrUnknown(data['kind']!, _kindMeta));
    }
    if (data.containsKey('payload')) {
      context.handle(_payloadMeta,
          payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta));
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('reply_to_id')) {
      context.handle(
          _replyToIdMeta,
          replyToId.isAcceptableOrUnknown(
              data['reply_to_id']!, _replyToIdMeta));
    }
    if (data.containsKey('client_ts_ms')) {
      context.handle(
          _clientTsMsMeta,
          clientTsMs.isAcceptableOrUnknown(
              data['client_ts_ms']!, _clientTsMsMeta));
    } else if (isInserting) {
      context.missing(_clientTsMsMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(_attemptsMeta,
          attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta));
    }
    if (data.containsKey('next_try_at')) {
      context.handle(
          _nextTryAtMeta,
          nextTryAt.isAcceptableOrUnknown(
              data['next_try_at']!, _nextTryAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OutboxEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutboxEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      messageId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message_id'])!,
      conversationId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}conversation_id'])!,
      kind: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}kind'])!,
      payload: attachedDatabase.typeMapping
          .read(DriftSqlType.blob, data['${effectivePrefix}payload'])!,
      replyToId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reply_to_id']),
      clientTsMs: attachedDatabase.typeMapping
          .read(DriftSqlType.bigInt, data['${effectivePrefix}client_ts_ms'])!,
      attempts: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}attempts'])!,
      nextTryAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}next_try_at']),
    );
  }

  @override
  $OutboxEntriesTable createAlias(String alias) {
    return $OutboxEntriesTable(attachedDatabase, alias);
  }
}

class OutboxEntry extends DataClass implements Insertable<OutboxEntry> {
  final String id;
  final String messageId;
  final String conversationId;
  final int kind;
  final Uint8List payload;
  final String? replyToId;
  final BigInt clientTsMs;
  final int attempts;
  final DateTime? nextTryAt;
  const OutboxEntry(
      {required this.id,
      required this.messageId,
      required this.conversationId,
      required this.kind,
      required this.payload,
      this.replyToId,
      required this.clientTsMs,
      required this.attempts,
      this.nextTryAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['message_id'] = Variable<String>(messageId);
    map['conversation_id'] = Variable<String>(conversationId);
    map['kind'] = Variable<int>(kind);
    map['payload'] = Variable<Uint8List>(payload);
    if (!nullToAbsent || replyToId != null) {
      map['reply_to_id'] = Variable<String>(replyToId);
    }
    map['client_ts_ms'] = Variable<BigInt>(clientTsMs);
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || nextTryAt != null) {
      map['next_try_at'] = Variable<DateTime>(nextTryAt);
    }
    return map;
  }

  OutboxEntriesCompanion toCompanion(bool nullToAbsent) {
    return OutboxEntriesCompanion(
      id: Value(id),
      messageId: Value(messageId),
      conversationId: Value(conversationId),
      kind: Value(kind),
      payload: Value(payload),
      replyToId: replyToId == null && nullToAbsent
          ? const Value.absent()
          : Value(replyToId),
      clientTsMs: Value(clientTsMs),
      attempts: Value(attempts),
      nextTryAt: nextTryAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextTryAt),
    );
  }

  factory OutboxEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutboxEntry(
      id: serializer.fromJson<String>(json['id']),
      messageId: serializer.fromJson<String>(json['messageId']),
      conversationId: serializer.fromJson<String>(json['conversationId']),
      kind: serializer.fromJson<int>(json['kind']),
      payload: serializer.fromJson<Uint8List>(json['payload']),
      replyToId: serializer.fromJson<String?>(json['replyToId']),
      clientTsMs: serializer.fromJson<BigInt>(json['clientTsMs']),
      attempts: serializer.fromJson<int>(json['attempts']),
      nextTryAt: serializer.fromJson<DateTime?>(json['nextTryAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'messageId': serializer.toJson<String>(messageId),
      'conversationId': serializer.toJson<String>(conversationId),
      'kind': serializer.toJson<int>(kind),
      'payload': serializer.toJson<Uint8List>(payload),
      'replyToId': serializer.toJson<String?>(replyToId),
      'clientTsMs': serializer.toJson<BigInt>(clientTsMs),
      'attempts': serializer.toJson<int>(attempts),
      'nextTryAt': serializer.toJson<DateTime?>(nextTryAt),
    };
  }

  OutboxEntry copyWith(
          {String? id,
          String? messageId,
          String? conversationId,
          int? kind,
          Uint8List? payload,
          Value<String?> replyToId = const Value.absent(),
          BigInt? clientTsMs,
          int? attempts,
          Value<DateTime?> nextTryAt = const Value.absent()}) =>
      OutboxEntry(
        id: id ?? this.id,
        messageId: messageId ?? this.messageId,
        conversationId: conversationId ?? this.conversationId,
        kind: kind ?? this.kind,
        payload: payload ?? this.payload,
        replyToId: replyToId.present ? replyToId.value : this.replyToId,
        clientTsMs: clientTsMs ?? this.clientTsMs,
        attempts: attempts ?? this.attempts,
        nextTryAt: nextTryAt.present ? nextTryAt.value : this.nextTryAt,
      );
  OutboxEntry copyWithCompanion(OutboxEntriesCompanion data) {
    return OutboxEntry(
      id: data.id.present ? data.id.value : this.id,
      messageId: data.messageId.present ? data.messageId.value : this.messageId,
      conversationId: data.conversationId.present
          ? data.conversationId.value
          : this.conversationId,
      kind: data.kind.present ? data.kind.value : this.kind,
      payload: data.payload.present ? data.payload.value : this.payload,
      replyToId: data.replyToId.present ? data.replyToId.value : this.replyToId,
      clientTsMs:
          data.clientTsMs.present ? data.clientTsMs.value : this.clientTsMs,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      nextTryAt: data.nextTryAt.present ? data.nextTryAt.value : this.nextTryAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutboxEntry(')
          ..write('id: $id, ')
          ..write('messageId: $messageId, ')
          ..write('conversationId: $conversationId, ')
          ..write('kind: $kind, ')
          ..write('payload: $payload, ')
          ..write('replyToId: $replyToId, ')
          ..write('clientTsMs: $clientTsMs, ')
          ..write('attempts: $attempts, ')
          ..write('nextTryAt: $nextTryAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      messageId,
      conversationId,
      kind,
      $driftBlobEquality.hash(payload),
      replyToId,
      clientTsMs,
      attempts,
      nextTryAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutboxEntry &&
          other.id == this.id &&
          other.messageId == this.messageId &&
          other.conversationId == this.conversationId &&
          other.kind == this.kind &&
          $driftBlobEquality.equals(other.payload, this.payload) &&
          other.replyToId == this.replyToId &&
          other.clientTsMs == this.clientTsMs &&
          other.attempts == this.attempts &&
          other.nextTryAt == this.nextTryAt);
}

class OutboxEntriesCompanion extends UpdateCompanion<OutboxEntry> {
  final Value<String> id;
  final Value<String> messageId;
  final Value<String> conversationId;
  final Value<int> kind;
  final Value<Uint8List> payload;
  final Value<String?> replyToId;
  final Value<BigInt> clientTsMs;
  final Value<int> attempts;
  final Value<DateTime?> nextTryAt;
  final Value<int> rowid;
  const OutboxEntriesCompanion({
    this.id = const Value.absent(),
    this.messageId = const Value.absent(),
    this.conversationId = const Value.absent(),
    this.kind = const Value.absent(),
    this.payload = const Value.absent(),
    this.replyToId = const Value.absent(),
    this.clientTsMs = const Value.absent(),
    this.attempts = const Value.absent(),
    this.nextTryAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OutboxEntriesCompanion.insert({
    required String id,
    required String messageId,
    required String conversationId,
    this.kind = const Value.absent(),
    required Uint8List payload,
    this.replyToId = const Value.absent(),
    required BigInt clientTsMs,
    this.attempts = const Value.absent(),
    this.nextTryAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        messageId = Value(messageId),
        conversationId = Value(conversationId),
        payload = Value(payload),
        clientTsMs = Value(clientTsMs);
  static Insertable<OutboxEntry> custom({
    Expression<String>? id,
    Expression<String>? messageId,
    Expression<String>? conversationId,
    Expression<int>? kind,
    Expression<Uint8List>? payload,
    Expression<String>? replyToId,
    Expression<BigInt>? clientTsMs,
    Expression<int>? attempts,
    Expression<DateTime>? nextTryAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (messageId != null) 'message_id': messageId,
      if (conversationId != null) 'conversation_id': conversationId,
      if (kind != null) 'kind': kind,
      if (payload != null) 'payload': payload,
      if (replyToId != null) 'reply_to_id': replyToId,
      if (clientTsMs != null) 'client_ts_ms': clientTsMs,
      if (attempts != null) 'attempts': attempts,
      if (nextTryAt != null) 'next_try_at': nextTryAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OutboxEntriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? messageId,
      Value<String>? conversationId,
      Value<int>? kind,
      Value<Uint8List>? payload,
      Value<String?>? replyToId,
      Value<BigInt>? clientTsMs,
      Value<int>? attempts,
      Value<DateTime?>? nextTryAt,
      Value<int>? rowid}) {
    return OutboxEntriesCompanion(
      id: id ?? this.id,
      messageId: messageId ?? this.messageId,
      conversationId: conversationId ?? this.conversationId,
      kind: kind ?? this.kind,
      payload: payload ?? this.payload,
      replyToId: replyToId ?? this.replyToId,
      clientTsMs: clientTsMs ?? this.clientTsMs,
      attempts: attempts ?? this.attempts,
      nextTryAt: nextTryAt ?? this.nextTryAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (messageId.present) {
      map['message_id'] = Variable<String>(messageId.value);
    }
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<int>(kind.value);
    }
    if (payload.present) {
      map['payload'] = Variable<Uint8List>(payload.value);
    }
    if (replyToId.present) {
      map['reply_to_id'] = Variable<String>(replyToId.value);
    }
    if (clientTsMs.present) {
      map['client_ts_ms'] = Variable<BigInt>(clientTsMs.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (nextTryAt.present) {
      map['next_try_at'] = Variable<DateTime>(nextTryAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OutboxEntriesCompanion(')
          ..write('id: $id, ')
          ..write('messageId: $messageId, ')
          ..write('conversationId: $conversationId, ')
          ..write('kind: $kind, ')
          ..write('payload: $payload, ')
          ..write('replyToId: $replyToId, ')
          ..write('clientTsMs: $clientTsMs, ')
          ..write('attempts: $attempts, ')
          ..write('nextTryAt: $nextTryAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MediaFilesTable extends MediaFiles
    with TableInfo<$MediaFilesTable, MediaFile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MediaFilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _mediaIdMeta =
      const VerificationMeta('mediaId');
  @override
  late final GeneratedColumn<String> mediaId = GeneratedColumn<String>(
      'media_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _localPathMeta =
      const VerificationMeta('localPath');
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
      'local_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
      'state', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bytesDoneMeta =
      const VerificationMeta('bytesDone');
  @override
  late final GeneratedColumn<int> bytesDone = GeneratedColumn<int>(
      'bytes_done', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _fileKeyMeta =
      const VerificationMeta('fileKey');
  @override
  late final GeneratedColumn<String> fileKey = GeneratedColumn<String>(
      'file_key', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [mediaId, localPath, state, bytesDone, fileKey];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'media_files';
  @override
  VerificationContext validateIntegrity(Insertable<MediaFile> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('media_id')) {
      context.handle(_mediaIdMeta,
          mediaId.isAcceptableOrUnknown(data['media_id']!, _mediaIdMeta));
    } else if (isInserting) {
      context.missing(_mediaIdMeta);
    }
    if (data.containsKey('local_path')) {
      context.handle(_localPathMeta,
          localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta));
    }
    if (data.containsKey('state')) {
      context.handle(
          _stateMeta, state.isAcceptableOrUnknown(data['state']!, _stateMeta));
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('bytes_done')) {
      context.handle(_bytesDoneMeta,
          bytesDone.isAcceptableOrUnknown(data['bytes_done']!, _bytesDoneMeta));
    }
    if (data.containsKey('file_key')) {
      context.handle(_fileKeyMeta,
          fileKey.isAcceptableOrUnknown(data['file_key']!, _fileKeyMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {mediaId};
  @override
  MediaFile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MediaFile(
      mediaId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}media_id'])!,
      localPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}local_path']),
      state: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}state'])!,
      bytesDone: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bytes_done'])!,
      fileKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_key']),
    );
  }

  @override
  $MediaFilesTable createAlias(String alias) {
    return $MediaFilesTable(attachedDatabase, alias);
  }
}

class MediaFile extends DataClass implements Insertable<MediaFile> {
  final String mediaId;
  final String? localPath;
  final String state;
  final int bytesDone;
  final String? fileKey;
  const MediaFile(
      {required this.mediaId,
      this.localPath,
      required this.state,
      required this.bytesDone,
      this.fileKey});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['media_id'] = Variable<String>(mediaId);
    if (!nullToAbsent || localPath != null) {
      map['local_path'] = Variable<String>(localPath);
    }
    map['state'] = Variable<String>(state);
    map['bytes_done'] = Variable<int>(bytesDone);
    if (!nullToAbsent || fileKey != null) {
      map['file_key'] = Variable<String>(fileKey);
    }
    return map;
  }

  MediaFilesCompanion toCompanion(bool nullToAbsent) {
    return MediaFilesCompanion(
      mediaId: Value(mediaId),
      localPath: localPath == null && nullToAbsent
          ? const Value.absent()
          : Value(localPath),
      state: Value(state),
      bytesDone: Value(bytesDone),
      fileKey: fileKey == null && nullToAbsent
          ? const Value.absent()
          : Value(fileKey),
    );
  }

  factory MediaFile.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MediaFile(
      mediaId: serializer.fromJson<String>(json['mediaId']),
      localPath: serializer.fromJson<String?>(json['localPath']),
      state: serializer.fromJson<String>(json['state']),
      bytesDone: serializer.fromJson<int>(json['bytesDone']),
      fileKey: serializer.fromJson<String?>(json['fileKey']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'mediaId': serializer.toJson<String>(mediaId),
      'localPath': serializer.toJson<String?>(localPath),
      'state': serializer.toJson<String>(state),
      'bytesDone': serializer.toJson<int>(bytesDone),
      'fileKey': serializer.toJson<String?>(fileKey),
    };
  }

  MediaFile copyWith(
          {String? mediaId,
          Value<String?> localPath = const Value.absent(),
          String? state,
          int? bytesDone,
          Value<String?> fileKey = const Value.absent()}) =>
      MediaFile(
        mediaId: mediaId ?? this.mediaId,
        localPath: localPath.present ? localPath.value : this.localPath,
        state: state ?? this.state,
        bytesDone: bytesDone ?? this.bytesDone,
        fileKey: fileKey.present ? fileKey.value : this.fileKey,
      );
  MediaFile copyWithCompanion(MediaFilesCompanion data) {
    return MediaFile(
      mediaId: data.mediaId.present ? data.mediaId.value : this.mediaId,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      state: data.state.present ? data.state.value : this.state,
      bytesDone: data.bytesDone.present ? data.bytesDone.value : this.bytesDone,
      fileKey: data.fileKey.present ? data.fileKey.value : this.fileKey,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MediaFile(')
          ..write('mediaId: $mediaId, ')
          ..write('localPath: $localPath, ')
          ..write('state: $state, ')
          ..write('bytesDone: $bytesDone, ')
          ..write('fileKey: $fileKey')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(mediaId, localPath, state, bytesDone, fileKey);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MediaFile &&
          other.mediaId == this.mediaId &&
          other.localPath == this.localPath &&
          other.state == this.state &&
          other.bytesDone == this.bytesDone &&
          other.fileKey == this.fileKey);
}

class MediaFilesCompanion extends UpdateCompanion<MediaFile> {
  final Value<String> mediaId;
  final Value<String?> localPath;
  final Value<String> state;
  final Value<int> bytesDone;
  final Value<String?> fileKey;
  final Value<int> rowid;
  const MediaFilesCompanion({
    this.mediaId = const Value.absent(),
    this.localPath = const Value.absent(),
    this.state = const Value.absent(),
    this.bytesDone = const Value.absent(),
    this.fileKey = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MediaFilesCompanion.insert({
    required String mediaId,
    this.localPath = const Value.absent(),
    required String state,
    this.bytesDone = const Value.absent(),
    this.fileKey = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : mediaId = Value(mediaId),
        state = Value(state);
  static Insertable<MediaFile> custom({
    Expression<String>? mediaId,
    Expression<String>? localPath,
    Expression<String>? state,
    Expression<int>? bytesDone,
    Expression<String>? fileKey,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (mediaId != null) 'media_id': mediaId,
      if (localPath != null) 'local_path': localPath,
      if (state != null) 'state': state,
      if (bytesDone != null) 'bytes_done': bytesDone,
      if (fileKey != null) 'file_key': fileKey,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MediaFilesCompanion copyWith(
      {Value<String>? mediaId,
      Value<String?>? localPath,
      Value<String>? state,
      Value<int>? bytesDone,
      Value<String?>? fileKey,
      Value<int>? rowid}) {
    return MediaFilesCompanion(
      mediaId: mediaId ?? this.mediaId,
      localPath: localPath ?? this.localPath,
      state: state ?? this.state,
      bytesDone: bytesDone ?? this.bytesDone,
      fileKey: fileKey ?? this.fileKey,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (mediaId.present) {
      map['media_id'] = Variable<String>(mediaId.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (bytesDone.present) {
      map['bytes_done'] = Variable<int>(bytesDone.value);
    }
    if (fileKey.present) {
      map['file_key'] = Variable<String>(fileKey.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MediaFilesCompanion(')
          ..write('mediaId: $mediaId, ')
          ..write('localPath: $localPath, ')
          ..write('state: $state, ')
          ..write('bytesDone: $bytesDone, ')
          ..write('fileKey: $fileKey, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReactionsTable extends Reactions
    with TableInfo<$ReactionsTable, Reaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _messageIdMeta =
      const VerificationMeta('messageId');
  @override
  late final GeneratedColumn<String> messageId = GeneratedColumn<String>(
      'message_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
      'emoji', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [messageId, userId, emoji];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reactions';
  @override
  VerificationContext validateIntegrity(Insertable<Reaction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('message_id')) {
      context.handle(_messageIdMeta,
          messageId.isAcceptableOrUnknown(data['message_id']!, _messageIdMeta));
    } else if (isInserting) {
      context.missing(_messageIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('emoji')) {
      context.handle(
          _emojiMeta, emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta));
    } else if (isInserting) {
      context.missing(_emojiMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {messageId, userId};
  @override
  Reaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reaction(
      messageId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      emoji: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}emoji'])!,
    );
  }

  @override
  $ReactionsTable createAlias(String alias) {
    return $ReactionsTable(attachedDatabase, alias);
  }
}

class Reaction extends DataClass implements Insertable<Reaction> {
  final String messageId;
  final String userId;
  final String emoji;
  const Reaction(
      {required this.messageId, required this.userId, required this.emoji});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['message_id'] = Variable<String>(messageId);
    map['user_id'] = Variable<String>(userId);
    map['emoji'] = Variable<String>(emoji);
    return map;
  }

  ReactionsCompanion toCompanion(bool nullToAbsent) {
    return ReactionsCompanion(
      messageId: Value(messageId),
      userId: Value(userId),
      emoji: Value(emoji),
    );
  }

  factory Reaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reaction(
      messageId: serializer.fromJson<String>(json['messageId']),
      userId: serializer.fromJson<String>(json['userId']),
      emoji: serializer.fromJson<String>(json['emoji']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'messageId': serializer.toJson<String>(messageId),
      'userId': serializer.toJson<String>(userId),
      'emoji': serializer.toJson<String>(emoji),
    };
  }

  Reaction copyWith({String? messageId, String? userId, String? emoji}) =>
      Reaction(
        messageId: messageId ?? this.messageId,
        userId: userId ?? this.userId,
        emoji: emoji ?? this.emoji,
      );
  Reaction copyWithCompanion(ReactionsCompanion data) {
    return Reaction(
      messageId: data.messageId.present ? data.messageId.value : this.messageId,
      userId: data.userId.present ? data.userId.value : this.userId,
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reaction(')
          ..write('messageId: $messageId, ')
          ..write('userId: $userId, ')
          ..write('emoji: $emoji')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(messageId, userId, emoji);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reaction &&
          other.messageId == this.messageId &&
          other.userId == this.userId &&
          other.emoji == this.emoji);
}

class ReactionsCompanion extends UpdateCompanion<Reaction> {
  final Value<String> messageId;
  final Value<String> userId;
  final Value<String> emoji;
  final Value<int> rowid;
  const ReactionsCompanion({
    this.messageId = const Value.absent(),
    this.userId = const Value.absent(),
    this.emoji = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReactionsCompanion.insert({
    required String messageId,
    required String userId,
    required String emoji,
    this.rowid = const Value.absent(),
  })  : messageId = Value(messageId),
        userId = Value(userId),
        emoji = Value(emoji);
  static Insertable<Reaction> custom({
    Expression<String>? messageId,
    Expression<String>? userId,
    Expression<String>? emoji,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (messageId != null) 'message_id': messageId,
      if (userId != null) 'user_id': userId,
      if (emoji != null) 'emoji': emoji,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReactionsCompanion copyWith(
      {Value<String>? messageId,
      Value<String>? userId,
      Value<String>? emoji,
      Value<int>? rowid}) {
    return ReactionsCompanion(
      messageId: messageId ?? this.messageId,
      userId: userId ?? this.userId,
      emoji: emoji ?? this.emoji,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (messageId.present) {
      map['message_id'] = Variable<String>(messageId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReactionsCompanion(')
          ..write('messageId: $messageId, ')
          ..write('userId: $userId, ')
          ..write('emoji: $emoji, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsersCacheTable extends UsersCache
    with TableInfo<$UsersCacheTable, UsersCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _displayNameMeta =
      const VerificationMeta('displayName');
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
      'display_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _avatarRefMeta =
      const VerificationMeta('avatarRef');
  @override
  late final GeneratedColumn<String> avatarRef = GeneratedColumn<String>(
      'avatar_ref', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, username, displayName, avatarRef, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users_cache';
  @override
  VerificationContext validateIntegrity(Insertable<UsersCacheData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
          _displayNameMeta,
          displayName.isAcceptableOrUnknown(
              data['display_name']!, _displayNameMeta));
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('avatar_ref')) {
      context.handle(_avatarRefMeta,
          avatarRef.isAcceptableOrUnknown(data['avatar_ref']!, _avatarRefMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UsersCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UsersCacheData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      displayName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}display_name'])!,
      avatarRef: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar_ref']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $UsersCacheTable createAlias(String alias) {
    return $UsersCacheTable(attachedDatabase, alias);
  }
}

class UsersCacheData extends DataClass implements Insertable<UsersCacheData> {
  final String id;
  final String username;
  final String displayName;
  final String? avatarRef;
  final DateTime updatedAt;
  const UsersCacheData(
      {required this.id,
      required this.username,
      required this.displayName,
      this.avatarRef,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['username'] = Variable<String>(username);
    map['display_name'] = Variable<String>(displayName);
    if (!nullToAbsent || avatarRef != null) {
      map['avatar_ref'] = Variable<String>(avatarRef);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UsersCacheCompanion toCompanion(bool nullToAbsent) {
    return UsersCacheCompanion(
      id: Value(id),
      username: Value(username),
      displayName: Value(displayName),
      avatarRef: avatarRef == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarRef),
      updatedAt: Value(updatedAt),
    );
  }

  factory UsersCacheData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UsersCacheData(
      id: serializer.fromJson<String>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      displayName: serializer.fromJson<String>(json['displayName']),
      avatarRef: serializer.fromJson<String?>(json['avatarRef']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'username': serializer.toJson<String>(username),
      'displayName': serializer.toJson<String>(displayName),
      'avatarRef': serializer.toJson<String?>(avatarRef),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UsersCacheData copyWith(
          {String? id,
          String? username,
          String? displayName,
          Value<String?> avatarRef = const Value.absent(),
          DateTime? updatedAt}) =>
      UsersCacheData(
        id: id ?? this.id,
        username: username ?? this.username,
        displayName: displayName ?? this.displayName,
        avatarRef: avatarRef.present ? avatarRef.value : this.avatarRef,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  UsersCacheData copyWithCompanion(UsersCacheCompanion data) {
    return UsersCacheData(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      displayName:
          data.displayName.present ? data.displayName.value : this.displayName,
      avatarRef: data.avatarRef.present ? data.avatarRef.value : this.avatarRef,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UsersCacheData(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('displayName: $displayName, ')
          ..write('avatarRef: $avatarRef, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, username, displayName, avatarRef, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UsersCacheData &&
          other.id == this.id &&
          other.username == this.username &&
          other.displayName == this.displayName &&
          other.avatarRef == this.avatarRef &&
          other.updatedAt == this.updatedAt);
}

class UsersCacheCompanion extends UpdateCompanion<UsersCacheData> {
  final Value<String> id;
  final Value<String> username;
  final Value<String> displayName;
  final Value<String?> avatarRef;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const UsersCacheCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.displayName = const Value.absent(),
    this.avatarRef = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCacheCompanion.insert({
    required String id,
    required String username,
    required String displayName,
    this.avatarRef = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        username = Value(username),
        displayName = Value(displayName),
        updatedAt = Value(updatedAt);
  static Insertable<UsersCacheData> custom({
    Expression<String>? id,
    Expression<String>? username,
    Expression<String>? displayName,
    Expression<String>? avatarRef,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (displayName != null) 'display_name': displayName,
      if (avatarRef != null) 'avatar_ref': avatarRef,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCacheCompanion copyWith(
      {Value<String>? id,
      Value<String>? username,
      Value<String>? displayName,
      Value<String?>? avatarRef,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return UsersCacheCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      avatarRef: avatarRef ?? this.avatarRef,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (avatarRef.present) {
      map['avatar_ref'] = Variable<String>(avatarRef.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCacheCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('displayName: $displayName, ')
          ..write('avatarRef: $avatarRef, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncStatesTable extends SyncStates
    with TableInfo<$SyncStatesTable, SyncState> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_states';
  @override
  VerificationContext validateIntegrity(Insertable<SyncState> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SyncState map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncState(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $SyncStatesTable createAlias(String alias) {
    return $SyncStatesTable(attachedDatabase, alias);
  }
}

class SyncState extends DataClass implements Insertable<SyncState> {
  final String key;
  final String value;
  const SyncState({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SyncStatesCompanion toCompanion(bool nullToAbsent) {
    return SyncStatesCompanion(
      key: Value(key),
      value: Value(value),
    );
  }

  factory SyncState.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncState(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  SyncState copyWith({String? key, String? value}) => SyncState(
        key: key ?? this.key,
        value: value ?? this.value,
      );
  SyncState copyWithCompanion(SyncStatesCompanion data) {
    return SyncState(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncState(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncState &&
          other.key == this.key &&
          other.value == this.value);
}

class SyncStatesCompanion extends UpdateCompanion<SyncState> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SyncStatesCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncStatesCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        value = Value(value);
  static Insertable<SyncState> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncStatesCompanion copyWith(
      {Value<String>? key, Value<String>? value, Value<int>? rowid}) {
    return SyncStatesCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncStatesCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$StealthDatabase extends GeneratedDatabase {
  _$StealthDatabase(QueryExecutor e) : super(e);
  $StealthDatabaseManager get managers => $StealthDatabaseManager(this);
  late final $ConversationsTable conversations = $ConversationsTable(this);
  late final $ConversationMembersTable conversationMembers =
      $ConversationMembersTable(this);
  late final $MessagesTable messages = $MessagesTable(this);
  late final $OutboxEntriesTable outboxEntries = $OutboxEntriesTable(this);
  late final $MediaFilesTable mediaFiles = $MediaFilesTable(this);
  late final $ReactionsTable reactions = $ReactionsTable(this);
  late final $UsersCacheTable usersCache = $UsersCacheTable(this);
  late final $SyncStatesTable syncStates = $SyncStatesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        conversations,
        conversationMembers,
        messages,
        outboxEntries,
        mediaFiles,
        reactions,
        usersCache,
        syncStates
      ];
}

typedef $$ConversationsTableCreateCompanionBuilder = ConversationsCompanion
    Function({
  required String id,
  Value<String> kind,
  Value<String?> title,
  Value<String?> avatarRef,
  Value<BigInt> lastSeq,
  Value<String?> lastMessagePreview,
  Value<DateTime?> lastMessageAt,
  Value<int> unreadCount,
  Value<int> mentionCount,
  Value<BigInt> peerDeliveredSeq,
  Value<BigInt> peerReadSeq,
  Value<DateTime?> mutedUntil,
  Value<DateTime?> pinnedAt,
  Value<DateTime?> archivedAt,
  Value<String?> draftText,
  Value<BigInt> syncVersion,
  Value<int> rowid,
});
typedef $$ConversationsTableUpdateCompanionBuilder = ConversationsCompanion
    Function({
  Value<String> id,
  Value<String> kind,
  Value<String?> title,
  Value<String?> avatarRef,
  Value<BigInt> lastSeq,
  Value<String?> lastMessagePreview,
  Value<DateTime?> lastMessageAt,
  Value<int> unreadCount,
  Value<int> mentionCount,
  Value<BigInt> peerDeliveredSeq,
  Value<BigInt> peerReadSeq,
  Value<DateTime?> mutedUntil,
  Value<DateTime?> pinnedAt,
  Value<DateTime?> archivedAt,
  Value<String?> draftText,
  Value<BigInt> syncVersion,
  Value<int> rowid,
});

class $$ConversationsTableFilterComposer
    extends Composer<_$StealthDatabase, $ConversationsTable> {
  $$ConversationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kind => $composableBuilder(
      column: $table.kind, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get avatarRef => $composableBuilder(
      column: $table.avatarRef, builder: (column) => ColumnFilters(column));

  ColumnFilters<BigInt> get lastSeq => $composableBuilder(
      column: $table.lastSeq, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastMessagePreview => $composableBuilder(
      column: $table.lastMessagePreview,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastMessageAt => $composableBuilder(
      column: $table.lastMessageAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get unreadCount => $composableBuilder(
      column: $table.unreadCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get mentionCount => $composableBuilder(
      column: $table.mentionCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<BigInt> get peerDeliveredSeq => $composableBuilder(
      column: $table.peerDeliveredSeq,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<BigInt> get peerReadSeq => $composableBuilder(
      column: $table.peerReadSeq, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get mutedUntil => $composableBuilder(
      column: $table.mutedUntil, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get pinnedAt => $composableBuilder(
      column: $table.pinnedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
      column: $table.archivedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get draftText => $composableBuilder(
      column: $table.draftText, builder: (column) => ColumnFilters(column));

  ColumnFilters<BigInt> get syncVersion => $composableBuilder(
      column: $table.syncVersion, builder: (column) => ColumnFilters(column));
}

class $$ConversationsTableOrderingComposer
    extends Composer<_$StealthDatabase, $ConversationsTable> {
  $$ConversationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kind => $composableBuilder(
      column: $table.kind, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get avatarRef => $composableBuilder(
      column: $table.avatarRef, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<BigInt> get lastSeq => $composableBuilder(
      column: $table.lastSeq, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastMessagePreview => $composableBuilder(
      column: $table.lastMessagePreview,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastMessageAt => $composableBuilder(
      column: $table.lastMessageAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get unreadCount => $composableBuilder(
      column: $table.unreadCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get mentionCount => $composableBuilder(
      column: $table.mentionCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<BigInt> get peerDeliveredSeq => $composableBuilder(
      column: $table.peerDeliveredSeq,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<BigInt> get peerReadSeq => $composableBuilder(
      column: $table.peerReadSeq, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get mutedUntil => $composableBuilder(
      column: $table.mutedUntil, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get pinnedAt => $composableBuilder(
      column: $table.pinnedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
      column: $table.archivedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get draftText => $composableBuilder(
      column: $table.draftText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<BigInt> get syncVersion => $composableBuilder(
      column: $table.syncVersion, builder: (column) => ColumnOrderings(column));
}

class $$ConversationsTableAnnotationComposer
    extends Composer<_$StealthDatabase, $ConversationsTable> {
  $$ConversationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get avatarRef =>
      $composableBuilder(column: $table.avatarRef, builder: (column) => column);

  GeneratedColumn<BigInt> get lastSeq =>
      $composableBuilder(column: $table.lastSeq, builder: (column) => column);

  GeneratedColumn<String> get lastMessagePreview => $composableBuilder(
      column: $table.lastMessagePreview, builder: (column) => column);

  GeneratedColumn<DateTime> get lastMessageAt => $composableBuilder(
      column: $table.lastMessageAt, builder: (column) => column);

  GeneratedColumn<int> get unreadCount => $composableBuilder(
      column: $table.unreadCount, builder: (column) => column);

  GeneratedColumn<int> get mentionCount => $composableBuilder(
      column: $table.mentionCount, builder: (column) => column);

  GeneratedColumn<BigInt> get peerDeliveredSeq => $composableBuilder(
      column: $table.peerDeliveredSeq, builder: (column) => column);

  GeneratedColumn<BigInt> get peerReadSeq => $composableBuilder(
      column: $table.peerReadSeq, builder: (column) => column);

  GeneratedColumn<DateTime> get mutedUntil => $composableBuilder(
      column: $table.mutedUntil, builder: (column) => column);

  GeneratedColumn<DateTime> get pinnedAt =>
      $composableBuilder(column: $table.pinnedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
      column: $table.archivedAt, builder: (column) => column);

  GeneratedColumn<String> get draftText =>
      $composableBuilder(column: $table.draftText, builder: (column) => column);

  GeneratedColumn<BigInt> get syncVersion => $composableBuilder(
      column: $table.syncVersion, builder: (column) => column);
}

class $$ConversationsTableTableManager extends RootTableManager<
    _$StealthDatabase,
    $ConversationsTable,
    Conversation,
    $$ConversationsTableFilterComposer,
    $$ConversationsTableOrderingComposer,
    $$ConversationsTableAnnotationComposer,
    $$ConversationsTableCreateCompanionBuilder,
    $$ConversationsTableUpdateCompanionBuilder,
    (
      Conversation,
      BaseReferences<_$StealthDatabase, $ConversationsTable, Conversation>
    ),
    Conversation,
    PrefetchHooks Function()> {
  $$ConversationsTableTableManager(
      _$StealthDatabase db, $ConversationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConversationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConversationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConversationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> kind = const Value.absent(),
            Value<String?> title = const Value.absent(),
            Value<String?> avatarRef = const Value.absent(),
            Value<BigInt> lastSeq = const Value.absent(),
            Value<String?> lastMessagePreview = const Value.absent(),
            Value<DateTime?> lastMessageAt = const Value.absent(),
            Value<int> unreadCount = const Value.absent(),
            Value<int> mentionCount = const Value.absent(),
            Value<BigInt> peerDeliveredSeq = const Value.absent(),
            Value<BigInt> peerReadSeq = const Value.absent(),
            Value<DateTime?> mutedUntil = const Value.absent(),
            Value<DateTime?> pinnedAt = const Value.absent(),
            Value<DateTime?> archivedAt = const Value.absent(),
            Value<String?> draftText = const Value.absent(),
            Value<BigInt> syncVersion = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ConversationsCompanion(
            id: id,
            kind: kind,
            title: title,
            avatarRef: avatarRef,
            lastSeq: lastSeq,
            lastMessagePreview: lastMessagePreview,
            lastMessageAt: lastMessageAt,
            unreadCount: unreadCount,
            mentionCount: mentionCount,
            peerDeliveredSeq: peerDeliveredSeq,
            peerReadSeq: peerReadSeq,
            mutedUntil: mutedUntil,
            pinnedAt: pinnedAt,
            archivedAt: archivedAt,
            draftText: draftText,
            syncVersion: syncVersion,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String> kind = const Value.absent(),
            Value<String?> title = const Value.absent(),
            Value<String?> avatarRef = const Value.absent(),
            Value<BigInt> lastSeq = const Value.absent(),
            Value<String?> lastMessagePreview = const Value.absent(),
            Value<DateTime?> lastMessageAt = const Value.absent(),
            Value<int> unreadCount = const Value.absent(),
            Value<int> mentionCount = const Value.absent(),
            Value<BigInt> peerDeliveredSeq = const Value.absent(),
            Value<BigInt> peerReadSeq = const Value.absent(),
            Value<DateTime?> mutedUntil = const Value.absent(),
            Value<DateTime?> pinnedAt = const Value.absent(),
            Value<DateTime?> archivedAt = const Value.absent(),
            Value<String?> draftText = const Value.absent(),
            Value<BigInt> syncVersion = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ConversationsCompanion.insert(
            id: id,
            kind: kind,
            title: title,
            avatarRef: avatarRef,
            lastSeq: lastSeq,
            lastMessagePreview: lastMessagePreview,
            lastMessageAt: lastMessageAt,
            unreadCount: unreadCount,
            mentionCount: mentionCount,
            peerDeliveredSeq: peerDeliveredSeq,
            peerReadSeq: peerReadSeq,
            mutedUntil: mutedUntil,
            pinnedAt: pinnedAt,
            archivedAt: archivedAt,
            draftText: draftText,
            syncVersion: syncVersion,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ConversationsTableProcessedTableManager = ProcessedTableManager<
    _$StealthDatabase,
    $ConversationsTable,
    Conversation,
    $$ConversationsTableFilterComposer,
    $$ConversationsTableOrderingComposer,
    $$ConversationsTableAnnotationComposer,
    $$ConversationsTableCreateCompanionBuilder,
    $$ConversationsTableUpdateCompanionBuilder,
    (
      Conversation,
      BaseReferences<_$StealthDatabase, $ConversationsTable, Conversation>
    ),
    Conversation,
    PrefetchHooks Function()>;
typedef $$ConversationMembersTableCreateCompanionBuilder
    = ConversationMembersCompanion Function({
  required String conversationId,
  required String userId,
  Value<String> role,
  Value<BigInt> deliveredSeq,
  Value<BigInt> readSeq,
  Value<int> rowid,
});
typedef $$ConversationMembersTableUpdateCompanionBuilder
    = ConversationMembersCompanion Function({
  Value<String> conversationId,
  Value<String> userId,
  Value<String> role,
  Value<BigInt> deliveredSeq,
  Value<BigInt> readSeq,
  Value<int> rowid,
});

class $$ConversationMembersTableFilterComposer
    extends Composer<_$StealthDatabase, $ConversationMembersTable> {
  $$ConversationMembersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get conversationId => $composableBuilder(
      column: $table.conversationId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<BigInt> get deliveredSeq => $composableBuilder(
      column: $table.deliveredSeq, builder: (column) => ColumnFilters(column));

  ColumnFilters<BigInt> get readSeq => $composableBuilder(
      column: $table.readSeq, builder: (column) => ColumnFilters(column));
}

class $$ConversationMembersTableOrderingComposer
    extends Composer<_$StealthDatabase, $ConversationMembersTable> {
  $$ConversationMembersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get conversationId => $composableBuilder(
      column: $table.conversationId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<BigInt> get deliveredSeq => $composableBuilder(
      column: $table.deliveredSeq,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<BigInt> get readSeq => $composableBuilder(
      column: $table.readSeq, builder: (column) => ColumnOrderings(column));
}

class $$ConversationMembersTableAnnotationComposer
    extends Composer<_$StealthDatabase, $ConversationMembersTable> {
  $$ConversationMembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get conversationId => $composableBuilder(
      column: $table.conversationId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<BigInt> get deliveredSeq => $composableBuilder(
      column: $table.deliveredSeq, builder: (column) => column);

  GeneratedColumn<BigInt> get readSeq =>
      $composableBuilder(column: $table.readSeq, builder: (column) => column);
}

class $$ConversationMembersTableTableManager extends RootTableManager<
    _$StealthDatabase,
    $ConversationMembersTable,
    ConversationMember,
    $$ConversationMembersTableFilterComposer,
    $$ConversationMembersTableOrderingComposer,
    $$ConversationMembersTableAnnotationComposer,
    $$ConversationMembersTableCreateCompanionBuilder,
    $$ConversationMembersTableUpdateCompanionBuilder,
    (
      ConversationMember,
      BaseReferences<_$StealthDatabase, $ConversationMembersTable,
          ConversationMember>
    ),
    ConversationMember,
    PrefetchHooks Function()> {
  $$ConversationMembersTableTableManager(
      _$StealthDatabase db, $ConversationMembersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConversationMembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConversationMembersTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConversationMembersTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> conversationId = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<BigInt> deliveredSeq = const Value.absent(),
            Value<BigInt> readSeq = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ConversationMembersCompanion(
            conversationId: conversationId,
            userId: userId,
            role: role,
            deliveredSeq: deliveredSeq,
            readSeq: readSeq,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String conversationId,
            required String userId,
            Value<String> role = const Value.absent(),
            Value<BigInt> deliveredSeq = const Value.absent(),
            Value<BigInt> readSeq = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ConversationMembersCompanion.insert(
            conversationId: conversationId,
            userId: userId,
            role: role,
            deliveredSeq: deliveredSeq,
            readSeq: readSeq,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ConversationMembersTableProcessedTableManager = ProcessedTableManager<
    _$StealthDatabase,
    $ConversationMembersTable,
    ConversationMember,
    $$ConversationMembersTableFilterComposer,
    $$ConversationMembersTableOrderingComposer,
    $$ConversationMembersTableAnnotationComposer,
    $$ConversationMembersTableCreateCompanionBuilder,
    $$ConversationMembersTableUpdateCompanionBuilder,
    (
      ConversationMember,
      BaseReferences<_$StealthDatabase, $ConversationMembersTable,
          ConversationMember>
    ),
    ConversationMember,
    PrefetchHooks Function()>;
typedef $$MessagesTableCreateCompanionBuilder = MessagesCompanion Function({
  required String id,
  required String conversationId,
  Value<BigInt?> seq,
  required BigInt sortKey,
  required String senderId,
  Value<int> kind,
  required Uint8List payload,
  Value<String?> searchText,
  Value<String> state,
  Value<String?> replyToId,
  Value<int> editVersion,
  Value<bool> deleted,
  required DateTime createdLocalAt,
  Value<DateTime?> serverTs,
  Value<int> rowid,
});
typedef $$MessagesTableUpdateCompanionBuilder = MessagesCompanion Function({
  Value<String> id,
  Value<String> conversationId,
  Value<BigInt?> seq,
  Value<BigInt> sortKey,
  Value<String> senderId,
  Value<int> kind,
  Value<Uint8List> payload,
  Value<String?> searchText,
  Value<String> state,
  Value<String?> replyToId,
  Value<int> editVersion,
  Value<bool> deleted,
  Value<DateTime> createdLocalAt,
  Value<DateTime?> serverTs,
  Value<int> rowid,
});

class $$MessagesTableFilterComposer
    extends Composer<_$StealthDatabase, $MessagesTable> {
  $$MessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get conversationId => $composableBuilder(
      column: $table.conversationId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<BigInt> get seq => $composableBuilder(
      column: $table.seq, builder: (column) => ColumnFilters(column));

  ColumnFilters<BigInt> get sortKey => $composableBuilder(
      column: $table.sortKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get senderId => $composableBuilder(
      column: $table.senderId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get kind => $composableBuilder(
      column: $table.kind, builder: (column) => ColumnFilters(column));

  ColumnFilters<Uint8List> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get searchText => $composableBuilder(
      column: $table.searchText, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get state => $composableBuilder(
      column: $table.state, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get replyToId => $composableBuilder(
      column: $table.replyToId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get editVersion => $composableBuilder(
      column: $table.editVersion, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdLocalAt => $composableBuilder(
      column: $table.createdLocalAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get serverTs => $composableBuilder(
      column: $table.serverTs, builder: (column) => ColumnFilters(column));
}

class $$MessagesTableOrderingComposer
    extends Composer<_$StealthDatabase, $MessagesTable> {
  $$MessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get conversationId => $composableBuilder(
      column: $table.conversationId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<BigInt> get seq => $composableBuilder(
      column: $table.seq, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<BigInt> get sortKey => $composableBuilder(
      column: $table.sortKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get senderId => $composableBuilder(
      column: $table.senderId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get kind => $composableBuilder(
      column: $table.kind, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<Uint8List> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get searchText => $composableBuilder(
      column: $table.searchText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get state => $composableBuilder(
      column: $table.state, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get replyToId => $composableBuilder(
      column: $table.replyToId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get editVersion => $composableBuilder(
      column: $table.editVersion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdLocalAt => $composableBuilder(
      column: $table.createdLocalAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get serverTs => $composableBuilder(
      column: $table.serverTs, builder: (column) => ColumnOrderings(column));
}

class $$MessagesTableAnnotationComposer
    extends Composer<_$StealthDatabase, $MessagesTable> {
  $$MessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get conversationId => $composableBuilder(
      column: $table.conversationId, builder: (column) => column);

  GeneratedColumn<BigInt> get seq =>
      $composableBuilder(column: $table.seq, builder: (column) => column);

  GeneratedColumn<BigInt> get sortKey =>
      $composableBuilder(column: $table.sortKey, builder: (column) => column);

  GeneratedColumn<String> get senderId =>
      $composableBuilder(column: $table.senderId, builder: (column) => column);

  GeneratedColumn<int> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<Uint8List> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<String> get searchText => $composableBuilder(
      column: $table.searchText, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get replyToId =>
      $composableBuilder(column: $table.replyToId, builder: (column) => column);

  GeneratedColumn<int> get editVersion => $composableBuilder(
      column: $table.editVersion, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<DateTime> get createdLocalAt => $composableBuilder(
      column: $table.createdLocalAt, builder: (column) => column);

  GeneratedColumn<DateTime> get serverTs =>
      $composableBuilder(column: $table.serverTs, builder: (column) => column);
}

class $$MessagesTableTableManager extends RootTableManager<
    _$StealthDatabase,
    $MessagesTable,
    Message,
    $$MessagesTableFilterComposer,
    $$MessagesTableOrderingComposer,
    $$MessagesTableAnnotationComposer,
    $$MessagesTableCreateCompanionBuilder,
    $$MessagesTableUpdateCompanionBuilder,
    (Message, BaseReferences<_$StealthDatabase, $MessagesTable, Message>),
    Message,
    PrefetchHooks Function()> {
  $$MessagesTableTableManager(_$StealthDatabase db, $MessagesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> conversationId = const Value.absent(),
            Value<BigInt?> seq = const Value.absent(),
            Value<BigInt> sortKey = const Value.absent(),
            Value<String> senderId = const Value.absent(),
            Value<int> kind = const Value.absent(),
            Value<Uint8List> payload = const Value.absent(),
            Value<String?> searchText = const Value.absent(),
            Value<String> state = const Value.absent(),
            Value<String?> replyToId = const Value.absent(),
            Value<int> editVersion = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<DateTime> createdLocalAt = const Value.absent(),
            Value<DateTime?> serverTs = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MessagesCompanion(
            id: id,
            conversationId: conversationId,
            seq: seq,
            sortKey: sortKey,
            senderId: senderId,
            kind: kind,
            payload: payload,
            searchText: searchText,
            state: state,
            replyToId: replyToId,
            editVersion: editVersion,
            deleted: deleted,
            createdLocalAt: createdLocalAt,
            serverTs: serverTs,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String conversationId,
            Value<BigInt?> seq = const Value.absent(),
            required BigInt sortKey,
            required String senderId,
            Value<int> kind = const Value.absent(),
            required Uint8List payload,
            Value<String?> searchText = const Value.absent(),
            Value<String> state = const Value.absent(),
            Value<String?> replyToId = const Value.absent(),
            Value<int> editVersion = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            required DateTime createdLocalAt,
            Value<DateTime?> serverTs = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MessagesCompanion.insert(
            id: id,
            conversationId: conversationId,
            seq: seq,
            sortKey: sortKey,
            senderId: senderId,
            kind: kind,
            payload: payload,
            searchText: searchText,
            state: state,
            replyToId: replyToId,
            editVersion: editVersion,
            deleted: deleted,
            createdLocalAt: createdLocalAt,
            serverTs: serverTs,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MessagesTableProcessedTableManager = ProcessedTableManager<
    _$StealthDatabase,
    $MessagesTable,
    Message,
    $$MessagesTableFilterComposer,
    $$MessagesTableOrderingComposer,
    $$MessagesTableAnnotationComposer,
    $$MessagesTableCreateCompanionBuilder,
    $$MessagesTableUpdateCompanionBuilder,
    (Message, BaseReferences<_$StealthDatabase, $MessagesTable, Message>),
    Message,
    PrefetchHooks Function()>;
typedef $$OutboxEntriesTableCreateCompanionBuilder = OutboxEntriesCompanion
    Function({
  required String id,
  required String messageId,
  required String conversationId,
  Value<int> kind,
  required Uint8List payload,
  Value<String?> replyToId,
  required BigInt clientTsMs,
  Value<int> attempts,
  Value<DateTime?> nextTryAt,
  Value<int> rowid,
});
typedef $$OutboxEntriesTableUpdateCompanionBuilder = OutboxEntriesCompanion
    Function({
  Value<String> id,
  Value<String> messageId,
  Value<String> conversationId,
  Value<int> kind,
  Value<Uint8List> payload,
  Value<String?> replyToId,
  Value<BigInt> clientTsMs,
  Value<int> attempts,
  Value<DateTime?> nextTryAt,
  Value<int> rowid,
});

class $$OutboxEntriesTableFilterComposer
    extends Composer<_$StealthDatabase, $OutboxEntriesTable> {
  $$OutboxEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get messageId => $composableBuilder(
      column: $table.messageId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get conversationId => $composableBuilder(
      column: $table.conversationId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get kind => $composableBuilder(
      column: $table.kind, builder: (column) => ColumnFilters(column));

  ColumnFilters<Uint8List> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get replyToId => $composableBuilder(
      column: $table.replyToId, builder: (column) => ColumnFilters(column));

  ColumnFilters<BigInt> get clientTsMs => $composableBuilder(
      column: $table.clientTsMs, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get attempts => $composableBuilder(
      column: $table.attempts, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get nextTryAt => $composableBuilder(
      column: $table.nextTryAt, builder: (column) => ColumnFilters(column));
}

class $$OutboxEntriesTableOrderingComposer
    extends Composer<_$StealthDatabase, $OutboxEntriesTable> {
  $$OutboxEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get messageId => $composableBuilder(
      column: $table.messageId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get conversationId => $composableBuilder(
      column: $table.conversationId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get kind => $composableBuilder(
      column: $table.kind, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<Uint8List> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get replyToId => $composableBuilder(
      column: $table.replyToId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<BigInt> get clientTsMs => $composableBuilder(
      column: $table.clientTsMs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get attempts => $composableBuilder(
      column: $table.attempts, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get nextTryAt => $composableBuilder(
      column: $table.nextTryAt, builder: (column) => ColumnOrderings(column));
}

class $$OutboxEntriesTableAnnotationComposer
    extends Composer<_$StealthDatabase, $OutboxEntriesTable> {
  $$OutboxEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get messageId =>
      $composableBuilder(column: $table.messageId, builder: (column) => column);

  GeneratedColumn<String> get conversationId => $composableBuilder(
      column: $table.conversationId, builder: (column) => column);

  GeneratedColumn<int> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<Uint8List> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<String> get replyToId =>
      $composableBuilder(column: $table.replyToId, builder: (column) => column);

  GeneratedColumn<BigInt> get clientTsMs => $composableBuilder(
      column: $table.clientTsMs, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<DateTime> get nextTryAt =>
      $composableBuilder(column: $table.nextTryAt, builder: (column) => column);
}

class $$OutboxEntriesTableTableManager extends RootTableManager<
    _$StealthDatabase,
    $OutboxEntriesTable,
    OutboxEntry,
    $$OutboxEntriesTableFilterComposer,
    $$OutboxEntriesTableOrderingComposer,
    $$OutboxEntriesTableAnnotationComposer,
    $$OutboxEntriesTableCreateCompanionBuilder,
    $$OutboxEntriesTableUpdateCompanionBuilder,
    (
      OutboxEntry,
      BaseReferences<_$StealthDatabase, $OutboxEntriesTable, OutboxEntry>
    ),
    OutboxEntry,
    PrefetchHooks Function()> {
  $$OutboxEntriesTableTableManager(
      _$StealthDatabase db, $OutboxEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OutboxEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OutboxEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OutboxEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> messageId = const Value.absent(),
            Value<String> conversationId = const Value.absent(),
            Value<int> kind = const Value.absent(),
            Value<Uint8List> payload = const Value.absent(),
            Value<String?> replyToId = const Value.absent(),
            Value<BigInt> clientTsMs = const Value.absent(),
            Value<int> attempts = const Value.absent(),
            Value<DateTime?> nextTryAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              OutboxEntriesCompanion(
            id: id,
            messageId: messageId,
            conversationId: conversationId,
            kind: kind,
            payload: payload,
            replyToId: replyToId,
            clientTsMs: clientTsMs,
            attempts: attempts,
            nextTryAt: nextTryAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String messageId,
            required String conversationId,
            Value<int> kind = const Value.absent(),
            required Uint8List payload,
            Value<String?> replyToId = const Value.absent(),
            required BigInt clientTsMs,
            Value<int> attempts = const Value.absent(),
            Value<DateTime?> nextTryAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              OutboxEntriesCompanion.insert(
            id: id,
            messageId: messageId,
            conversationId: conversationId,
            kind: kind,
            payload: payload,
            replyToId: replyToId,
            clientTsMs: clientTsMs,
            attempts: attempts,
            nextTryAt: nextTryAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$OutboxEntriesTableProcessedTableManager = ProcessedTableManager<
    _$StealthDatabase,
    $OutboxEntriesTable,
    OutboxEntry,
    $$OutboxEntriesTableFilterComposer,
    $$OutboxEntriesTableOrderingComposer,
    $$OutboxEntriesTableAnnotationComposer,
    $$OutboxEntriesTableCreateCompanionBuilder,
    $$OutboxEntriesTableUpdateCompanionBuilder,
    (
      OutboxEntry,
      BaseReferences<_$StealthDatabase, $OutboxEntriesTable, OutboxEntry>
    ),
    OutboxEntry,
    PrefetchHooks Function()>;
typedef $$MediaFilesTableCreateCompanionBuilder = MediaFilesCompanion Function({
  required String mediaId,
  Value<String?> localPath,
  required String state,
  Value<int> bytesDone,
  Value<String?> fileKey,
  Value<int> rowid,
});
typedef $$MediaFilesTableUpdateCompanionBuilder = MediaFilesCompanion Function({
  Value<String> mediaId,
  Value<String?> localPath,
  Value<String> state,
  Value<int> bytesDone,
  Value<String?> fileKey,
  Value<int> rowid,
});

class $$MediaFilesTableFilterComposer
    extends Composer<_$StealthDatabase, $MediaFilesTable> {
  $$MediaFilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get mediaId => $composableBuilder(
      column: $table.mediaId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get localPath => $composableBuilder(
      column: $table.localPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get state => $composableBuilder(
      column: $table.state, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bytesDone => $composableBuilder(
      column: $table.bytesDone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fileKey => $composableBuilder(
      column: $table.fileKey, builder: (column) => ColumnFilters(column));
}

class $$MediaFilesTableOrderingComposer
    extends Composer<_$StealthDatabase, $MediaFilesTable> {
  $$MediaFilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get mediaId => $composableBuilder(
      column: $table.mediaId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localPath => $composableBuilder(
      column: $table.localPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get state => $composableBuilder(
      column: $table.state, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bytesDone => $composableBuilder(
      column: $table.bytesDone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fileKey => $composableBuilder(
      column: $table.fileKey, builder: (column) => ColumnOrderings(column));
}

class $$MediaFilesTableAnnotationComposer
    extends Composer<_$StealthDatabase, $MediaFilesTable> {
  $$MediaFilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get mediaId =>
      $composableBuilder(column: $table.mediaId, builder: (column) => column);

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<int> get bytesDone =>
      $composableBuilder(column: $table.bytesDone, builder: (column) => column);

  GeneratedColumn<String> get fileKey =>
      $composableBuilder(column: $table.fileKey, builder: (column) => column);
}

class $$MediaFilesTableTableManager extends RootTableManager<
    _$StealthDatabase,
    $MediaFilesTable,
    MediaFile,
    $$MediaFilesTableFilterComposer,
    $$MediaFilesTableOrderingComposer,
    $$MediaFilesTableAnnotationComposer,
    $$MediaFilesTableCreateCompanionBuilder,
    $$MediaFilesTableUpdateCompanionBuilder,
    (MediaFile, BaseReferences<_$StealthDatabase, $MediaFilesTable, MediaFile>),
    MediaFile,
    PrefetchHooks Function()> {
  $$MediaFilesTableTableManager(_$StealthDatabase db, $MediaFilesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MediaFilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MediaFilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MediaFilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> mediaId = const Value.absent(),
            Value<String?> localPath = const Value.absent(),
            Value<String> state = const Value.absent(),
            Value<int> bytesDone = const Value.absent(),
            Value<String?> fileKey = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MediaFilesCompanion(
            mediaId: mediaId,
            localPath: localPath,
            state: state,
            bytesDone: bytesDone,
            fileKey: fileKey,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String mediaId,
            Value<String?> localPath = const Value.absent(),
            required String state,
            Value<int> bytesDone = const Value.absent(),
            Value<String?> fileKey = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MediaFilesCompanion.insert(
            mediaId: mediaId,
            localPath: localPath,
            state: state,
            bytesDone: bytesDone,
            fileKey: fileKey,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MediaFilesTableProcessedTableManager = ProcessedTableManager<
    _$StealthDatabase,
    $MediaFilesTable,
    MediaFile,
    $$MediaFilesTableFilterComposer,
    $$MediaFilesTableOrderingComposer,
    $$MediaFilesTableAnnotationComposer,
    $$MediaFilesTableCreateCompanionBuilder,
    $$MediaFilesTableUpdateCompanionBuilder,
    (MediaFile, BaseReferences<_$StealthDatabase, $MediaFilesTable, MediaFile>),
    MediaFile,
    PrefetchHooks Function()>;
typedef $$ReactionsTableCreateCompanionBuilder = ReactionsCompanion Function({
  required String messageId,
  required String userId,
  required String emoji,
  Value<int> rowid,
});
typedef $$ReactionsTableUpdateCompanionBuilder = ReactionsCompanion Function({
  Value<String> messageId,
  Value<String> userId,
  Value<String> emoji,
  Value<int> rowid,
});

class $$ReactionsTableFilterComposer
    extends Composer<_$StealthDatabase, $ReactionsTable> {
  $$ReactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get messageId => $composableBuilder(
      column: $table.messageId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get emoji => $composableBuilder(
      column: $table.emoji, builder: (column) => ColumnFilters(column));
}

class $$ReactionsTableOrderingComposer
    extends Composer<_$StealthDatabase, $ReactionsTable> {
  $$ReactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get messageId => $composableBuilder(
      column: $table.messageId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get emoji => $composableBuilder(
      column: $table.emoji, builder: (column) => ColumnOrderings(column));
}

class $$ReactionsTableAnnotationComposer
    extends Composer<_$StealthDatabase, $ReactionsTable> {
  $$ReactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get messageId =>
      $composableBuilder(column: $table.messageId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get emoji =>
      $composableBuilder(column: $table.emoji, builder: (column) => column);
}

class $$ReactionsTableTableManager extends RootTableManager<
    _$StealthDatabase,
    $ReactionsTable,
    Reaction,
    $$ReactionsTableFilterComposer,
    $$ReactionsTableOrderingComposer,
    $$ReactionsTableAnnotationComposer,
    $$ReactionsTableCreateCompanionBuilder,
    $$ReactionsTableUpdateCompanionBuilder,
    (Reaction, BaseReferences<_$StealthDatabase, $ReactionsTable, Reaction>),
    Reaction,
    PrefetchHooks Function()> {
  $$ReactionsTableTableManager(_$StealthDatabase db, $ReactionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> messageId = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> emoji = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReactionsCompanion(
            messageId: messageId,
            userId: userId,
            emoji: emoji,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String messageId,
            required String userId,
            required String emoji,
            Value<int> rowid = const Value.absent(),
          }) =>
              ReactionsCompanion.insert(
            messageId: messageId,
            userId: userId,
            emoji: emoji,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ReactionsTableProcessedTableManager = ProcessedTableManager<
    _$StealthDatabase,
    $ReactionsTable,
    Reaction,
    $$ReactionsTableFilterComposer,
    $$ReactionsTableOrderingComposer,
    $$ReactionsTableAnnotationComposer,
    $$ReactionsTableCreateCompanionBuilder,
    $$ReactionsTableUpdateCompanionBuilder,
    (Reaction, BaseReferences<_$StealthDatabase, $ReactionsTable, Reaction>),
    Reaction,
    PrefetchHooks Function()>;
typedef $$UsersCacheTableCreateCompanionBuilder = UsersCacheCompanion Function({
  required String id,
  required String username,
  required String displayName,
  Value<String?> avatarRef,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$UsersCacheTableUpdateCompanionBuilder = UsersCacheCompanion Function({
  Value<String> id,
  Value<String> username,
  Value<String> displayName,
  Value<String?> avatarRef,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$UsersCacheTableFilterComposer
    extends Composer<_$StealthDatabase, $UsersCacheTable> {
  $$UsersCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get avatarRef => $composableBuilder(
      column: $table.avatarRef, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$UsersCacheTableOrderingComposer
    extends Composer<_$StealthDatabase, $UsersCacheTable> {
  $$UsersCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get avatarRef => $composableBuilder(
      column: $table.avatarRef, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$UsersCacheTableAnnotationComposer
    extends Composer<_$StealthDatabase, $UsersCacheTable> {
  $$UsersCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => column);

  GeneratedColumn<String> get avatarRef =>
      $composableBuilder(column: $table.avatarRef, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UsersCacheTableTableManager extends RootTableManager<
    _$StealthDatabase,
    $UsersCacheTable,
    UsersCacheData,
    $$UsersCacheTableFilterComposer,
    $$UsersCacheTableOrderingComposer,
    $$UsersCacheTableAnnotationComposer,
    $$UsersCacheTableCreateCompanionBuilder,
    $$UsersCacheTableUpdateCompanionBuilder,
    (
      UsersCacheData,
      BaseReferences<_$StealthDatabase, $UsersCacheTable, UsersCacheData>
    ),
    UsersCacheData,
    PrefetchHooks Function()> {
  $$UsersCacheTableTableManager(_$StealthDatabase db, $UsersCacheTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> username = const Value.absent(),
            Value<String> displayName = const Value.absent(),
            Value<String?> avatarRef = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersCacheCompanion(
            id: id,
            username: username,
            displayName: displayName,
            avatarRef: avatarRef,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String username,
            required String displayName,
            Value<String?> avatarRef = const Value.absent(),
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersCacheCompanion.insert(
            id: id,
            username: username,
            displayName: displayName,
            avatarRef: avatarRef,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UsersCacheTableProcessedTableManager = ProcessedTableManager<
    _$StealthDatabase,
    $UsersCacheTable,
    UsersCacheData,
    $$UsersCacheTableFilterComposer,
    $$UsersCacheTableOrderingComposer,
    $$UsersCacheTableAnnotationComposer,
    $$UsersCacheTableCreateCompanionBuilder,
    $$UsersCacheTableUpdateCompanionBuilder,
    (
      UsersCacheData,
      BaseReferences<_$StealthDatabase, $UsersCacheTable, UsersCacheData>
    ),
    UsersCacheData,
    PrefetchHooks Function()>;
typedef $$SyncStatesTableCreateCompanionBuilder = SyncStatesCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$SyncStatesTableUpdateCompanionBuilder = SyncStatesCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$SyncStatesTableFilterComposer
    extends Composer<_$StealthDatabase, $SyncStatesTable> {
  $$SyncStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$SyncStatesTableOrderingComposer
    extends Composer<_$StealthDatabase, $SyncStatesTable> {
  $$SyncStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$SyncStatesTableAnnotationComposer
    extends Composer<_$StealthDatabase, $SyncStatesTable> {
  $$SyncStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SyncStatesTableTableManager extends RootTableManager<
    _$StealthDatabase,
    $SyncStatesTable,
    SyncState,
    $$SyncStatesTableFilterComposer,
    $$SyncStatesTableOrderingComposer,
    $$SyncStatesTableAnnotationComposer,
    $$SyncStatesTableCreateCompanionBuilder,
    $$SyncStatesTableUpdateCompanionBuilder,
    (SyncState, BaseReferences<_$StealthDatabase, $SyncStatesTable, SyncState>),
    SyncState,
    PrefetchHooks Function()> {
  $$SyncStatesTableTableManager(_$StealthDatabase db, $SyncStatesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncStatesCompanion(
            key: key,
            value: value,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncStatesCompanion.insert(
            key: key,
            value: value,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncStatesTableProcessedTableManager = ProcessedTableManager<
    _$StealthDatabase,
    $SyncStatesTable,
    SyncState,
    $$SyncStatesTableFilterComposer,
    $$SyncStatesTableOrderingComposer,
    $$SyncStatesTableAnnotationComposer,
    $$SyncStatesTableCreateCompanionBuilder,
    $$SyncStatesTableUpdateCompanionBuilder,
    (SyncState, BaseReferences<_$StealthDatabase, $SyncStatesTable, SyncState>),
    SyncState,
    PrefetchHooks Function()>;

class $StealthDatabaseManager {
  final _$StealthDatabase _db;
  $StealthDatabaseManager(this._db);
  $$ConversationsTableTableManager get conversations =>
      $$ConversationsTableTableManager(_db, _db.conversations);
  $$ConversationMembersTableTableManager get conversationMembers =>
      $$ConversationMembersTableTableManager(_db, _db.conversationMembers);
  $$MessagesTableTableManager get messages =>
      $$MessagesTableTableManager(_db, _db.messages);
  $$OutboxEntriesTableTableManager get outboxEntries =>
      $$OutboxEntriesTableTableManager(_db, _db.outboxEntries);
  $$MediaFilesTableTableManager get mediaFiles =>
      $$MediaFilesTableTableManager(_db, _db.mediaFiles);
  $$ReactionsTableTableManager get reactions =>
      $$ReactionsTableTableManager(_db, _db.reactions);
  $$UsersCacheTableTableManager get usersCache =>
      $$UsersCacheTableTableManager(_db, _db.usersCache);
  $$SyncStatesTableTableManager get syncStates =>
      $$SyncStatesTableTableManager(_db, _db.syncStates);
}
