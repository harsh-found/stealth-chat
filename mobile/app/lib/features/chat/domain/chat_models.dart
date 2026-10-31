import 'package:stealth_ui_kit/stealth_ui_kit.dart';
import 'package:stealth_protocol/stealth_protocol.dart';

class ChatMessageItem {
  final String id;
  final String conversationId;
  final String senderId;
  final bool isMe;
  final String text;
  final MessageKind kind;
  final int seq;
  final int sortKey;
  final MessageDeliveryStatus deliveryStatus;
  final String? replyToId;
  final String? replyAuthor;
  final String? replyText;
  final List<int>? waveform;
  final DateTime createdAt;

  const ChatMessageItem({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.isMe,
    required this.text,
    this.kind = MessageKind.text,
    this.seq = 0,
    required this.sortKey,
    this.deliveryStatus = MessageDeliveryStatus.pending,
    this.replyToId,
    this.replyAuthor,
    this.replyText,
    this.waveform,
    required this.createdAt,
  });

  ChatMessageItem copyWith({
    int? seq,
    int? sortKey,
    MessageDeliveryStatus? deliveryStatus,
    String? replyToId,
    String? replyAuthor,
    String? replyText,
  }) {
    return ChatMessageItem(
      id: id,
      conversationId: conversationId,
      senderId: senderId,
      isMe: isMe,
      text: text,
      kind: kind,
      seq: seq ?? this.seq,
      sortKey: sortKey ?? this.sortKey,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,
      replyToId: replyToId ?? this.replyToId,
      replyAuthor: replyAuthor ?? this.replyAuthor,
      replyText: replyText ?? this.replyText,
      waveform: waveform,
      createdAt: createdAt,
    );
  }
}

class ConversationSummaryItem {
  final String id;
  final String title;
  final String lastMessage;
  final String timestamp;
  final int unreadCount;
  final bool isOnline;
  final int lastSeq;
  final int peerDeliveredSeq;
  final int peerReadSeq;

  const ConversationSummaryItem({
    required this.id,
    required this.title,
    required this.lastMessage,
    required this.timestamp,
    this.unreadCount = 0,
    this.isOnline = false,
    this.lastSeq = 0,
    this.peerDeliveredSeq = 0,
    this.peerReadSeq = 0,
  });

  ConversationSummaryItem copyWith({
    String? lastMessage,
    String? timestamp,
    int? unreadCount,
    bool? isOnline,
    int? lastSeq,
    int? peerDeliveredSeq,
    int? peerReadSeq,
  }) {
    return ConversationSummaryItem(
      id: id,
      title: title,
      lastMessage: lastMessage ?? this.lastMessage,
      timestamp: timestamp ?? this.timestamp,
      unreadCount: unreadCount ?? this.unreadCount,
      isOnline: isOnline ?? this.isOnline,
      lastSeq: lastSeq ?? this.lastSeq,
      peerDeliveredSeq: peerDeliveredSeq ?? this.peerDeliveredSeq,
      peerReadSeq: peerReadSeq ?? this.peerReadSeq,
    );
  }
}
