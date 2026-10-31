import 'dart:typed_data';

/// Interface for encrypting and decrypting message payloads.
/// The server treats the payload as opaque bytes.
abstract interface class MessageCipher {
  /// Encrypts plaintext payload for the given recipient.
  Future<Uint8List> encrypt({
    required String recipientId,
    required Uint8List plaintext,
  });

  /// Decrypts ciphertext payload received from the given sender.
  Future<Uint8List> decrypt({
    required String senderId,
    required Uint8List ciphertext,
  });
}

/// Plaintext (pass-through) implementation of [MessageCipher] used in Phases 1-3.
class PlaintextMessageCipher implements MessageCipher {
  const PlaintextMessageCipher();

  @override
  Future<Uint8List> encrypt({
    required String recipientId,
    required Uint8List plaintext,
  }) async {
    return plaintext;
  }

  @override
  Future<Uint8List> decrypt({
    required String senderId,
    required Uint8List ciphertext,
  }) async {
    return ciphertext;
  }
}
