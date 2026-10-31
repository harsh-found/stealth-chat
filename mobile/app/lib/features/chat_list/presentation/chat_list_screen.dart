import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stealth_ui_kit/stealth_ui_kit.dart';
import '../../../../core/providers.dart';
import '../../chat/presentation/chat_screen.dart';
import '../../search/presentation/search_screen.dart';
import '../../settings/presentation/settings_screen.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accentColor = ref.watch(accentColorProvider);
    final isScreenProtected = ref.watch(screenProtectionProvider);
    final conversationsAsync = ref.watch(conversationsListStreamProvider);

    return Scaffold(
      backgroundColor: StealthColors.background,
      appBar: AppBar(
        backgroundColor: StealthColors.surface,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.shield_rounded, color: accentColor, size: 20),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Signal',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'Stealth Chat',
                  style: TextStyle(
                    fontSize: 11,
                    color: StealthColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, size: 22),
            tooltip: 'Search messages (FTS5 SQLite)',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(
              isScreenProtected ? Icons.lock_rounded : Icons.lock_open_rounded,
              color:
                  isScreenProtected ? accentColor : StealthColors.textSecondary,
              size: 22,
            ),
            tooltip: 'Toggle Screen Protection (FLAG_SECURE)',
            onPressed: () {
              ref.read(screenProtectionProvider.notifier).state =
                  !isScreenProtected;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isScreenProtected
                        ? 'Screen Protection disabled'
                        : 'Screen Protection enabled (screenshots blocked)',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, size: 22),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: conversationsAsync.when(
        data: (conversations) {
          if (conversations.isEmpty) {
            return Center(
              child: Text(
                'No conversations yet',
                style: TextStyle(color: StealthColors.textMuted),
              ),
            );
          }
          return ListView.separated(
            itemCount: conversations.length,
            separatorBuilder: (context, index) => const Divider(
              indent: 74,
              endIndent: 16,
              height: 1,
              color: StealthColors.border,
            ),
            itemBuilder: (context, index) {
              final item = conversations[index];
              return ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                leading: StealthAvatar(
                  name: item.title,
                  size: 50,
                  isOnline: item.isOnline,
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      item.timestamp,
                      style: const TextStyle(
                        color: StealthColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: StealthColors.textSecondary,
                            fontSize: 13.5,
                          ),
                        ),
                      ),
                      if (item.unreadCount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: accentColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            item.unreadCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(
                        conversationId: item.id,
                        title: item.title,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Error: $err',
              style: const TextStyle(color: Colors.redAccent)),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: accentColor,
        child:
            const Icon(Icons.chat_bubble_outline_rounded, color: Colors.white),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const ChatScreen(
                conversationId: 'conv-new',
                title: 'New Secure Chat',
              ),
            ),
          );
        },
      ),
    );
  }
}
