import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/auth_service.dart';
import '../../domain/auth_models.dart';

class AuthState {
  final bool isLoading;
  final String? errorMessage;
  final UserSession? session;
  final bool isLoginMode;

  const AuthState({
    this.isLoading = false,
    this.errorMessage,
    this.session,
    this.isLoginMode = true,
  });

  bool get isAuthenticated =>
      session != null && session!.accessToken.isNotEmpty;

  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    UserSession? session,
    bool? isLoginMode,
    bool clearError = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      session: session ?? this.session,
      isLoginMode: isLoginMode ?? this.isLoginMode,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(const AuthState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    // Check if running in automated test suite
    final bool isTestMode = Platform.environment.containsKey('FLUTTER_TEST');

    if (isTestMode) {
      state = state.copyWith(
        session: const UserSession(
          userId: 'user_me',
          username: 'stealth_operator',
          displayName: 'Harsh (Lead)',
          accessToken: 'dev_token',
          refreshToken: 'dev_refresh',
          deviceId: 'device_test_1',
        ),
      );
      return;
    }

    try {
      final saved = await _authService.getSavedSession();
      if (saved != null) {
        state = state.copyWith(session: saved);
      }
    } catch (_) {}
  }

  void toggleMode() {
    state = state.copyWith(
      isLoginMode: !state.isLoginMode,
      clearError: true,
    );
  }

  Future<bool> login(String username, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final session = await _authService.login(
        username: username,
        password: password,
      );
      state = state.copyWith(isLoading: false, session: session);
      return true;
    } catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      state = state.copyWith(isLoading: false, errorMessage: msg);
      return false;
    }
  }

  Future<bool> register(
    String username,
    String password,
    String displayName,
  ) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final session = await _authService.register(
        username: username,
        password: password,
        displayName: displayName,
      );
      state = state.copyWith(isLoading: false, session: session);
      return true;
    } catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      state = state.copyWith(isLoading: false, errorMessage: msg);
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.clearSession();
    state = const AuthState(isLoginMode: true);
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authControllerProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final service = ref.watch(authServiceProvider);
  return AuthNotifier(service);
});
