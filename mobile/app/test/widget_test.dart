import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stealth_app/app/app.dart';
import 'package:stealth_app/features/chat/presentation/chat_screen.dart';
import 'package:stealth_app/features/chat_list/presentation/chat_list_screen.dart';
import 'package:stealth_app/features/search/presentation/search_screen.dart';
import 'package:stealth_ui_kit/stealth_ui_kit.dart';

void main() {
  testWidgets(
      'Stealth Chat App boots to chat list with Signal branding and opens chat',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: StealthChatApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify Signal branding and ChatListScreen
    expect(find.byType(ChatListScreen), findsOneWidget);
    expect(find.text('Signal'), findsOneWidget);
    expect(find.text('Harsh (Lead)'), findsOneWidget);
    expect(find.text('Stealth Gateway Alpha'), findsOneWidget);

    // Tap on the first conversation to open ChatScreen
    await tester.tap(find.text('Harsh (Lead)'));
    await tester.pumpAndSettle();

    // Verify ChatScreen loaded
    expect(find.byType(ChatScreen), findsOneWidget);
    expect(find.text('Harsh (Lead)'), findsOneWidget);

    // Verify messages and Stealth UI Kit widgets
    expect(find.byType(GroupedBubble), findsWidgets);
    expect(find.byType(TextField), findsOneWidget);

    // Send a message
    await tester.enterText(
        find.byType(TextField), 'Test message from DeepCoder 2');
    await tester.pumpAndSettle();

    // Tap send button (Icons.send_rounded)
    await tester.tap(find.byIcon(Icons.send_rounded));
    await tester.pumpAndSettle();

    // Verify message appears in the list
    expect(find.text('Test message from DeepCoder 2'), findsOneWidget);

    // Cleanly unmount widget tree and flush Drift stream disposal timers
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 200));
  });

  testWidgets('ChatScreen supports voice notes recording and zero-flicker tray',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: StealthChatApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Harsh (Lead)'));
    await tester.pumpAndSettle();

    // Toggle emoji tray
    await tester.tap(find.byIcon(Icons.emoji_emotions_outlined));
    await tester.pumpAndSettle();

    // Verify quick reaction emojis rendered in tray
    expect(find.text('Quick Reactions & Attachments'), findsOneWidget);
    expect(find.text('⚡'), findsOneWidget);

    // Tap emoji to send directly from tray
    await tester.tap(find.text('⚡'));
    await tester.pumpAndSettle();

    // Verify sent emoji appears
    expect(find.text('⚡'), findsOneWidget);

    // Start voice recording by tapping mic
    await tester.tap(find.byIcon(Icons.mic_rounded));
    await tester.pump(const Duration(milliseconds: 300));

    // Verify recording bar is active
    expect(find.text('Recording...'), findsOneWidget);

    // Stop and send voice recording
    await tester.tap(find.byIcon(Icons.send_rounded));
    await tester.pumpAndSettle();

    // Verify voice note waveform scrubber rendered
    expect(find.byType(WaveformScrubber), findsWidgets);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 200));
  });

  testWidgets(
      'ChatListScreen search button opens SearchScreen with FTS5 search',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: StealthChatApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Tap search button in app bar
    await tester.tap(find.byIcon(Icons.search_rounded));
    await tester.pumpAndSettle();

    // Verify SearchScreen is shown
    expect(find.byType(SearchScreen), findsOneWidget);
    expect(find.text('Search messages (FTS5 SQLite)...'), findsOneWidget);

    // Search for indexed content
    await tester.enterText(find.byType(TextField), 'Protobuf');
    await tester.pumpAndSettle();

    // Verify FTS5 search found the message
    expect(find.textContaining('Protobuf'), findsWidgets);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 200));
  });
}
