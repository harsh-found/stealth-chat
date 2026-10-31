import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme_provider.dart';
import 'features/chat_list/presentation/chat_list_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: StealthApp(),
    ),
  );
}

class StealthApp extends ConsumerWidget {
  const StealthApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Signal Stealth Chat',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const ChatListScreen(),
    );
  }
}
