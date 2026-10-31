import 'chat_models.dart';

abstract class ChatRepository {
  Stream<List<ConversationSummaryItem>> watchConversations();
  Stream<List<ChatMessageItem>> watchMessages(String conversationId);
  Stream<ConversationSummaryItem?> watchConversation(String conversationId);

  Future<ChatMessageItem> sendTextMessage({
    required String conversationId,
    required String text,
    ChatMessageItem? replyingTo,
  });

  Future<ChatMessageItem> sendVoiceMessage({
    required String conversationId,
    required List<int> waveform,
    required int durationMs,
    ChatMessageItem? replyingTo,
  });

  void sendTyping({required String conversationId, required bool isTyping});

  void markRead({required String conversationId, required int seq});

  Future<void> syncRemoteConversations();
}
