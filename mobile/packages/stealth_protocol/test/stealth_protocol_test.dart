import 'package:test/test.dart';
import 'package:stealth_protocol/stealth_protocol.dart';

void main() {
  group('MessageBody', () {
    test('serializes and deserializes correctly', () {
      final body = MessageBody(
        text: 'Hello, Stealth Chat!',
        mediaId: 'media-123',
        mime: 'image/png',
        waveform: [10, 20, 30, 40],
      );

      final bytes = body.toBytes();
      final decoded = MessageBody.fromBytes(bytes);

      expect(decoded.text, equals('Hello, Stealth Chat!'));
      expect(decoded.mediaId, equals('media-123'));
      expect(decoded.mime, equals('image/png'));
      expect(decoded.waveform, equals([10, 20, 30, 40]));
    });
  });

  group('ClientFrame and ServerFrame', () {
    test('SendMessage roundtrip via ClientFrame', () {
      final payload = MessageBody(text: 'Stealth Ping').toBytes();
      final sendMsg = SendMessage(
        messageId: '018f3a22-9a3b-7b00-8000-123456789abc',
        conversationId: 'conv-001',
        kind: MessageKind.text,
        payload: payload,
        clientTsMs: 1730390000000,
      );

      final frame = ClientFrame(reqId: 'req-1', body: sendMsg);
      final frameBytes = frame.toBytes();
      final parsed = ClientFrame.fromBytes(frameBytes);

      expect(parsed.reqId, equals('req-1'));
      expect(parsed.body, isA<SendMessage>());
      final parsedSend = parsed.body as SendMessage;
      expect(
          parsedSend.messageId, equals('018f3a22-9a3b-7b00-8000-123456789abc'));
      expect(parsedSend.conversationId, equals('conv-001'));
      expect(MessageBody.fromBytes(parsedSend.payload).text,
          equals('Stealth Ping'));
    });

    test('Ack roundtrip via ServerFrame', () {
      final ack = Ack(
        messageId: '018f3a22-9a3b-7b00-8000-123456789abc',
        seq: 42,
        serverTsMs: 1730390001000,
      );

      final frame = ServerFrame(reqId: 'req-1', body: ack);
      final frameBytes = frame.toBytes();
      final parsed = ServerFrame.fromBytes(frameBytes);

      expect(parsed.reqId, equals('req-1'));
      expect(parsed.body, isA<Ack>());
      final parsedAck = parsed.body as Ack;
      expect(
          parsedAck.messageId, equals('018f3a22-9a3b-7b00-8000-123456789abc'));
      expect(parsedAck.seq, equals(42));
    });

    test('ReceiptUpTo and ReceiptUpdate roundtrip', () {
      final receipt = ReceiptUpTo(
        conversationId: 'conv-001',
        deliveredUptoSeq: 10,
        readUptoSeq: 5,
      );
      final clientFrame = ClientFrame(reqId: 'req-2', body: receipt);
      final parsedClient = ClientFrame.fromBytes(clientFrame.toBytes());
      expect((parsedClient.body as ReceiptUpTo).deliveredUptoSeq, equals(10));

      final update = ReceiptUpdate(
        conversationId: 'conv-001',
        userId: 'user-2',
        deliveredUptoSeq: 10,
        readUptoSeq: 5,
      );
      final serverFrame = ServerFrame(body: update);
      final parsedServer = ServerFrame.fromBytes(serverFrame.toBytes());
      expect((parsedServer.body as ReceiptUpdate).userId, equals('user-2'));
    });
  });
}
