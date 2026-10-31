import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stealth_db/stealth_db.dart';
import 'package:stealth_ui_kit/stealth_ui_kit.dart';
import '../../../core/providers.dart';
import '../../auth/domain/auth_models.dart';
import '../../auth/presentation/controllers/auth_controller.dart';
import '../../chat/presentation/chat_screen.dart';

class NewChatScreen extends ConsumerStatefulWidget {
  const NewChatScreen({super.key});

  @override
  ConsumerState<NewChatScreen> createState() => _NewChatScreenState();
}

class _NewChatScreenState extends ConsumerState<NewChatScreen> {
  final _searchController = TextEditingController();
  List<UserSearchItem> _searchResults = [];
  bool _isSearching = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _performSearch('');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    final authState = ref.read(authControllerProvider);
    final token = authState.session?.accessToken ?? 'dev_token';

    setState(() {
      _isSearching = true;
      _errorMessage = null;
    });

    try {
      final service = ref.read(authServiceProvider);
      final results = await service.searchUsers(query: query, token: token);
      final myId = authState.session?.userId;
      if (mounted) {
        setState(() {
          _searchResults = results
              .where((u) => u.id != myId && u.username.isNotEmpty)
              .toList();
          _isSearching = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSearching = false;
          _errorMessage = 'Could not load users: $e';
        });
      }
    }
  }

  Future<void> _startChatWithUser(UserSearchItem peer) async {
    final db = ref.read(databaseProvider);
    final authState = ref.read(authControllerProvider);
    final token = authState.session?.accessToken ?? 'dev_token';
    final service = ref.read(authServiceProvider);

    String convId = 'conv_${peer.id.replaceAll('-', '').substring(0, 12)}';

    try {
      final res = await service.createConversation(
        peerId: peer.id,
        token: token,
      );
      if (res['id'] != null) {
        convId = res['id'] as String;
      }
    } catch (_) {}

    await db.upsertConversation(
      id: convId,
      title: peer.displayName.isNotEmpty ? peer.displayName : peer.username,
      lastSeq: 0,
      lastMessagePreview: 'Encrypted channel initialized.',
      lastMessageAt: DateTime.now(),
      unreadCount: 0,
    );

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ChatScreen(
          conversationId: convId,
          title: peer.displayName.isNotEmpty ? peer.displayName : peer.username,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = ref.watch(accentColorProvider);

    return Scaffold(
      backgroundColor: StealthColors.background,
      appBar: AppBar(
        title: const Text('Start New Secure Chat'),
        backgroundColor: StealthColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Search Input Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: StealthColors.surface,
            child: Container(
              decoration: BoxDecoration(
                color: StealthColors.surfaceLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: StealthColors.border, width: 0.8),
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white, fontSize: 14.5),
                onChanged: (val) => _performSearch(val.trim()),
                decoration: InputDecoration(
                  hintText: 'Search username or codename...',
                  hintStyle: const TextStyle(color: StealthColors.textMuted),
                  prefixIcon: const Icon(Icons.search_rounded,
                      color: StealthColors.textSecondary),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            _performSearch('');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
          ),

          // User List
          Expanded(
            child: _isSearching
                ? const Center(child: CircularProgressIndicator())
                : _searchResults.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person_search_rounded,
                                size: 48, color: StealthColors.textMuted),
                            const SizedBox(height: 12),
                            Text(
                              _errorMessage ?? 'No registered operators found',
                              style: const TextStyle(
                                  color: StealthColors.textSecondary),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        itemCount: _searchResults.length,
                        separatorBuilder: (context, index) => const Divider(
                          indent: 72,
                          endIndent: 16,
                          height: 1,
                          color: StealthColors.border,
                        ),
                        itemBuilder: (context, index) {
                          final user = _searchResults[index];
                          return ListTile(
                            leading: StealthAvatar(
                              name: user.displayName.isNotEmpty
                                  ? user.displayName
                                  : user.username,
                              size: 46,
                              isOnline: true,
                            ),
                            title: Text(
                              user.displayName.isNotEmpty
                                  ? user.displayName
                                  : user.username,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 15.5,
                              ),
                            ),
                            subtitle: Text(
                              '@${user.username} ${user.about.isNotEmpty ? "· ${user.about}" : ""}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: StealthColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: accentColor.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.send_rounded,
                                  color: accentColor, size: 18),
                            ),
                            onTap: () => _startChatWithUser(user),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
