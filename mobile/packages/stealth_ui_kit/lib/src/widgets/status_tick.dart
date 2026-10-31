import 'package:flutter/material.dart';
import '../status_ticks.dart';

class StatusTick extends StatelessWidget {
  final MessageDeliveryStatus status;
  final double size;

  const StatusTick({
    super.key,
    required this.status,
    this.size = 14.0,
  });

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case MessageDeliveryStatus.pending:
        return Icon(
          Icons.access_time_rounded,
          size: size - 2,
          color: Colors.white54,
        );
      case MessageDeliveryStatus.sent:
        return Icon(
          Icons.check_rounded,
          size: size,
          color: Colors.white70,
        );
      case MessageDeliveryStatus.delivered:
        return Icon(
          Icons.done_all_rounded,
          size: size,
          color: Colors.white70,
        );
      case MessageDeliveryStatus.read:
        return Icon(
          Icons.done_all_rounded,
          size: size,
          color: const Color(0xFF38BDF8), // Electric cyan/blue tick for read
        );
    }
  }
}
