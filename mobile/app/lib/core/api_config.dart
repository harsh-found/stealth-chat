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

  /// Converts any HTTP/HTTPS base URL into its corresponding WSS/WS gateway endpoint
  static String httpToWs(String httpUrl) {
    var trimmed = httpUrl.trim();
    while (trimmed.endsWith('/')) {
      trimmed = trimmed.substring(0, trimmed.length - 1);
    }
    if (trimmed.startsWith('https://')) {
      return 'wss://${trimmed.substring(8)}/ws';
    } else if (trimmed.startsWith('http://')) {
      return 'ws://${trimmed.substring(7)}/ws';
    } else {
      return 'ws://$trimmed/ws';
    }
  }
}
