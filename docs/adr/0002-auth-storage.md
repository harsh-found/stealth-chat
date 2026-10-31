# ADR 0002: Secure Storage and HTTP Client for Authentication

## Context
Stealth Chat requires persistent, encrypted user authentication sessions (access tokens, device IDs, user metadata) and REST API communication with the backend authentication and user search endpoints.

## Decision
Adopt `flutter_secure_storage` (BSD-3-Clause) for Keystore/EncryptedSharedPreferences-backed session storage and `http` (BSD-3-Clause) for REST communication.

## Consequences
- Access tokens and credentials never touch unencrypted shared preferences.
- Standard lightweight HTTP client with zero copyleft licensing risk.
