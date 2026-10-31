# AGENTS.md: Stealth Chat

Android-first chat app. Flutter app in `mobile/`, Fastify server in `server/`,
shared protocol in `contracts/`. Read `docs/` before coding.

## Read order
1. `docs/phases/phase-N.md` (current phase and its tasks)
2. The README inside the feature or package you touch
3. `docs/02-protocol.md`, `docs/03-data-model.md`, `docs/04-security.md` when relevant

## Commands (run from the repo root)
- `just bootstrap`   install toolchains and dependencies
- `just gen`         regenerate Protobuf, OpenAPI, Drift and Riverpod code
- `just dev`         start Postgres, Redis, MinIO, api, gateway, worker
- `just check`       format, analyze, typecheck, unit tests, codegen drift check
- `just test-mobile`, `just test-server`, `just bench`

## Non-negotiable rules
- The client generates message ids (UUIDv7). The server assigns `seq`. Receipts are cursors.
- The local Drift database is the source of truth for the UI. A sent message
  appears without waiting for the network.
- Never edit generated files: `stealth_protocol`, `contracts-ts`, `*.g.dart`.
- No new dependency without a one-line ADR in `docs/adr/`. Check its license:
  no GPL or AGPL without the owner's approval.
- Resolve versions with `flutter pub add` and `pnpm add`. Do not copy versions from docs.
- No secrets in the repo. `.env.example` lists names only.
- Files under 300 lines, one public widget per file, feature-first folders.
- Use the logger, never `print`. No personal data or message text in logs.
- Auth, crypto and key-storage code needs a test and a note in `docs/04-security.md`.

## Definition of done
1. `just check` passes with no new warnings.
2. The task's acceptance steps pass, including the offline and retry case.
3. Docs are updated if a contract, schema or rule changed.
4. Reply with 3 lines: what changed, how it was verified, what is left.

## Stop and ask the owner when
- A change would alter a protocol invariant or the wire format.
- Requirements conflict or acceptance criteria are unclear.
- A native or copyleft dependency, or a store-policy question, comes up.
