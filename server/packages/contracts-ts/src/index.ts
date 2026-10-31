export enum MessageKind {
  UNSPECIFIED = 0,
  TEXT = 1,
  IMAGE = 2,
  VOICE = 3,
  VIDEO = 4,
  FILE = 5,
}

export enum ErrorCode {
  UNSPECIFIED = 0,
  UNAUTHENTICATED = 1,
  TOKEN_EXPIRED = 2,
  FORBIDDEN = 3,
  NOT_FOUND = 4,
  RATE_LIMITED = 5,
  TOO_LARGE = 6,
  INTERNAL = 7,
  UNSUPPORTED_VERSION = 8,
}

export interface MessageBody {
  text: string;
  media_id?: string;
  mime?: string;
  file_name?: string;
  size_bytes?: number;
  thumbhash?: string;
  duration_ms?: number;
  waveform?: number[];
}

export interface SendMessage {
  message_id: string;
  conversation_id: string;
  kind?: MessageKind;
  payload: string; // base64 encoded or stringified
  reply_to_id?: string;
  client_ts_ms: number;
}

export interface Ack {
  message_id: string;
  seq: number;
  server_ts_ms: number;
}

export interface MessageNew {
  conversation_id: string;
  seq: number;
  message_id: string;
  sender_id: string;
  kind: MessageKind;
  payload: string;
  reply_to_id?: string;
  server_ts_ms: number;
  edit_version?: number;
}

export interface ReceiptUpTo {
  conversation_id: string;
  delivered_upto_seq: number;
  read_upto_seq: number;
}

export interface ReceiptUpdate {
  conversation_id: string;
  user_id: string;
  delivered_upto_seq: number;
  read_upto_seq: number;
}

export interface Hello {
  access_token: string;
  device_id: string;
  v?: number;
  sync_token?: number;
}

export interface ConversationSummary {
  conversation_id: string;
  last_seq: number;
  unread_count: number;
  last_message_preview: string;
  last_message_at_ms: number;
}

export interface HelloOk {
  server_time_ms: number;
  changed_conversations?: ConversationSummary[];
}

export interface SyncRequest {
  conversation_id: string;
  after_seq: number;
  limit?: number;
}

export interface SyncBatch {
  conversation_id: string;
  messages: MessageNew[];
  has_more: boolean;
}

export interface Typing {
  conversation_id: string;
  is_typing: boolean;
}

export interface SubscribePresence {
  user_ids: string[];
}

export interface Presence {
  user_id: string;
  online: boolean;
  last_seen_ms: number;
}

export interface Ping {
  timestamp_ms: number;
}

export interface Pong {
  timestamp_ms: number;
}

export interface ProtocolError {
  req_id: string;
  code: ErrorCode;
  message: string;
  retry_after_ms?: number;
}

export interface Kick {
  reason: string;
}

export interface ClientFrame {
  v?: number;
  req_id?: string;
  hello?: Hello;
  send?: SendMessage;
  receipt?: ReceiptUpTo;
  typing?: Typing;
  sync?: SyncRequest;
  subscribe_presence?: SubscribePresence;
  ping?: Ping;
}

export interface ServerFrame {
  v?: number;
  req_id?: string;
  hello_ok?: HelloOk;
  ack?: Ack;
  error?: ProtocolError;
  message_new?: MessageNew;
  receipt?: ReceiptUpdate;
  sync_batch?: SyncBatch;
  presence?: Presence;
  typing?: Typing;
  pong?: Pong;
  kick?: Kick;
}

export function encodeClientFrame(frame: ClientFrame): Buffer {
  return Buffer.from(JSON.stringify(frame), 'utf-8');
}

export function decodeClientFrame(data: Buffer | string): ClientFrame | null {
  try {
    const str = Buffer.isBuffer(data) ? data.toString('utf-8') : data;
    return JSON.parse(str) as ClientFrame;
  } catch {
    return null;
  }
}

export function encodeServerFrame(frame: ServerFrame): Buffer {
  return Buffer.from(JSON.stringify(frame), 'utf-8');
}

export function decodeServerFrame(data: Buffer | string): ServerFrame | null {
  try {
    const str = Buffer.isBuffer(data) ? data.toString('utf-8') : data;
    return JSON.parse(str) as ServerFrame;
  } catch {
    return null;
  }
}
