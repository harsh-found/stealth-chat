import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:meta/meta.dart';
import 'package:stealth_protocol/stealth_protocol.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'models.dart';
import 'outbox_storage.dart';

typedef WebSocketChannelFactory = WebSocketChannel Function(Uri uri);

class StealthSyncClient {
  final Uri gatewayUri;
  final String accessToken;
  final String deviceId;
  final OutboxStorage outboxStorage;
  final WebSocketChannelFactory _channelFactory;

  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _subscription;
  Timer? _reconnectTimer;
  Timer? _pingTimer;

  bool _isDisposed = false;
  bool _isConnected = false;
  int _reconnectAttempts = 0;
  final Random _random = Random();

  final StreamController<SyncEvent> _eventController =
      StreamController<SyncEvent>.broadcast();

  final Map<String, int> _lastKnownSeqs = {};

  StealthSyncClient({
    required this.gatewayUri,
    required this.accessToken,
    required this.deviceId,
    required this.outboxStorage,
    @visibleForTesting WebSocketChannelFactory? channelFactory,
  }) : _channelFactory =
            channelFactory ?? ((uri) => WebSocketChannel.connect(uri));

  Stream<SyncEvent> get events => _eventController.stream;
  bool get isConnected => _isConnected;

  void setLastKnownSeq(String conversationId, int seq) {
    final current = _lastKnownSeqs[conversationId] ?? 0;
    if (seq > current) {
      _lastKnownSeqs[conversationId] = seq;
    }
  }

  int getLastKnownSeq(String conversationId) =>
      _lastKnownSeqs[conversationId] ?? 0;

  void connect() {
    if (_isDisposed) return;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;

    try {
      _channel = _channelFactory(gatewayUri);
      _subscription = _channel!.stream.listen(
        _onData,
        onError: _onError,
        onDone: _onDone,
      );

      // Immediately send Hello frame
      _sendFrame(
        ClientFrame(
          reqId: 'hello_${DateTime.now().millisecondsSinceEpoch}',
          body: Hello(
            accessToken: accessToken,
            deviceId: deviceId,
            v: 1,
            syncToken: 0,
          ),
        ),
      );
    } catch (e) {
      _scheduleReconnect();
    }
  }

  void _onData(dynamic data) {
    try {
      Uint8List bytes;
      if (data is Uint8List) {
        bytes = data;
      } else if (data is List<int>) {
        bytes = Uint8List.fromList(data);
      } else if (data is String) {
        bytes = Uint8List.fromList(data.codeUnits);
      } else {
        return;
      }

      final frame = ServerFrame.fromBytes(bytes);
      _handleServerFrame(frame);
    } catch (e) {
      // Invalid frame ignored or handled safely
    }
  }

  void _handleServerFrame(ServerFrame frame) {
    final body = frame.body;

    if (body is HelloOk) {
      _isConnected = true;
      _reconnectAttempts = 0;
      _startPingTimer();
      _eventController.add(SyncConnected(body));

      for (final conv in body.changedConversations) {
        setLastKnownSeq(conv.conversationId, conv.lastSeq);
      }

      // Replay pending outbox items upon connection
      _flushOutbox();
    } else if (body is Ack) {
      // Remove from outbox and advance seq
      outboxStorage.removeItem(body.messageId);
      _eventController.add(
        SyncMessageAcked(
          messageId: body.messageId,
          seq: body.seq,
          serverTsMs: body.serverTsMs,
        ),
      );
    } else if (body is MessageNew) {
      final prevSeq = _lastKnownSeqs[body.conversationId] ?? 0;
      if (prevSeq > 0 && body.seq > prevSeq + 1) {
        // Gap detected! Notify and request catchup
        _eventController.add(
          SyncGapDetected(
            conversationId: body.conversationId,
            localSeq: prevSeq,
            receivedSeq: body.seq,
          ),
        );
        requestSync(conversationId: body.conversationId, afterSeq: prevSeq);
      }
      setLastKnownSeq(body.conversationId, body.seq);
      _eventController.add(SyncMessageReceived(body));
    } else if (body is ReceiptUpdate) {
      _eventController.add(SyncReceiptUpdateReceived(body));
    } else if (body is SyncBatch) {
      for (final msg in body.messages) {
        setLastKnownSeq(msg.conversationId, msg.seq);
      }
      _eventController.add(SyncBatchReceived(body));
    } else if (body is Presence) {
      _eventController.add(SyncPresenceReceived(body));
    } else if (body is ProtocolError) {
      _eventController.add(SyncErrorReceived(body));
    } else if (body is Pong) {
      // Heartbeat acknowledged
    } else if (body is Kick) {
      _eventController.add(SyncDisconnected('Session kicked: ${body.reason}'));
      disconnect();
    }
  }

  Future<void> _flushOutbox() async {
    final pending = await outboxStorage.getPendingItems();
    final now = DateTime.now();

    for (final item in pending) {
      if (item.nextTryAt != null && item.nextTryAt!.isAfter(now)) {
        continue;
      }
      _sendFrame(
        ClientFrame(
          reqId: 'send_${item.messageId}',
          body: item.toSendMessage(),
        ),
      );
    }
  }

  Future<void> enqueueMessage(OutboxItem item) async {
    await outboxStorage.saveItem(item);
    if (_isConnected) {
      _sendFrame(
        ClientFrame(
          reqId: 'send_${item.messageId}',
          body: item.toSendMessage(),
        ),
      );
    }
  }

  void sendReceipt({
    required String conversationId,
    required int deliveredUptoSeq,
    required int readUptoSeq,
  }) {
    if (!_isConnected) return;
    _sendFrame(
      ClientFrame(
        reqId: 'receipt_${DateTime.now().millisecondsSinceEpoch}',
        body: ReceiptUpTo(
          conversationId: conversationId,
          deliveredUptoSeq: deliveredUptoSeq,
          readUptoSeq: readUptoSeq,
        ),
      ),
    );
  }

  void sendTyping({
    required String conversationId,
    required bool isTyping,
  }) {
    if (!_isConnected) return;
    _sendFrame(
      ClientFrame(
        reqId: 'typing_${DateTime.now().millisecondsSinceEpoch}',
        body: Typing(
          conversationId: conversationId,
          isTyping: isTyping,
        ),
      ),
    );
  }

  void requestSync({
    required String conversationId,
    required int afterSeq,
    int limit = 50,
  }) {
    if (!_isConnected) return;
    _sendFrame(
      ClientFrame(
        reqId: 'sync_${DateTime.now().millisecondsSinceEpoch}',
        body: SyncRequest(
          conversationId: conversationId,
          afterSeq: afterSeq,
          limit: limit,
        ),
      ),
    );
  }

  void subscribePresence(List<String> userIds) {
    if (!_isConnected) return;
    _sendFrame(
      ClientFrame(
        reqId: 'presence_${DateTime.now().millisecondsSinceEpoch}',
        body: SubscribePresence(userIds: userIds),
      ),
    );
  }

  void _sendFrame(ClientFrame frame) {
    if (_channel != null) {
      _channel!.sink.add(frame.toBytes());
    }
  }

  void _startPingTimer() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(const Duration(seconds: 25), (_) {
      if (_isConnected) {
        _sendFrame(
          ClientFrame(
            reqId: 'ping_${DateTime.now().millisecondsSinceEpoch}',
            body: Ping(timestampMs: DateTime.now().millisecondsSinceEpoch),
          ),
        );
      }
    });
  }

  void _onError(dynamic error) {
    _handleDisconnect(error);
  }

  void _onDone() {
    _handleDisconnect(null);
  }

  void _handleDisconnect(dynamic error) {
    final wasConnected = _isConnected;
    _isConnected = false;
    _pingTimer?.cancel();
    _pingTimer = null;
    _subscription?.cancel();
    _subscription = null;
    _channel = null;

    if (wasConnected) {
      _eventController.add(SyncDisconnected(error));
    }

    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    if (_isDisposed || _reconnectTimer != null) return;

    // Exponential backoff: 0.5s doubling to 30s, +/- 30% jitter
    final baseDelayMs = min(500 * pow(2, _reconnectAttempts), 30000).toInt();
    final jitterMultiplier = 0.7 + (_random.nextDouble() * 0.6); // 0.7 to 1.3
    final delayMs = (baseDelayMs * jitterMultiplier).toInt();

    _reconnectAttempts++;
    _reconnectTimer = Timer(Duration(milliseconds: delayMs), () {
      _reconnectTimer = null;
      connect();
    });
  }

  void disconnect() {
    _isConnected = false;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _pingTimer?.cancel();
    _pingTimer = null;
    _subscription?.cancel();
    _subscription = null;
    _channel?.sink.close();
    _channel = null;
  }

  void dispose() {
    _isDisposed = true;
    disconnect();
    _eventController.close();
  }
}
