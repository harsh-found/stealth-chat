import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers.dart';
import '../../domain/chat_models.dart';
import '../../domain/chat_repository.dart';

class ChatUIState {
  final ChatMessageItem? replyingTo;
  final bool isPeerTyping;
  final bool isTrayOpen;
  final bool isRecording;
  final List<int> liveAmplitudes;

  const ChatUIState({
    this.replyingTo,
    this.isPeerTyping = false,
    this.isTrayOpen = false,
    this.isRecording = false,
    this.liveAmplitudes = const [],
  });

  ChatUIState copyWith({
    ChatMessageItem? replyingTo,
    bool clearReply = false,
    bool? isPeerTyping,
    bool? isTrayOpen,
    bool? isRecording,
    List<int>? liveAmplitudes,
  }) {
    return ChatUIState(
      replyingTo: clearReply ? null : (replyingTo ?? this.replyingTo),
      isPeerTyping: isPeerTyping ?? this.isPeerTyping,
      isTrayOpen: isTrayOpen ?? this.isTrayOpen,
      isRecording: isRecording ?? this.isRecording,
      liveAmplitudes: liveAmplitudes ?? this.liveAmplitudes,
    );
  }
}

class ChatController extends StateNotifier<ChatUIState> {
  final String conversationId;
  final ChatRepository _repository;
  Timer? _recordingTimer;

  ChatController({
    required this.conversationId,
    required ChatRepository repository,
  })  : _repository = repository,
        super(const ChatUIState());

  void setReply(ChatMessageItem? message) {
    state = state.copyWith(replyingTo: message, clearReply: message == null);
  }

  void toggleTray() {
    state = state.copyWith(isTrayOpen: !state.isTrayOpen);
  }

  void setTrayOpen(bool open) {
    state = state.copyWith(isTrayOpen: open);
  }

  void setPeerTyping(bool isTyping) {
    state = state.copyWith(isPeerTyping: isTyping);
  }

  void handleTypingChanged(bool isTyping) {
    _repository.sendTyping(conversationId: conversationId, isTyping: isTyping);
  }

  Future<void> sendMessage(String text) async {
    final reply = state.replyingTo;
    state = state.copyWith(clearReply: true);
    await _repository.sendTextMessage(
      conversationId: conversationId,
      text: text,
      replyingTo: reply,
    );
  }

  void startVoiceRecording() {
    _recordingTimer?.cancel();
    final samples = <int>[20, 35, 50];
    state = state.copyWith(
      isRecording: true,
      liveAmplitudes: samples,
    );

    int tick = 0;
    _recordingTimer =
        Timer.periodic(const Duration(milliseconds: 150), (timer) {
      tick++;
      final baseAmp = 25 + ((tick * 13) % 70);
      final newSamples = List<int>.from(state.liveAmplitudes)..add(baseAmp);
      if (newSamples.length > 32) newSamples.removeAt(0);
      state = state.copyWith(liveAmplitudes: newSamples);
    });
  }

  void cancelVoiceRecording() {
    _recordingTimer?.cancel();
    _recordingTimer = null;
    state = state.copyWith(isRecording: false, liveAmplitudes: []);
  }

  Future<void> stopAndSendVoiceRecording() async {
    _recordingTimer?.cancel();
    _recordingTimer = null;
    final waveform = List<int>.from(state.liveAmplitudes);
    state = state.copyWith(isRecording: false, liveAmplitudes: []);

    final finalWaveform = waveform.isNotEmpty
        ? waveform
        : [25, 45, 80, 60, 90, 75, 40, 55, 70, 30];

    await _repository.sendVoiceMessage(
      conversationId: conversationId,
      waveform: finalWaveform,
      durationMs: 3200,
      replyingTo: state.replyingTo,
    );
  }

  @override
  void dispose() {
    _recordingTimer?.cancel();
    super.dispose();
  }
}

final chatControllerProvider =
    StateNotifierProvider.family<ChatController, ChatUIState, String>(
        (ref, conversationId) {
  final repo = ref.watch(chatRepositoryProvider);
  return ChatController(
    conversationId: conversationId,
    repository: repo,
  );
});
