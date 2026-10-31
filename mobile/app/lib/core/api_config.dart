/// Backend API & WebSocket Configuration for Stealth Chat
class ApiConfig {
  /// Default production Render HTTPS endpoint
  static const String defaultHttpBaseUrl = 'https://stealth-chat.onrender.com';

  /// Default production Render WSS endpoint
  static const String defaultWsGatewayUrl =
      'wss://stealth-chat.onrender.com/ws';

  /// Local development fallback endpoints (Android emulator maps 10.0.2.2 to host)
  static const String devHttpBaseUrl = 'http://10.0.2.2:3000';
  static const String devWsGatewayUrl = 'ws://10.0.2.2:3000/ws';
}
