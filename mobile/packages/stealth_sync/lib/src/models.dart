import 'dart:typed_data';
import 'package:stealth_protocol/stealth_protocol.dart';

/// Represents a message or operation waiting to be transmitted over the socket.
class OutboxItem {
  final String id;
  final String messageId;
  final String conversationId;
  final MessageKind kind;
  final Uint8List payload;
  final String? replyToId;
  final int clientTsMs;
  final int attempts;
  final DateTime? nextTryAt;

  const OutboxItem({
    required this.id,
    required this.messageId,
    required this.conversationId,
    this.kind = MessageKind.text,
    required this.payload,
    this.replyToId,
    required this.clientTsMs,
    this.attempts = 0,
    this.nextTryAt,
  });

  OutboxItem copyWith({
    int? attempts,
    DateTime? nextTryAt,
  }) {
    return OutboxItem(
      id: id,
      messageId: messageId,
      conversationId: conversationId,
      kind: kind,
      payload: payload,
      replyToId: replyToId,
      clientTsMs: clientTsMs,
      attempts: attempts ?? this.attempts,
      nextTryAt: nextTryAt ?? this.nextTryAt,
    );
  }

  SendMessage toSendMessage() {
    return SendMessage(
      messageId: messageId,
      conversationId: conversationId,
      kind: kind,
      payload: payload,
      replyToId: replyToId,
      clientTsMs: clientTsMs,
    );
  }
}

/// Events emitted by the sync engine.
sealed class SyncEvent {
  const SyncEvent();
}

class SyncConnected extends SyncEvent {
  final HelloOk helloOk;
  const SyncConnected(this.helloOk);
}

class SyncDisconnected extends SyncEvent {
  final Object? error;
  const SyncDisconnected([this.error]);
}

class SyncMessageReceived extends SyncEvent {
  final MessageNew message;
  const SyncMessageReceived(this.message);
}

class SyncMessageAcked extends SyncEvent {
  final String messageId;
  final int seq;
  final int serverTsMs;
  const SyncMessageAcked({
    required this.messageId,
    required this.seq,
    required this.serverTsMs,
  });
}

class SyncReceiptUpdateReceived extends SyncEvent {
  final ReceiptUpdate update;
  const SyncReceiptUpdateReceived(this.update);
}

class SyncBatchReceived extends SyncEvent {
  final SyncBatch batch;
  const SyncBatchReceived(this.batch);
}

class SyncPresenceReceived extends SyncEvent {
  final Presence presence;
  const SyncPresenceReceived(this.presence);
}

class SyncErrorReceived extends SyncEvent {
  final ProtocolError error;
  const SyncErrorReceived(this.error);
}

class SyncGapDetected extends SyncEvent {
  final String conversationId;
  final int localSeq;
  final int receivedSeq;
  const SyncGapDetected({
    required this.conversationId,
    required this.localSeq,
    required this.receivedSeq,
  });
}
