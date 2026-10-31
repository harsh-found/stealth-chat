import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stealth_ui_kit/stealth_ui_kit.dart';
import '../../../../core/api_config.dart';
import '../controllers/auth_controller.dart';

class ServerConfigTile extends ConsumerStatefulWidget {
  const ServerConfigTile({super.key});

  @override
  ConsumerState<ServerConfigTile> createState() => _ServerConfigTileState();
}

class _ServerConfigTileState extends ConsumerState<ServerConfigTile> {
  void _showEditDialog(BuildContext context, String currentUrl) {
    final controller = TextEditingController(text: currentUrl);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: StealthColors.surface,
        title: const Text(
          'Configure Backend Endpoint',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: const InputDecoration(
                labelText: 'HTTP(S) Endpoint',
                labelStyle: TextStyle(color: StealthColors.textSecondary),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildPresetButton(
                    'Render Cloud', ApiConfig.defaultHttpBaseUrl, controller),
                _buildPresetButton('Emulator (10.0.2.2)',
                    ApiConfig.devHttpBaseUrl, controller),
                _buildPresetButton(
                    'Localhost', 'http://localhost:3000', controller),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel',
                style: TextStyle(color: StealthColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              final newUrl = controller.text.trim();
              if (newUrl.isNotEmpty) {
                ref.read(authControllerProvider.notifier).setServerUrl(newUrl);
              }
              Navigator.of(ctx).pop();
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetButton(
      String label, String url, TextEditingController controller) {
    return ActionChip(
      label: Text(label, style: const TextStyle(fontSize: 11)),
      backgroundColor: StealthColors.surfaceLight,
      onPressed: () => controller.text = url,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUrl = ref.watch(serverUrlProvider);
    return Material(
      color: StealthColors.surface,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: StealthColors.border, width: 0.8),
        ),
        child: ListTile(
          dense: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          leading: const Icon(Icons.cloud_outlined,
              color: StealthColors.textSecondary, size: 20),
          title: const Text(
            'Server Endpoint',
            style: TextStyle(color: Colors.white, fontSize: 13),
          ),
          subtitle: Text(
            currentUrl,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: StealthColors.textSecondary, fontSize: 11),
          ),
          trailing: const Icon(Icons.edit_outlined,
              color: StealthColors.textSecondary, size: 18),
          onTap: () => _showEditDialog(context, currentUrl),
        ),
      ),
    );
  }
}
