# 04 Security & Privacy: Stealth Chat

## Security Layers
1. **Local Storage Encryption**: SQLite3 Multiple Ciphers key generated securely and stored in Android Keystore via `flutter_secure_storage`.
2. **Network Transport**: WSS / HTTPS with TLS 1.3.
3. **Session Management**: EdDSA signed short-lived JWT (15 mins) + rotating refresh token family.
4. **Password Security**: PBKDF2-HMAC-SHA512 with cryptographically random 16-byte salt and 100,000 iterations for username & password authentication.
5. **Opaque Payloads**: Server treats `payload` as opaque bytes; prepares for Phase 4 E2EE.
6. **App Hardening**: `FLAG_SECURE` toggles, disabled cleartext traffic, biometric lock.

