# Performance Log

## Budgets
- Chat list scroll: UI & raster threads <= 8.33ms (120 FPS target), <1% jank.
- Bubble paint latency: 1 frame after tap (optimistic send).
- Startup to first frame from local DB: <= 1.0s.
- p95 Ack latency: <= 100ms.
- p95 Delivery latency: <= 300ms.

## Measurements
| Date | Component | Metric | Target | Actual | Status |
|------|-----------|--------|--------|--------|--------|
| 2026-10-31 | Protocol SerDe | 10k frames marshal | < 200ms | 42ms | PASS |
| 2026-10-31 | Outbox Queue | Insert-to-Drain | < 16ms | 3.2ms | PASS |
