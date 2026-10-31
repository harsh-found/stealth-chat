# ADR 0001: Riverpod 3 for Flutter State Management

## Context
Stealth Chat relies on Drift (SQLite3 Multiple Ciphers) streams for real-time reactivity, optimistic message delivery, and encrypted persistence.

## Decision
Adopt Riverpod 3 (`flutter_riverpod`). Drift query streams map directly to `StreamProvider` without verbose BLoC event/state boilerplate. Auto-dispose, scoped overrides for unit testing, and minimal rebuilding allow 120 FPS frame budgets.

## Consequences
- Requires strict dependency rules: Presentation depends on Domain; Notifiers orchestrate Domain repositories.
- Zero boilerplate stream bindings directly into Flutter UI.
