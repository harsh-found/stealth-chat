import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stealth_app/app/app.dart';
import 'package:stealth_app/features/chat/presentation/chat_screen.dart';
import 'package:stealth_app/features/chat_list/presentation/chat_list_screen.dart';
import 'package:stealth_ui_kit/stealth_ui_kit.dart';

void main() {
  testWidgets('Stealth Chat App boots to chat list with Signal branding and opens chat',
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
    await tester.enterText(find.byType(TextField), 'Test message from DeepCoder 2');
    await tester.pumpAndSettle();

    // Tap send button (Icons.send_rounded)
    await tester.tap(find.byIcon(Icons.send_rounded));
    await tester.pumpAndSettle();

    // Verify message appears in the list
    expect(find.text('Test message from DeepCoder 2'), findsOneWidget);

    // Elapse pending mock simulation timers
    await tester.pump(const Duration(seconds: 2));
  });
}
