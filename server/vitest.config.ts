import { defineConfig } from 'vitest/config';
import path from 'path';

export default defineConfig({
  test: {
    environment: 'node',
    globals: true,
  },
  resolve: {
    alias: {
      '@stealth/core': path.resolve(__dirname, 'packages/core/src/index.ts'),
      '@stealth/contracts-ts': path.resolve(__dirname, 'packages/contracts-ts/src/index.ts'),
      '@stealth/db': path.resolve(__dirname, 'packages/db/src/index.ts'),
    },
  },
});
