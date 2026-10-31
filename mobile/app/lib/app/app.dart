import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stealth_ui_kit/stealth_ui_kit.dart';

import '../core/providers.dart';
import '../features/chat_list/presentation/chat_list_screen.dart';

class StealthChatApp extends ConsumerWidget {
  const StealthChatApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeData = ref.watch(stealthThemeProvider);

    return StealthTheme(
      data: themeData,
      child: MaterialApp(
        title: 'Stealth Chat',
        debugShowCheckedModeBanner: false,
        theme: themeData.toFlutterTheme(),
        home: const ChatListScreen(),
      ),
    );
  }
}
