import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:stealth_protocol/stealth_protocol.dart';
import 'package:stealth_sync/stealth_sync.dart';

class MockWebSocketChannel implements WebSocketChannel {
  final StreamController<dynamic> incoming =
      StreamController<dynamic>.broadcast();
  final StreamController<dynamic> outgoing =
      StreamController<dynamic>.broadcast();

  @override
  Stream<dynamic> get stream => incoming.stream;

  @override
  WebSocketSink get sink => _MockSink(outgoing);

  @override
  String? get protocol => null;

  @override
  String? get closeReason => null;

  @override
  int? get closeCode => null;

  @override
  Future<void> get ready => Future.value();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MockSink implements WebSocketSink {
  final StreamController<dynamic> _controller;
  _MockSink(this._controller);

  @override
  void add(dynamic data) => _controller.add(data);

  @override
  void addError(Object error, [StackTrace? stackTrace]) =>
      _controller.addError(error, stackTrace);

  @override
  Future<void> addStream(Stream<dynamic> stream) =>
      _controller.addStream(stream);

  @override
  Future<void> close([int? closeCode, String? closeReason]) async =>
      _controller.close();

  @override
  Future<dynamic> get done => _controller.done;
}

void main() {
  late MockWebSocketChannel mockChannel;
  late StealthSyncClient client;
  late InMemoryOutboxStorage storage;

  setUp(() {
    mockChannel = MockWebSocketChannel();
    storage = InMemoryOutboxStorage();
    client = StealthSyncClient(
      gatewayUri: Uri.parse('ws://localhost:3001'),
      accessToken: 'test-jwt',
      deviceId: 'device-test-1',
      outboxStorage: storage,
      channelFactory: (uri) => mockChannel,
    );
  });

  tearDown(() {
    client.dispose();
  });

  test('Connect, send Hello frame, and receive HelloOk event', () async {
    final events = <SyncEvent>[];
    client.events.listen(events.add);

    final futureSent = mockChannel.outgoing.stream.first;
    client.connect();

    final sentRaw = await futureSent;
    expect(sentRaw, isA<Uint8List>());
    final clientFrame = ClientFrame.fromBytes(sentRaw as Uint8List);
    expect(clientFrame.body, isA<Hello>());
    final hello = clientFrame.body as Hello;
    expect(hello.accessToken, equals('test-jwt'));
    expect(hello.deviceId, equals('device-test-1'));

    // Server sends HelloOk
    final helloOk = ServerFrame(
      reqId: clientFrame.reqId,
      body: HelloOk(
        serverTimeMs: 1730390000000,
        changedConversations: [
          ConversationSummary(
            conversationId: 'conv-1',
            lastSeq: 5,
            unreadCount: 1,
            lastMessagePreview: 'Hello',
            lastMessageAtMs: 1730390000000,
          )
        ],
      ),
    );
    mockChannel.incoming.add(helloOk.toBytes());

    await Future<void>.delayed(const Duration(milliseconds: 30));
    expect(client.isConnected, isTrue);
    expect(events.whereType<SyncConnected>().length, equals(1));
  });

  test(
      'Send message persists to outbox, transmits on connect, and Ack removes from outbox',
      () async {
    client.connect();

    // Simulate HelloOk to get connected
    mockChannel.incoming.add(ServerFrame(
      body: HelloOk(serverTimeMs: 1730390000000),
    ).toBytes());
    await Future<void>.delayed(const Duration(milliseconds: 20));

    final msgId = '018f3a22-9a3b-7b00-8000-123456789abc';
    final futureSent = mockChannel.outgoing.stream.first;
    await client.enqueueMessage(
      OutboxItem(
        id: msgId,
        messageId: msgId,
        conversationId: 'conv-1',
        kind: MessageKind.text,
        payload: Uint8List.fromList(utf8.encode('Hello Stealth!')),
        clientTsMs: 1730390000000,
      ),
    );

    final sentRaw = await futureSent;
    expect(sentRaw, isA<Uint8List>());

    var pending = await storage.getPendingItems();
    expect(pending.length, equals(1));
    expect(pending.first.messageId, equals(msgId));

    // Simulate server Ack
    mockChannel.incoming.add(ServerFrame(
      body: Ack(
        messageId: msgId,
        seq: 10,
        serverTsMs: 1730390001000,
      ),
    ).toBytes());

    await Future<void>.delayed(const Duration(milliseconds: 30));
    pending = await storage.getPendingItems();
    expect(pending.isEmpty, isTrue);
  });

  test('Gap detection triggers SyncGapDetected when seq jumps', () async {
    client.connect();
    client.setLastKnownSeq('conv-1', 10);

    final events = <SyncEvent>[];
    client.events.listen(events.add);

    // Simulate receiving seq 15 when local is 10
    mockChannel.incoming.add(ServerFrame(
      body: MessageNew(
        conversationId: 'conv-1',
        seq: 15,
        messageId: 'msg-15',
        senderId: 'user-bob',
        payload: Uint8List.fromList(utf8.encode('Jump')),
        serverTsMs: 1730390002000,
      ),
    ).toBytes());

    await Future<void>.delayed(const Duration(milliseconds: 30));
    final gaps = events.whereType<SyncGapDetected>().toList();
    expect(gaps.length, equals(1));
    expect(gaps.first.conversationId, equals('conv-1'));
    expect(gaps.first.localSeq, equals(10));
    expect(gaps.first.receivedSeq, equals(15));
  });

  test('sendReceipt emits ReceiptUpTo frame', () async {
    client.connect();
    mockChannel.incoming.add(ServerFrame(
      body: HelloOk(serverTimeMs: 1730390000000),
    ).toBytes());
    await Future<void>.delayed(const Duration(milliseconds: 20));

    final futureSent = mockChannel.outgoing.stream.first;
    client.sendReceipt(
      conversationId: 'conv-1',
      deliveredUptoSeq: 15,
      readUptoSeq: 12,
    );

    final sentRaw = await futureSent;
    final clientFrame = ClientFrame.fromBytes(sentRaw as Uint8List);
    expect(clientFrame.body, isA<ReceiptUpTo>());
    final receipt = clientFrame.body as ReceiptUpTo;
    expect(receipt.conversationId, equals('conv-1'));
    expect(receipt.deliveredUptoSeq, equals(15));
    expect(receipt.readUptoSeq, equals(12));
  });
}
