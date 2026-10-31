export interface Config {
  port: number;
  gatewayPort: number;
  databaseUrl: string;
  redisUrl: string;
  jwtSecret: string;
  nodeEnv: string;
}

export function loadConfig(): Config {
  return {
    port: parseInt(process.env.PORT || '3000', 10),
    gatewayPort: parseInt(process.env.GATEWAY_PORT || '3001', 10),
    databaseUrl: process.env.DATABASE_URL || 'postgres://stealth:stealth_pass@localhost:5432/stealth_chat',
    redisUrl: process.env.REDIS_URL || 'redis://localhost:6379',
    jwtSecret: process.env.JWT_SECRET || 'super_stealth_secret_key_minimum_32_bytes_long_1234',
    nodeEnv: process.env.NODE_ENV || 'development',
  };
}
