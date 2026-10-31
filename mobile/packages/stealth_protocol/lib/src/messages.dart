import 'dart:convert';
import 'dart:typed_data';

import 'enums.dart';

class SendMessage {
  final String messageId;
  final String conversationId;
  final MessageKind kind;
  final Uint8List payload;
  final String? replyToId;
  final int clientTsMs;

  const SendMessage({
    required this.messageId,
    required this.conversationId,
    this.kind = MessageKind.text,
    required this.payload,
    this.replyToId,
    required this.clientTsMs,
  });

  Map<String, dynamic> toJson() => {
        'message_id': messageId,
        'conversation_id': conversationId,
        'kind': kind.value,
        'payload': base64Encode(payload),
        if (replyToId != null) 'reply_to_id': replyToId,
        'client_ts_ms': clientTsMs,
      };

  factory SendMessage.fromJson(Map<String, dynamic> json) {
    return SendMessage(
      messageId: json['message_id'] as String,
      conversationId: json['conversation_id'] as String,
      kind: MessageKind.fromValue(json['kind'] as int? ?? 1),
      payload: base64Decode(json['payload'] as String? ?? ''),
      replyToId: json['reply_to_id'] as String?,
      clientTsMs: json['client_ts_ms'] as int? ?? 0,
    );
  }
}

class Ack {
  final String messageId;
  final int seq;
  final int serverTsMs;

  const Ack({
    required this.messageId,
    required this.seq,
    required this.serverTsMs,
  });

  Map<String, dynamic> toJson() => {
        'message_id': messageId,
        'seq': seq,
        'server_ts_ms': serverTsMs,
      };

  factory Ack.fromJson(Map<String, dynamic> json) {
    return Ack(
      messageId: json['message_id'] as String,
      seq: json['seq'] as int? ?? 0,
      serverTsMs: json['server_ts_ms'] as int? ?? 0,
    );
  }
}

class MessageNew {
  final String conversationId;
  final int seq;
  final String messageId;
  final String senderId;
  final MessageKind kind;
  final Uint8List payload;
  final String? replyToId;
  final int serverTsMs;
  final int editVersion;

  const MessageNew({
    required this.conversationId,
    required this.seq,
    required this.messageId,
    required this.senderId,
    this.kind = MessageKind.text,
    required this.payload,
    this.replyToId,
    required this.serverTsMs,
    this.editVersion = 0,
  });

  Map<String, dynamic> toJson() => {
        'conversation_id': conversationId,
        'seq': seq,
        'message_id': messageId,
        'sender_id': senderId,
        'kind': kind.value,
        'payload': base64Encode(payload),
        if (replyToId != null) 'reply_to_id': replyToId,
        'server_ts_ms': serverTsMs,
        'edit_version': editVersion,
      };

  factory MessageNew.fromJson(Map<String, dynamic> json) {
    return MessageNew(
      conversationId: json['conversation_id'] as String,
      seq: json['seq'] as int? ?? 0,
      messageId: json['message_id'] as String,
      senderId: json['sender_id'] as String,
      kind: MessageKind.fromValue(json['kind'] as int? ?? 1),
      payload: base64Decode(json['payload'] as String? ?? ''),
      replyToId: json['reply_to_id'] as String?,
      serverTsMs: json['server_ts_ms'] as int? ?? 0,
      editVersion: json['edit_version'] as int? ?? 0,
    );
  }
}

class ReceiptUpTo {
  final String conversationId;
  final int deliveredUptoSeq;
  final int readUptoSeq;

  const ReceiptUpTo({
    required this.conversationId,
    required this.deliveredUptoSeq,
    required this.readUptoSeq,
  });

  Map<String, dynamic> toJson() => {
        'conversation_id': conversationId,
        'delivered_upto_seq': deliveredUptoSeq,
        'read_upto_seq': readUptoSeq,
      };

  factory ReceiptUpTo.fromJson(Map<String, dynamic> json) {
    return ReceiptUpTo(
      conversationId: json['conversation_id'] as String,
      deliveredUptoSeq: json['delivered_upto_seq'] as int? ?? 0,
      readUptoSeq: json['read_upto_seq'] as int? ?? 0,
    );
  }
}

class ReceiptUpdate {
  final String conversationId;
  final String userId;
  final int deliveredUptoSeq;
  final int readUptoSeq;

  const ReceiptUpdate({
    required this.conversationId,
    required this.userId,
    required this.deliveredUptoSeq,
    required this.readUptoSeq,
  });

  Map<String, dynamic> toJson() => {
        'conversation_id': conversationId,
        'user_id': userId,
        'delivered_upto_seq': deliveredUptoSeq,
        'read_upto_seq': readUptoSeq,
      };

  factory ReceiptUpdate.fromJson(Map<String, dynamic> json) {
    return ReceiptUpdate(
      conversationId: json['conversation_id'] as String,
      userId: json['user_id'] as String,
      deliveredUptoSeq: json['delivered_upto_seq'] as int? ?? 0,
      readUptoSeq: json['read_upto_seq'] as int? ?? 0,
    );
  }
}
