import 'dart:convert';
import 'dart:typed_data';
import 'package:stealth_crypto/stealth_crypto.dart';
import 'package:test/test.dart';

void main() {
  group('PlaintextMessageCipher', () {
    final cipher = PlaintextMessageCipher();

    test('encrypt passes through bytes without alteration', () async {
      final input = Uint8List.fromList(utf8.encode('Stealth Message'));
      final encrypted =
          await cipher.encrypt(recipientId: 'user_123', plaintext: input);
      expect(encrypted, equals(input));
    });

    test('decrypt passes through bytes without alteration', () async {
      final input = Uint8List.fromList(utf8.encode('Stealth Decrypted'));
      final decrypted =
          await cipher.decrypt(senderId: 'user_456', ciphertext: input);
      expect(decrypted, equals(input));
    });
  });
}
