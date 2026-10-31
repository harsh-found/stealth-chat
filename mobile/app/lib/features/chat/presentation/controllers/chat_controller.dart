import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:stealth_ui_kit/stealth_ui_kit.dart';
import 'package:stealth_protocol/stealth_protocol.dart';
import '../../domain/chat_models.dart';

class ChatState {
  final List<ChatMessageItem> messages;
  final ChatMessageItem? replyingTo;
  final bool isPeerTyping;
  final int peerDeliveredSeq;
  final int peerReadSeq;

  const ChatState({
    this.messages = const [],
    this.replyingTo,
    this.isPeerTyping = false,
    this.peerDeliveredSeq = 0,
    this.peerReadSeq = 0,
  });

  ChatState copyWith({
    List<ChatMessageItem>? messages,
    ChatMessageItem? replyingTo,
    bool clearReply = false,
    bool? isPeerTyping,
    int? peerDeliveredSeq,
    int? peerReadSeq,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      replyingTo: clearReply ? null : (replyingTo ?? this.replyingTo),
      isPeerTyping: isPeerTyping ?? this.isPeerTyping,
      peerDeliveredSeq: peerDeliveredSeq ?? this.peerDeliveredSeq,
      peerReadSeq: peerReadSeq ?? this.peerReadSeq,
    );
  }
}

class ChatController extends StateNotifier<ChatState> {
  final String conversationId;
  final _uuid = const Uuid();
  int _localSeqCounter = 100;

  ChatController({required this.conversationId}) : super(const ChatState()) {
    _loadInitialMessages();
  }

  void _loadInitialMessages() {
    final now = DateTime.now();
    final initial = [
      ChatMessageItem(
        id: 'msg-01',
        conversationId: conversationId,
        senderId: 'peer-user',
        isMe: false,
        text: 'All operational traffic is routed through encrypted SQLite and binary Protobuf.',
        seq: 1,
        sortKey: 1024,
        deliveryStatus: MessageDeliveryStatus.read,
        createdAt: now.subtract(const Duration(minutes: 5)),
      ),
      ChatMessageItem(
        id: 'msg-02',
        conversationId: conversationId,
        senderId: 'my-user',
        isMe: true,
        text: 'Understood. Local database is source of truth, receipts are monotonic cursors.',
        seq: 2,
        sortKey: 2048,
        deliveryStatus: MessageDeliveryStatus.read,
        createdAt: now.subtract(const Duration(minutes: 4)),
      ),
    ];

    state = state.copyWith(
      messages: initial,
      peerDeliveredSeq: 2,
      peerReadSeq: 2,
    );
  }

  void setReply(ChatMessageItem? message) {
    state = state.copyWith(replyingTo: message, clearReply: message == null);
  }

  void sendMessage(String text) {
    final messageId = _uuid.v7();
    final now = DateTime.now();
    final reply = state.replyingTo;

    // 1. Optimistic send: immediate bubble rendered in 1 frame
    final optimisticMsg = ChatMessageItem(
      id: messageId,
      conversationId: conversationId,
      senderId: 'my-user',
      isMe: true,
      text: text,
      kind: MessageKind.text,
      seq: 0,
      sortKey: 1000000 + _localSeqCounter++,
      deliveryStatus: MessageDeliveryStatus.pending,
      replyToId: reply?.id,
      replyAuthor: reply != null ? (reply.isMe ? 'You' : 'Peer') : null,
      replyText: reply?.text,
      createdAt: now,
    );

    state = state.copyWith(
      messages: [optimisticMsg, ...state.messages],
      clearReply: true,
    );

    // 2. Simulate server Ack after 120ms
    Timer(const Duration(milliseconds: 120), () {
      final assignedSeq = (state.messages.map((m) => m.seq).reduce((a, b) => a > b ? a : b)) + 1;
      _updateMessageStatus(messageId, assignedSeq, MessageDeliveryStatus.sent);

      // 3. Simulate peer delivery receipt cursor after 600ms
      Timer(const Duration(milliseconds: 600), () {
        _updateMessageStatus(messageId, assignedSeq, MessageDeliveryStatus.delivered);
        state = state.copyWith(peerDeliveredSeq: assignedSeq);

        // 4. Simulate peer read receipt cursor after 1400ms
        Timer(const Duration(milliseconds: 1400), () {
          _updateMessageStatus(messageId, assignedSeq, MessageDeliveryStatus.read);
          state = state.copyWith(peerReadSeq: assignedSeq);
        });
      });
    });
  }

  void sendVoiceNote(List<int> waveform) {
    final messageId = _uuid.v7();
    final now = DateTime.now();

    final voiceMsg = ChatMessageItem(
      id: messageId,
      conversationId: conversationId,
      senderId: 'my-user',
      isMe: true,
      text: '',
      kind: MessageKind.voice,
      seq: 0,
      sortKey: 1000000 + _localSeqCounter++,
      deliveryStatus: MessageDeliveryStatus.pending,
      waveform: waveform,
      createdAt: now,
    );

    state = state.copyWith(messages: [voiceMsg, ...state.messages]);

    Timer(const Duration(milliseconds: 120), () {
      final assignedSeq = (state.messages.map((m) => m.seq).reduce((a, b) => a > b ? a : b)) + 1;
      _updateMessageStatus(messageId, assignedSeq, MessageDeliveryStatus.sent);
    });
  }

  void _updateMessageStatus(String messageId, int seq, MessageDeliveryStatus status) {
    final updatedList = state.messages.map((m) {
      if (m.id == messageId) {
        return m.copyWith(seq: seq, deliveryStatus: status);
      }
      return m;
    }).toList();

    state = state.copyWith(messages: updatedList);
  }

  void setPeerTyping(bool isTyping) {
    state = state.copyWith(isPeerTyping: isTyping);
  }
}

final chatControllerProvider =
    StateNotifierProvider.family<ChatController, ChatState, String>((ref, conversationId) {
  return ChatController(conversationId: conversationId);
});
