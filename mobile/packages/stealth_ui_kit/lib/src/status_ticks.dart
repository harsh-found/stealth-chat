import 'package:flutter/material.dart';
import 'theme.dart';

enum MessageDeliveryStatus {
  pending,
  sent,
  delivered,
  read,
}

typedef MessageTickStatus = MessageDeliveryStatus;

class MessageStatusTicks extends StatelessWidget {
  final MessageDeliveryStatus status;
  final double size;

  const MessageStatusTicks({
    super.key,
    required this.status,
    this.size = 14,
  });

  @override
  Widget build(BuildContext context) {
    final theme = StealthTheme.of(context);

    switch (status) {
      case MessageDeliveryStatus.pending:
        return Icon(
          Icons.access_time_rounded,
          size: size,
          color: theme.textMuted,
        );
      case MessageDeliveryStatus.sent:
        return Icon(
          Icons.check_rounded,
          size: size,
          color: theme.textSecondary,
        );
      case MessageDeliveryStatus.delivered:
        return Icon(
          Icons.done_all_rounded,
          size: size,
          color: theme.textSecondary,
        );
      case MessageDeliveryStatus.read:
        return Icon(
          Icons.done_all_rounded,
          size: size,
          color: theme.accent.lightColor,
        );
    }
  }
}
