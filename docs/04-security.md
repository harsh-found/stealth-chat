# 04 Security & Privacy: Stealth Chat

## Security Layers
1. **Local Storage Encryption**: SQLite3 Multiple Ciphers key generated securely and stored in Android Keystore via `flutter_secure_storage`.
2. **Network Transport**: WSS / HTTPS with TLS 1.3.
3. **Session Management**: EdDSA signed short-lived JWT (15 mins) + rotating refresh token family.
4. **Opaque Payloads**: Server treats `payload` as opaque bytes; prepares for Phase 4 E2EE.
5. **App Hardening**: `FLAG_SECURE` toggles, disabled cleartext traffic, biometric lock.
