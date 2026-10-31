import 'dart:io';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stealth_db/stealth_db.dart';
import 'package:stealth_protocol/stealth_protocol.dart';
import 'package:stealth_sync/stealth_sync.dart';
import 'package:stealth_ui_kit/stealth_ui_kit.dart';

import '../features/auth/presentation/controllers/auth_controller.dart';
import '../features/chat/data/chat_repository_impl.dart';
import '../features/chat/domain/chat_models.dart';
import '../features/chat/domain/chat_repository.dart';
import 'api_config.dart';
import 'seed_data.dart';

/// Database provider (in memory for testing/dev or native isolate)
final databaseProvider = Provider<StealthDatabase>((ref) {
  final db = StealthDatabase(NativeDatabase.memory());
  if (Platform.environment.containsKey('FLUTTER_TEST')) {
    seedInitialData(db);
  }
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

final accentColorProvider = StateProvider<Color>((ref) {
  final accent = ref.watch(selectedAccentProvider);
  return accent.color;
});

final stealthThemeProvider = Provider<StealthThemeData>((ref) {
  final accent = ref.watch(selectedAccentProvider);
  return StealthThemeData(accent: accent);
});

final themeProvider = Provider<ThemeData>((ref) {
  final themeData = ref.watch(stealthThemeProvider);
  return themeData.toFlutterTheme();
});

final screenProtectionProvider = StateProvider<bool>((ref) => false);
final biometricLockProvider = StateProvider<bool>((ref) => false);

/// Current user ID for the session
final currentUserIdProvider = Provider<String>((ref) {
  final authState = ref.watch(authControllerProvider);
  return authState.session?.userId ?? 'user_me';
});

/// Sync client provider
final syncClientProvider = Provider<StealthSyncClient>((ref) {
  final db = ref.watch(databaseProvider);
  final authState = ref.watch(authControllerProvider);
  final token = authState.session?.accessToken ?? 'dev_token';
  final deviceId = authState.session?.deviceId ?? 'device_android_1';
  final serverUrl = ref.watch(serverUrlProvider);
  final wsUrl = ApiConfig.httpToWs(serverUrl);

  final client = StealthSyncClient(
    gatewayUri: Uri.parse(wsUrl),
    accessToken: token,
    deviceId: deviceId,
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
    } else if (event is SyncBatchReceived) {
      for (final msg in event.batch.messages) {
        final body = MessageBody.fromBytes(msg.payload);
        await db.insertIncomingMessage(
          msg,
          previewText: body.text,
        );
      }
    } else if (event is SyncReceiptUpdateReceived) {
      await db.updatePeerReceipt(
        conversationId: event.update.conversationId,
        deliveredUptoSeq: event.update.deliveredUptoSeq,
        readUptoSeq: event.update.readUptoSeq,
      );
    } else if (event is SyncConnected) {
      for (final conv in event.helloOk.changedConversations) {
        final localSeq = client.getLastKnownSeq(conv.conversationId);
        if (conv.lastSeq > localSeq) {
          client.requestSync(
            conversationId: conv.conversationId,
            afterSeq: localSeq,
          );
        }
      }
    }
  });

  // Connect asynchronously
  client.connect();

  ref.onDispose(() {
    sub.cancel();
    client.dispose();
  });

  return client;
});

/// Repository provider connecting Drift SQLite and StealthSyncClient
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final client = ref.watch(syncClientProvider);
  final currentUserId = ref.watch(currentUserIdProvider);
  final authService = ref.watch(authServiceProvider);
  final authState = ref.watch(authControllerProvider);

  return ChatRepositoryImpl(
    database: db,
    syncClient: client,
    currentUserId: currentUserId,
    authService: authService,
    authToken: authState.session?.accessToken,
  );
});

/// Stream of conversation summaries from domain repository
final conversationsListStreamProvider =
    StreamProvider<List<ConversationSummaryItem>>((ref) {
  final repo = ref.watch(chatRepositoryProvider);
  return repo.watchConversations();
});

/// Stream of chat messages from domain repository
final chatMessagesStreamProvider =
    StreamProvider.family<List<ChatMessageItem>, String>((ref, conversationId) {
  final repo = ref.watch(chatRepositoryProvider);
  return repo.watchMessages(conversationId);
});

/// Stream of conversation item from domain repository
final conversationItemStreamProvider =
    StreamProvider.family<ConversationSummaryItem?, String>(
        (ref, conversationId) {
  final repo = ref.watch(chatRepositoryProvider);
  return repo.watchConversation(conversationId);
});

/// Legacy database-level streams for backward compatibility
final conversationsStreamProvider = StreamProvider<List<Conversation>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchConversations();
});

final conversationMessagesStreamProvider =
    StreamProvider.family<List<Message>, String>((ref, conversationId) {
  final db = ref.watch(databaseProvider);
  return db.watchMessagesPaged(conversationId);
});

final conversationMetaProvider =
    StreamProvider.family<Conversation?, String>((ref, conversationId) {
  final db = ref.watch(databaseProvider);
  return db.watchConversation(conversationId);
});
