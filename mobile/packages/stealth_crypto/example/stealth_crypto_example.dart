import 'dart:convert';
import 'package:stealth_crypto/stealth_crypto.dart';

void main() async {
  const cipher = PlaintextMessageCipher();
  final encrypted = await cipher.encrypt(
    recipientId: 'recipient_1',
    plaintext: utf8.encode('Hello Stealth'),
  );
  print('Encrypted size: ${encrypted.length}');
}
