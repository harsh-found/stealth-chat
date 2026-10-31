import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stealth_db/stealth_db.dart';
import 'package:stealth_protocol/stealth_protocol.dart';
import 'package:stealth_sync/stealth_sync.dart';
import 'package:stealth_ui_kit/stealth_ui_kit.dart';

/// Database provider (in memory for testing/dev or native isolate)
final databaseProvider = Provider<StealthDatabase>((ref) {
  final db = StealthDatabase(NativeDatabase.memory());
  ref.onDispose(() => db.close());
  return db;
});

/// Current accent state notifier
class SelectedAccentNotifier extends StateNotifier<StealthAccent> {
  SelectedAccentNotifier() : super(StealthAccent.electricBlue);

  void setAccent(StealthAccent accent) {
    state = accent;
  }
}

final selectedAccentProvider =
    StateNotifierProvider<SelectedAccentNotifier, StealthAccent>((ref) {
  return SelectedAccentNotifier();
});

final stealthThemeProvider = Provider<StealthThemeData>((ref) {
  final accent = ref.watch(selectedAccentProvider);
  return StealthThemeData(accent: accent);
});

/// Current user ID for the session
final currentUserIdProvider = Provider<String>((ref) => 'user_me');

/// Sync client provider
final syncClientProvider = Provider<StealthSyncClient>((ref) {
  final db = ref.watch(databaseProvider);
  final client = StealthSyncClient(
    gatewayUri: Uri.parse('ws://127.0.0.1:4001/ws'),
    accessToken: 'dev_token',
    deviceId: 'device_android_1',
    outboxStorage: db,
  );

  // Wire sync events into database
  final sub = client.events.listen((event) async {
    if (event is SyncMessageAcked) {
      await db.handleAck(
        messageId: event.messageId,
        seq: event.seq,
        serverTsMs: event.serverTsMs,
      );
    } else if (event is SyncMessageReceived) {
      final body = MessageBody.fromBytes(event.message.payload);
      await db.insertIncomingMessage(
        event.message,
        previewText: body.text,
      );
    } else if (event is SyncReceiptUpdateReceived) {
      await db.updatePeerReceipt(
        conversationId: event.update.conversationId,
        deliveredUptoSeq: event.update.deliveredUptoSeq,
        readUptoSeq: event.update.readUptoSeq,
      );
    }
  });

  ref.onDispose(() {
    sub.cancel();
    client.dispose();
  });

  return client;
});

/// Stream of conversations
final conversationsStreamProvider = StreamProvider<List<Conversation>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchConversations();
});

/// Stream of messages for an active conversation
final conversationMessagesStreamProvider =
    StreamProvider.family<List<Message>, String>((ref, conversationId) {
  final db = ref.watch(databaseProvider);
  return db.watchMessagesPaged(conversationId);
});

/// Stream of conversation metadata
final conversationMetaProvider =
    StreamProvider.family<Conversation?, String>((ref, conversationId) {
  final db = ref.watch(databaseProvider);
  return db.watchConversation(conversationId);
});
