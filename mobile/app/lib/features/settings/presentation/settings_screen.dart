import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stealth_ui_kit/stealth_ui_kit.dart';
import '../../../../core/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentAccent = ref.watch(accentColorProvider);
    final isScreenProtected = ref.watch(screenProtectionProvider);
    final isBiometricEnabled = ref.watch(biometricLockProvider);

    final accents = [
      {'name': 'Electric Blue', 'color': StealthColors.accentElectricBlue},
      {'name': 'Emerald', 'color': StealthColors.accentEmerald},
      {'name': 'Purple', 'color': StealthColors.accentPurple},
      {'name': 'Amber', 'color': StealthColors.accentAmber},
      {'name': 'Crimson', 'color': StealthColors.accentCrimson},
    ];

    return Scaffold(
      backgroundColor: StealthColors.background,
      appBar: AppBar(
        title: const Text('Stealth Settings'),
        backgroundColor: StealthColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: [
          // Section: Appearance & Customization
          const Text(
            'APPEARANCE & ACCENT',
            style: TextStyle(
              color: StealthColors.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: StealthColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: StealthColors.border, width: 0.8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Theme Accent Color',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: accents.map((item) {
                    final color = item['color'] as Color;
                    final isSelected = currentAccent == color;
                    return GestureDetector(
                      onTap: () {
                        ref.read(accentColorProvider.notifier).state = color;
                      },
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? Colors.white : Colors.transparent,
                            width: 2.5,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: color.withValues(alpha: 0.4),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : null,
                        ),
                        child: isSelected
                            ? const Icon(Icons.check_rounded, color: Colors.white, size: 22)
                            : null,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // Section: Privacy & Security
          const Text(
            'PRIVACY & STEALTH CONTROLS',
            style: TextStyle(
              color: StealthColors.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 12),
          Material(
            color: StealthColors.surface,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: StealthColors.border, width: 0.8),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text(
                      'Screen Protection (FLAG_SECURE)',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    subtitle: const Text(
                      'Block screenshots and hide screen preview in Android recent tasks.',
                      style: TextStyle(color: StealthColors.textSecondary, fontSize: 12),
                    ),
                    value: isScreenProtected,
                    activeTrackColor: currentAccent,
                    onChanged: (val) {
                      ref.read(screenProtectionProvider.notifier).state = val;
                    },
                  ),
                  const Divider(height: 1, color: StealthColors.border),
                  SwitchListTile(
                    title: const Text(
                      'Biometric App Lock',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    subtitle: const Text(
                      'Require fingerprint or face unlock upon app opening.',
                      style: TextStyle(color: StealthColors.textSecondary, fontSize: 12),
                    ),
                    value: isBiometricEnabled,
                    activeTrackColor: currentAccent,
                    onChanged: (val) {
                      ref.read(biometricLockProvider.notifier).state = val;
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 28),

          // Section: Protocol & Gateway
          const Text(
            'REALTIME PROTOCOL & SYNC',
            style: TextStyle(
              color: StealthColors.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: StealthColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: StealthColors.border, width: 0.8),
            ),
            child: Column(
              children: [
                _buildInfoRow('Wire Protocol', 'Binary Protobuf v1 (WSS)'),
                const Divider(height: 16, color: StealthColors.border),
                _buildInfoRow('Local Database', 'Drift (SQLite3 Multiple Ciphers)'),
                const Divider(height: 16, color: StealthColors.border),
                _buildInfoRow('Receipts Engine', 'Monotonic Cursors (Seq-based)'),
                const Divider(height: 16, color: StealthColors.border),
                _buildInfoRow('Target SDK', 'Android 16 (API 36 Edge-to-Edge)'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: StealthColors.textSecondary, fontSize: 13.5)),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 13.5,
          ),
        ),
      ],
    );
  }
}
