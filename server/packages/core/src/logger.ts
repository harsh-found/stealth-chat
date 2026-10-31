export interface LogMeta {
  reqId?: string;
  userId?: string;
  deviceId?: string;
  [key: string]: unknown;
}

export const logger = {
  info(msg: string, meta?: LogMeta) {
    console.log(JSON.stringify({ level: 'info', time: new Date().toISOString(), msg, ...meta }));
  },
  warn(msg: string, meta?: LogMeta) {
    console.warn(JSON.stringify({ level: 'warn', time: new Date().toISOString(), msg, ...meta }));
  },
  error(msg: string, error?: unknown, meta?: LogMeta) {
    console.error(
      JSON.stringify({
        level: 'error',
        time: new Date().toISOString(),
        msg,
        error: error instanceof Error ? error.message : String(error),
        ...meta,
      })
    );
  },
};
