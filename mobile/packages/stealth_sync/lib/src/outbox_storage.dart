import 'models.dart';

/// Storage contract for pending outbox items that survive app restarts.
abstract interface class OutboxStorage {
  Future<List<OutboxItem>> getPendingItems();
  Future<void> saveItem(OutboxItem item);
  Future<void> removeItem(String messageId);
  Future<void> markFailed(String messageId, {int? retryAfterMs});
}

/// In-memory storage useful for testing and transient sessions.
class InMemoryOutboxStorage implements OutboxStorage {
  final Map<String, OutboxItem> _items = {};

  @override
  Future<List<OutboxItem>> getPendingItems() async {
    return _items.values.toList()
      ..sort((a, b) => a.clientTsMs.compareTo(b.clientTsMs));
  }

  @override
  Future<void> saveItem(OutboxItem item) async {
    _items[item.messageId] = item;
  }

  @override
  Future<void> removeItem(String messageId) async {
    _items.remove(messageId);
  }

  @override
  Future<void> markFailed(String messageId, {int? retryAfterMs}) async {
    final item = _items[messageId];
    if (item != null) {
      final nextTry = retryAfterMs != null
          ? DateTime.now().add(Duration(milliseconds: retryAfterMs))
          : null;
      _items[messageId] = item.copyWith(
        attempts: item.attempts + 1,
        nextTryAt: nextTry,
      );
    }
  }
}
