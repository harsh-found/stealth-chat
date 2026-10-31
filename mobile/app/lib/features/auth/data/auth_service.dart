import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../../core/api_config.dart';
import '../domain/auth_models.dart';

class AuthService {
  final FlutterSecureStorage _storage;
  String baseUrl;
  static const String _sessionKey = 'stealth_auth_session_v1';
  static const String _serverUrlKey = 'stealth_server_url_v1';

  static final Map<String, String> _memoryFallback = {};

  AuthService({
    FlutterSecureStorage? storage,
    this.baseUrl = ApiConfig.defaultHttpBaseUrl,
  }) : _storage = storage ?? const FlutterSecureStorage();

  Future<void> _writeStorage(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (_) {
      _memoryFallback[key] = value;
    }
  }

  Future<String?> _readStorage(String key) async {
    try {
      final val = await _storage.read(key: key);
      return val ?? _memoryFallback[key];
    } catch (_) {
      return _memoryFallback[key];
    }
  }

  Future<void> _deleteStorage(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (_) {}
    _memoryFallback.remove(key);
  }

  Future<String> getServerUrl() async {
    final saved = await _readStorage(_serverUrlKey);
    if (saved != null && saved.trim().isNotEmpty) {
      baseUrl = saved.trim();
      return baseUrl;
    }
    return baseUrl;
  }

  Future<void> setServerUrl(String url) async {
    var cleaned = url.trim();
    while (cleaned.endsWith('/')) {
      cleaned = cleaned.substring(0, cleaned.length - 1);
    }
    baseUrl = cleaned;
    await _writeStorage(_serverUrlKey, cleaned);
  }

  Future<UserSession?> getSavedSession() async {
    final raw = await _readStorage(_sessionKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return UserSession.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveSession(UserSession session) async {
    final raw = jsonEncode(session.toJson());
    await _writeStorage(_sessionKey, raw);
  }

  Future<void> clearSession() async {
    await _deleteStorage(_sessionKey);
  }

  Future<UserSession> register({
    required String username,
    required String password,
    String? displayName,
    String? deviceName,
  }) async {
    final uri = Uri.parse('$baseUrl/api/auth/register');
    final response = await http
        .post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'username': username,
            'password': password,
            'display_name': displayName,
            'device_name': deviceName ?? 'Android Device',
          }),
        )
        .timeout(const Duration(seconds: 15));

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final session = UserSession.fromJson(data);
      await saveSession(session);
      return session;
    } else {
      final err = data['error'] as String? ?? 'Registration failed';
      throw Exception(err);
    }
  }

  Future<UserSession> login({
    required String username,
    required String password,
    String? deviceName,
  }) async {
    final uri = Uri.parse('$baseUrl/api/auth/login');
    final response = await http
        .post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'username': username,
            'password': password,
            'device_name': deviceName ?? 'Android Device',
          }),
        )
        .timeout(const Duration(seconds: 15));

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final session = UserSession.fromJson(data);
      await saveSession(session);
      return session;
    } else {
      final err = data['error'] as String? ?? 'Login failed';
      throw Exception(err);
    }
  }

  Future<List<UserSearchItem>> searchUsers({
    required String query,
    required String token,
  }) async {
    final uri =
        Uri.parse('$baseUrl/api/users/search?q=${Uri.encodeComponent(query)}');
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final list = (data['users'] as List<dynamic>?) ?? [];
      return list
          .map((item) => UserSearchItem.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to search users');
    }
  }

  Future<Map<String, dynamic>> createConversation({
    required String peerId,
    required String token,
  }) async {
    final uri = Uri.parse('$baseUrl/api/conversations');
    final response = await http
        .post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({'peer_id': peerId}),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (data['conversation'] as Map<String, dynamic>?) ?? {};
    } else {
      throw Exception('Failed to create conversation');
    }
  }

  Future<List<Map<String, dynamic>>> getConversations(String token) async {
    final uri = Uri.parse('$baseUrl/api/conversations');
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final list = (data['conversations'] as List<dynamic>?) ?? [];
      return list.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load conversations');
    }
  }
}
