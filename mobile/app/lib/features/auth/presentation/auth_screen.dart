import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stealth_ui_kit/stealth_ui_kit.dart';
import '../../../core/providers.dart';
import 'controllers/auth_controller.dart';
import 'widgets/auth_header.dart';
import 'widgets/auth_text_field.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _displayNameController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  void _submit() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final displayName = _displayNameController.text.trim();
    final notifier = ref.read(authControllerProvider.notifier);
    final isLogin = ref.read(authControllerProvider).isLoginMode;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    if (isLogin) {
      notifier.login(username, password);
    } else {
      notifier.register(username, password, displayName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final accentColor = ref.watch(accentColorProvider);

    return Scaffold(
      backgroundColor: StealthColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AuthHeader(accentColor: accentColor),
                const SizedBox(height: 32),

                // Mode Selector Toggle (Sign In / Register)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: StealthColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: StealthColors.border, width: 0.8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (!authState.isLoginMode) {
                              ref
                                  .read(authControllerProvider.notifier)
                                  .toggleMode();
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: authState.isLoginMode
                                  ? accentColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: Center(
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: authState.isLoginMode
                                      ? Colors.white
                                      : StealthColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (authState.isLoginMode) {
                              ref
                                  .read(authControllerProvider.notifier)
                                  .toggleMode();
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: !authState.isLoginMode
                                  ? accentColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: Center(
                              child: Text(
                                'Register',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: !authState.isLoginMode
                                      ? Colors.white
                                      : StealthColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Error Card
                if (authState.errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color:
                          StealthColors.accentCrimson.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color:
                            StealthColors.accentCrimson.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline_rounded,
                            color: StealthColors.accentCrimson, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            authState.errorMessage!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Display Name Field (Register only)
                if (!authState.isLoginMode) ...[
                  AuthTextField(
                    controller: _displayNameController,
                    hintText: 'Display Name (e.g. Agent 007)',
                    icon: Icons.person_outline_rounded,
                  ),
                  const SizedBox(height: 14),
                ],

                // Username Field
                AuthTextField(
                  controller: _usernameController,
                  hintText: 'Username',
                  icon: Icons.alternate_email_rounded,
                ),
                const SizedBox(height: 14),

                // Password Field
                AuthTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  icon: Icons.lock_outline_rounded,
                  isPassword: true,
                  obscureText: _obscurePassword,
                  onToggleObscure: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),
                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: authState.isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: authState.isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            authState.isLoginMode
                                ? 'Sign In'
                                : 'Create Account',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),

                // Footer security note
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock_rounded,
                        size: 13, color: StealthColors.textMuted),
                    const SizedBox(width: 6),
                    const Text(
                      'PBKDF2-HMAC-SHA512 · Keystore Protected',
                      style: TextStyle(
                        fontSize: 11,
                        color: StealthColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
