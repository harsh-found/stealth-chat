import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stealth_ui_kit/stealth_ui_kit.dart';
import 'package:stealth_protocol/stealth_protocol.dart';
import '../../../../core/providers.dart';
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
  final Map<String, bool> _playingAudio = {};
  final Map<String, double> _audioProgress = {};

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
    final uiState = ref.watch(chatControllerProvider(widget.conversationId));
    final chatController =
        ref.read(chatControllerProvider(widget.conversationId).notifier);
    final accentColor = ref.watch(accentColorProvider);
    final messagesAsync =
        ref.watch(chatMessagesStreamProvider(widget.conversationId));

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
            StealthAvatar(name: widget.title, size: 38, isOnline: true),
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
                    uiState.isPeerTyping
                        ? 'typing...'
                        : 'online · E2E encrypted',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: uiState.isPeerTyping
                          ? accentColor
                          : StealthColors.textSecondary,
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
                const SnackBar(
                    content: Text('WebRTC 1:1 call subsystem ready')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, size: 22),
            onPressed: () {},
          ),
        ],
      ),
      body: ZeroFlickerKeyboardTray(
        isTrayOpen: uiState.isTrayOpen,
        trayContent: _buildEmojiTray(accentColor),
        child: Column(
          children: [
            // Message Stream from Drift SQLite
            Expanded(
              child: messagesAsync.when(
                data: (messages) {
                  return ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isPlaying = _playingAudio[message.id] ?? false;
                      final progress = _audioProgress[message.id] ?? 0.0;

                      Widget? mediaWidget;
                      if (message.kind == MessageKind.voice) {
                        mediaWidget = WaveformScrubber(
                          waveform: message.waveform ?? [],
                          isPlaying: isPlaying,
                          progress: progress,
                          durationText: '0:03',
                          isOutgoing: message.isMe,
                          onPlayPause: () {
                            setState(() {
                              _playingAudio[message.id] = !isPlaying;
                              if (!isPlaying && progress >= 1.0) {
                                _audioProgress[message.id] = 0.0;
                              }
                            });
                          },
                          onSeek: (seekPos) {
                            setState(() {
                              _audioProgress[message.id] = seekPos;
                            });
                          },
                        );
                      }

                      return SwipeToReply(
                        key: ValueKey(message.id),
                        onReply: () => chatController.setReply(message),
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
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(
                  child: Text('Error loading messages: $err',
                      style: const TextStyle(color: Colors.redAccent)),
                ),
              ),
            ),

            // Input Bar with Zero-Flicker Layout and voice recorder
            ChatInputBar(
              controller: _inputController,
              replyingTo: uiState.replyingTo,
              accentColor: accentColor,
              isTrayOpen: uiState.isTrayOpen,
              isRecording: uiState.isRecording,
              recordingAmplitudes: uiState.liveAmplitudes,
              onCancelReply: () => chatController.setReply(null),
              onSend: (text) => chatController.sendMessage(text),
              onToggleTray: () {
                FocusScope.of(context).unfocus();
                chatController.toggleTray();
              },
              onStartVoiceRecording: () => chatController.startVoiceRecording(),
              onStopVoiceRecording: () =>
                  chatController.stopAndSendVoiceRecording(),
              onCancelVoiceRecording: () =>
                  chatController.cancelVoiceRecording(),
              onTypingChanged: (isTyping) =>
                  chatController.handleTypingChanged(isTyping),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmojiTray(Color accentColor) {
    const emojis = ['⚡', '🔒', '🔥', '🛡️', '👍', '❤️', '👏', '🚀', '🎯', '💯'];
    return Container(
      color: StealthColors.surfaceLight,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Quick Reactions & Attachments',
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 18, color: Colors.white54),
                onPressed: () => ref
                    .read(
                        chatControllerProvider(widget.conversationId).notifier)
                    .setTrayOpen(false),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: emojis.map((emoji) {
              return InkWell(
                onTap: () {
                  ref
                      .read(chatControllerProvider(widget.conversationId)
                          .notifier)
                      .sendMessage(emoji);
                  ref
                      .read(chatControllerProvider(widget.conversationId)
                          .notifier)
                      .setTrayOpen(false);
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: StealthColors.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(emoji, style: const TextStyle(fontSize: 22)),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
