import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stealth_db/stealth_db.dart';
import 'package:stealth_protocol/stealth_protocol.dart';
import 'package:stealth_ui_kit/stealth_ui_kit.dart';

import '../../../core/providers.dart';
import '../../chat/presentation/chat_screen.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _queryController = TextEditingController();
  List<Message> _results = [];
  bool _isSearching = false;

  void _onSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      setState(() {
        _results = [];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);
    final db = ref.read(databaseProvider);
    final matches = await db.searchMessages(trimmed);
    if (mounted) {
      setState(() {
        _results = matches;
        _isSearching = false;
      });
    }
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = StealthTheme.of(context);

    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: _queryController,
          autofocus: true,
          style: TextStyle(color: theme.textPrimary, fontSize: 16),
          decoration: InputDecoration(
            hintText: 'Search messages (FTS5 SQLite)...',
            hintStyle: TextStyle(color: theme.textMuted),
            border: InputBorder.none,
          ),
          onChanged: _onSearch,
        ),
        actions: [
          if (_queryController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _queryController.clear();
                _onSearch('');
              },
            ),
        ],
      ),
      body: _isSearching
          ? const Center(child: CircularProgressIndicator())
          : _results.isEmpty && _queryController.text.isNotEmpty
              ? Center(
                  child: Text(
                    'No messages matching "${_queryController.text}"',
                    style: TextStyle(color: theme.textMuted),
                  ),
                )
              : ListView.separated(
                  itemCount: _results.length,
                  separatorBuilder: (_, __) => Divider(
                    color: theme.divider,
                    indent: 16,
                    endIndent: 16,
                  ),
                  itemBuilder: (context, index) {
                    final msg = _results[index];
                    final body = MessageBody.fromBytes(msg.payload);

                    return ListTile(
                      title: Text(
                        body.text,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: theme.textPrimary,
                        ),
                      ),
                      subtitle: Text(
                        'Conversation: ${msg.conversationId}',
                        style:
                            TextStyle(fontSize: 12, color: theme.textSecondary),
                      ),
                      trailing: Text(
                        msg.createdLocalAt
                            .toLocal()
                            .toString()
                            .substring(11, 16),
                        style: TextStyle(fontSize: 11, color: theme.textMuted),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ChatScreen(
                              conversationId: msg.conversationId,
                              title: 'Chat ${msg.conversationId}',
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
