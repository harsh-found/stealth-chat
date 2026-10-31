import 'dart:async';
import 'package:uuid/uuid.dart';
import 'package:stealth_db/stealth_db.dart';
import 'package:stealth_protocol/stealth_protocol.dart';
import 'package:stealth_sync/stealth_sync.dart';
import 'package:stealth_ui_kit/stealth_ui_kit.dart';

import '../../auth/data/auth_service.dart';
import '../domain/chat_models.dart';
import '../domain/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final StealthDatabase database;
  final StealthSyncClient syncClient;
  final String currentUserId;
  final AuthService? authService;
  final String? authToken;
  final _uuid = const Uuid();

  ChatRepositoryImpl({
    required this.database,
    required this.syncClient,
    required this.currentUserId,
    this.authService,
    this.authToken,
  });

  @override
  Stream<List<ConversationSummaryItem>> watchConversations() {
    return database.watchConversations().map((list) {
      return list.map((c) {
        return ConversationSummaryItem(
          id: c.id,
          title: c.title ?? 'Stealth Chat',
          lastMessage: c.lastMessagePreview ?? '',
          timestamp: _formatTimestamp(c.lastMessageAt),
          unreadCount: c.unreadCount,
          isOnline: true,
          lastSeq: c.lastSeq.toInt(),
          peerDeliveredSeq: c.peerDeliveredSeq.toInt(),
          peerReadSeq: c.peerReadSeq.toInt(),
        );
      }).toList();
    });
  }

  @override
  Stream<ConversationSummaryItem?> watchConversation(String conversationId) {
    return database.watchConversation(conversationId).map((c) {
      if (c == null) return null;
      return ConversationSummaryItem(
        id: c.id,
        title: c.title ?? 'Stealth Chat',
        lastMessage: c.lastMessagePreview ?? '',
        timestamp: _formatTimestamp(c.lastMessageAt),
        unreadCount: c.unreadCount,
        isOnline: true,
        lastSeq: c.lastSeq.toInt(),
        peerDeliveredSeq: c.peerDeliveredSeq.toInt(),
        peerReadSeq: c.peerReadSeq.toInt(),
      );
    });
  }

  @override
  Stream<List<ChatMessageItem>> watchMessages(String conversationId) {
    final msgStream = database.watchMessagesPaged(conversationId);
    final convStream = database.watchConversation(conversationId);

    return _combineLatest2(msgStream, convStream, (dbMessages, conv) {
      final peerDelivered = conv?.peerDeliveredSeq.toInt() ?? 0;
      final peerRead = conv?.peerReadSeq.toInt() ?? 0;
      return dbMessages
          .map((m) => _mapMessage(m, peerDelivered, peerRead))
          .toList();
    });
  }

  @override
  Future<ChatMessageItem> sendTextMessage({
    required String conversationId,
    required String text,
    ChatMessageItem? replyingTo,
  }) async {
    final messageId = _uuid.v7();
    final body = MessageBody(text: text);
    final payload = body.toBytes();

    final dbMsg = await database.sendOptimisticMessage(
      messageId: messageId,
      conversationId: conversationId,
      senderId: currentUserId,
      payload: payload,
      kind: MessageKind.text,
      replyToId: replyingTo?.id,
      previewText: text,
    );

    await syncClient.enqueueMessage(
      OutboxItem(
        id: 'out_$messageId',
        messageId: messageId,
        conversationId: conversationId,
        kind: MessageKind.text,
        payload: payload,
        replyToId: replyingTo?.id,
        clientTsMs: DateTime.now().millisecondsSinceEpoch,
      ),
    );

    return _mapMessage(dbMsg, 0, 0);
  }

  @override
  Future<ChatMessageItem> sendVoiceMessage({
    required String conversationId,
    required List<int> waveform,
    required int durationMs,
    ChatMessageItem? replyingTo,
  }) async {
    final messageId = _uuid.v7();
    final body = MessageBody(waveform: waveform, durationMs: durationMs);
    final payload = body.toBytes();

    final dbMsg = await database.sendOptimisticMessage(
      messageId: messageId,
      conversationId: conversationId,
      senderId: currentUserId,
      payload: payload,
      kind: MessageKind.voice,
      replyToId: replyingTo?.id,
      previewText: '[Voice Note]',
    );

    await syncClient.enqueueMessage(
      OutboxItem(
        id: 'out_$messageId',
        messageId: messageId,
        conversationId: conversationId,
        kind: MessageKind.voice,
        payload: payload,
        replyToId: replyingTo?.id,
        clientTsMs: DateTime.now().millisecondsSinceEpoch,
      ),
    );

    return _mapMessage(dbMsg, 0, 0);
  }

  @override
  void sendTyping({required String conversationId, required bool isTyping}) {
    syncClient.sendTyping(conversationId: conversationId, isTyping: isTyping);
  }

  @override
  void markRead({required String conversationId, required int seq}) {
    syncClient.sendReceipt(
      conversationId: conversationId,
      deliveredUptoSeq: seq,
      readUptoSeq: seq,
    );
  }

  @override
  Future<void> syncRemoteConversations() async {
    if (authService == null || authToken == null || authToken!.isEmpty) return;
    try {
      final list = await authService!.getConversations(authToken!);
      for (final conv in list) {
        final id = conv['id'] as String?;
        if (id == null) continue;
        final title = conv['title'] as String? ?? 'Direct Chat';
        final lastSeq = (conv['last_seq'] as num?)?.toInt() ?? 0;
        final unread = (conv['unread_count'] as num?)?.toInt() ?? 0;
        final lastAtStr = conv['last_message_at'] as String?;
        final lastAt = lastAtStr != null ? DateTime.tryParse(lastAtStr) : null;

        await database.upsertConversation(
          id: id,
          title: title,
          lastSeq: lastSeq,
          lastMessagePreview: 'Encrypted channel active.',
          lastMessageAt: lastAt ?? DateTime.now(),
          unreadCount: unread,
        );
      }
    } catch (_) {}
  }

  ChatMessageItem _mapMessage(Message m, int peerDelivered, int peerRead) {
    final isMe = m.senderId == currentUserId;
    final body = MessageBody.fromBytes(m.payload);

    MessageDeliveryStatus status = MessageDeliveryStatus.pending;
    if (isMe) {
      final seq = m.seq?.toInt();
      if (m.state == 'pending' || seq == null || seq <= 0) {
        status = MessageDeliveryStatus.pending;
      } else if (seq <= peerRead) {
        status = MessageDeliveryStatus.read;
      } else if (seq <= peerDelivered) {
        status = MessageDeliveryStatus.delivered;
      } else {
        status = MessageDeliveryStatus.sent;
      }
    }

    return ChatMessageItem(
      id: m.id,
      conversationId: m.conversationId,
      senderId: m.senderId,
      isMe: isMe,
      text: body.text,
      kind: MessageKind.fromValue(m.kind),
      seq: m.seq?.toInt() ?? 0,
      sortKey: m.sortKey.toInt(),
      deliveryStatus: status,
      replyToId: m.replyToId,
      waveform: body.waveform.isNotEmpty ? body.waveform : null,
      createdAt: m.createdLocalAt,
    );
  }

  String _formatTimestamp(DateTime? dt) {
    if (dt == null) return '';
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  Stream<R> _combineLatest2<A, B, R>(
    Stream<A> streamA,
    Stream<B> streamB,
    R Function(A a, B? b) combiner,
  ) {
    final controller = StreamController<R>.broadcast();
    A? latestA;
    B? latestB;
    bool hasA = false;

    void emit() {
      if (hasA) {
        controller.add(combiner(latestA as A, latestB));
      }
    }

    final subA = streamA.listen((a) {
      latestA = a;
      hasA = true;
      emit();
    }, onError: controller.addError);

    final subB = streamB.listen((b) {
      latestB = b;
      emit();
    }, onError: controller.addError);

    controller.onCancel = () {
      subA.cancel();
      subB.cancel();
    };

    return controller.stream;
  }
}
