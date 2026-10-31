default:
    @just --list

bootstrap:
    @echo "==> Bootstrapping repository dependencies..."
    cd server && pnpm install
    cd mobile/packages/stealth_protocol && dart pub get
    cd mobile/packages/stealth_crypto && dart pub get
    cd mobile/packages/stealth_sync && dart pub get
    cd mobile/packages/stealth_db && dart pub get
    cd mobile/packages/stealth_ui_kit && flutter pub get
    cd mobile/app && flutter pub get

dev:
    @echo "==> Starting local dev environment..."
    docker compose -f infra/docker-compose.dev.yml up -d

test-server:
    @echo "==> Running server tests..."
    cd server && pnpm test

test-mobile:
    @echo "==> Running mobile package & app tests..."
    cd mobile/packages/stealth_protocol && dart test
    cd mobile/packages/stealth_crypto && dart test
    cd mobile/packages/stealth_sync && dart test
    cd mobile/packages/stealth_db && dart test
    cd mobile/packages/stealth_ui_kit && flutter test
    cd mobile/app && flutter test

check: test-server test-mobile
    @echo "==> All test suites passed successfully!"
