import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stealth_ui_kit/stealth_ui_kit.dart';
import 'package:stealth_protocol/stealth_protocol.dart';
import '../../../../core/theme_provider.dart';
import 'controllers/chat_controller.dart';
import 'widgets/chat_input_bar.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String conversationId;
  final String title;

  const ChatScreen({
    super.key,
    required this.conversationId,
    this.title = 'Stealth Contact',
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _inputController = TextEditingController();

  String _formatTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatControllerProvider(widget.conversationId));
    final chatController = ref.read(chatControllerProvider(widget.conversationId).notifier);
    final accentColor = ref.watch(accentColorProvider);

    return Scaffold(
      backgroundColor: StealthColors.background,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: StealthColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            StealthAvatar(
              name: widget.title,
              size: 38,
              isOnline: true,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    chatState.isPeerTyping ? 'typing...' : 'online · E2E encrypted',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: chatState.isPeerTyping ? accentColor : StealthColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam_outlined, size: 24),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('WebRTC 1:1 call subsystem ready')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, size: 22),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Message Stream
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: chatState.messages.length,
              itemBuilder: (context, index) {
                final message = chatState.messages[index];

                Widget? mediaWidget;
                if (message.kind == MessageKind.voice && message.waveform != null) {
                  mediaWidget = Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Icon(Icons.play_circle_fill_rounded, color: Colors.white, size: 30),
                        const SizedBox(width: 8),
                        Expanded(
                          child: WaveformWidget(
                            amplitudes: message.waveform!,
                            progress: 0.35,
                            activeColor: Colors.white,
                            inactiveColor: Colors.white38,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return SwipeToReply(
                  key: ValueKey(message.id),
                  onReply: () {
                    chatController.setReply(message);
                  },
                  child: GroupedBubble(
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (mediaWidget != null) mediaWidget,
                        if (message.text.isNotEmpty)
                          Text(
                            message.text,
                            style: const TextStyle(
                              color: StealthColors.textPrimary,
                              fontSize: 15,
                              height: 1.3,
                            ),
                          ),
                      ],
                    ),
                    isOutgoing: message.isMe,
                    timestampText: _formatTime(message.createdAt),
                    status: message.isMe ? message.deliveryStatus : null,
                    replyAuthor: message.replyAuthor,
                    replyText: message.replyText,
                  ),
                );
              },
            ),
          ),

          // Input Bar with Zero-Flicker Layout
          ChatInputBar(
            controller: _inputController,
            replyingTo: chatState.replyingTo,
            accentColor: accentColor,
            onCancelReply: () => chatController.setReply(null),
            onSend: (text) => chatController.sendMessage(text),
            onSendVoice: () {
              // Generate sample waveform amplitudes
              final waveform = [15, 30, 60, 85, 40, 70, 95, 80, 50, 30, 45, 75, 90, 60, 40, 20];
              chatController.sendVoiceNote(waveform);
            },
          ),
        ],
      ),
    );
  }
}
