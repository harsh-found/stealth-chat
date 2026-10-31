import 'dart:math';

class ReconnectStrategy {
  final Random _random;
  final int minDelayMs;
  final int maxDelayMs;

  ReconnectStrategy({
    Random? random,
    this.minDelayMs = 500,
    this.maxDelayMs = 30000,
  }) : _random = random ?? Random();

  /// Calculates exponential backoff with +/- 30% jitter.
  int getDelayMs(int attempt) {
    final baseDelayMs = min(minDelayMs * pow(2, attempt), maxDelayMs).toInt();
    final jitterMultiplier = 0.7 + (_random.nextDouble() * 0.6); // 0.7 to 1.3
    return (baseDelayMs * jitterMultiplier).toInt();
  }
}
