import 'package:stealth_db/stealth_db.dart';
import 'package:stealth_protocol/stealth_protocol.dart';
import 'package:stealth_ui_kit/stealth_ui_kit.dart';

class MessageViewModel {
  final String id;
  final String conversationId;
  final String senderId;
  final bool isOutgoing;
  final MessageBody body;
  final BubblePosition position;
  final String timestampText;
  final MessageTickStatus? status;
  final String? replyToId;

  const MessageViewModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.isOutgoing,
    required this.body,
    required this.position,
    required this.timestampText,
    this.status,
    this.replyToId,
  });

  static List<MessageViewModel> buildViewModels({
    required List<Message> messages,
    required String currentUserId,
    Conversation? conversation,
  }) {
    if (messages.isEmpty) return const [];

    final result = <MessageViewModel>[];

    // Messages are ordered descending (index 0 is newest)
    for (int i = 0; i < messages.length; i++) {
      final current = messages[i];
      final isMe = current.senderId == currentUserId;

      final prev = i > 0 ? messages[i - 1] : null;
      final next = i < messages.length - 1 ? messages[i + 1] : null;

      final isPrevSameSender = prev != null && prev.senderId == current.senderId;
      final isNextSameSender = next != null && next.senderId == current.senderId;

      // In descending list: next message is chronologically BEFORE current; prev message is AFTER current.
      BubblePosition position;
      if (!isPrevSameSender && !isNextSameSender) {
        position = BubblePosition.single;
      } else if (!isNextSameSender && isPrevSameSender) {
        // Oldest in cluster
        position = BubblePosition.first;
      } else if (isNextSameSender && isPrevSameSender) {
        position = BubblePosition.middle;
      } else {
        // Newest in cluster
        position = BubblePosition.last;
      }

      // Status ticks calculation from peer cursors
      MessageTickStatus? tickStatus;
      if (isMe) {
        if (current.state == 'pending' || current.seq == null) {
          tickStatus = MessageTickStatus.pending;
        } else {
          final seq = current.seq!;
          final peerRead = conversation?.peerReadSeq ?? BigInt.zero;
          final peerDelivered = conversation?.peerDeliveredSeq ?? BigInt.zero;

          if (seq <= peerRead) {
            tickStatus = MessageTickStatus.read;
          } else if (seq <= peerDelivered) {
            tickStatus = MessageTickStatus.delivered;
          } else {
            tickStatus = MessageTickStatus.sent;
          }
        }
      }

      final ts = current.serverTs ?? current.createdLocalAt;
      final hour = ts.hour % 12 == 0 ? 12 : ts.hour % 12;
      final minute = ts.minute.toString().padLeft(2, '0');
      final amPm = ts.hour >= 12 ? 'PM' : 'AM';
      final formattedTime = '$hour:$minute $amPm';

      final body = MessageBody.fromBytes(current.payload);

      result.add(
        MessageViewModel(
          id: current.id,
          conversationId: current.conversationId,
          senderId: current.senderId,
          isOutgoing: isMe,
          body: body,
          position: position,
          timestampText: formattedTime,
          status: tickStatus,
          replyToId: current.replyToId,
        ),
      );
    }

    return result;
  }
}
