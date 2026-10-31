import { loadConfig, logger } from '@stealth/core';

const config = loadConfig();

logger.info('Starting Stealth Background Worker...', { env: config.nodeEnv });

// Worker loops periodically checking for pending outbox events and FCM tasks
let isRunning = true;

async function processOutbox() {
  if (!isRunning) return;
  // Poll outbox events table or Redis stream
  setTimeout(processOutbox, 5000);
}

processOutbox();

process.on('SIGTERM', () => {
  logger.info('Worker shutting down cleanly');
  isRunning = false;
});
