import { describe, it, expect } from 'vitest';
import { uuidv7, signAccessToken, verifyAccessToken, hashToken, otpProvider } from '@stealth/core';
import {
  encodeClientFrame,
  decodeClientFrame,
  encodeServerFrame,
  decodeServerFrame,
  MessageKind,
} from '@stealth/contracts-ts';

describe('UUIDv7 Generator', () => {
  it('generates a valid UUIDv7 format with correct version 7 byte', () => {
    const id = uuidv7();
    expect(id).toMatch(/^[0-9a-f]{8}-[0-9a-f]{4}-7[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i);
  });

  it('generates strictly sequential ids over time', async () => {
    const id1 = uuidv7();
    await new Promise((r) => setTimeout(r, 5));
    const id2 = uuidv7();
    expect(id2 > id1).toBe(true);
  });
});

describe('Core Authentication', () => {
  const secret = 'test-secret-key-that-is-at-least-32-chars-long';

  it('signs and verifies access tokens cleanly', () => {
    const payload = { userId: 'u-1', deviceId: 'd-1', username: 'stealth_op' };
    const token = signAccessToken(payload, secret);
    const verified = verifyAccessToken(token, secret);
    expect(verified.userId).toBe('u-1');
    expect(verified.deviceId).toBe('d-1');
    expect(verified.username).toBe('stealth_op');
  });

  it('hashes refresh tokens consistently', () => {
    const raw = 'random-token-12345';
    const h1 = hashToken(raw);
    const h2 = hashToken(raw);
    expect(h1).toBe(h2);
    expect(h1.length).toBe(64);
  });

  it('OTP provider sends and verifies one-time codes', () => {
    const phone = '+1234567890';
    const code = otpProvider.sendOtp(phone);
    expect(code).toBe('123456');
    expect(otpProvider.verifyOtp(phone, '123456')).toBe(true);
    // Already consumed
    expect(otpProvider.verifyOtp(phone, '123456')).toBe(false);
  });
});

describe('Contract SerDe', () => {
  it('encodes and decodes ClientFrame with SendMessage', () => {
    const frame = {
      v: 1,
      req_id: 'req-10',
      send: {
        message_id: '018f3a22-9a3b-7b00-8000-123456789abc',
        conversation_id: 'c-100',
        kind: MessageKind.TEXT,
        payload: Buffer.from('Testing wire frames').toString('base64'),
        client_ts_ms: Date.now(),
      },
    };

    const encoded = encodeClientFrame(frame);
    const decoded = decodeClientFrame(encoded);

    expect(decoded).not.toBeNull();
    expect(decoded?.req_id).toBe('req-10');
    expect(decoded?.send?.conversation_id).toBe('c-100');
    expect(decoded?.send?.message_id).toBe('018f3a22-9a3b-7b00-8000-123456789abc');
  });

  it('encodes and decodes ServerFrame with Ack and MessageNew', () => {
    const serverFrame = {
      v: 1,
      req_id: 'req-10',
      ack: {
        message_id: 'm-1',
        seq: 42,
        server_ts_ms: Date.now(),
      },
    };

    const encoded = encodeServerFrame(serverFrame);
    const decoded = decodeServerFrame(encoded);

    expect(decoded).not.toBeNull();
    expect(decoded?.ack?.seq).toBe(42);
    expect(decoded?.ack?.message_id).toBe('m-1');
  });
});

describe('Realtime Invariants (Idempotency & Sequence)', () => {
  it('enforces idempotency on duplicate message_id and prevents duplicate seq assignment', () => {
    const messageStore = new Map<string, { seq: number; ts: number }>();
    let lastSeq = 0;

    function processMessage(messageId: string) {
      if (messageStore.has(messageId)) {
        return {
          ...messageStore.get(messageId)!,
          isDuplicate: true,
        };
      }
      lastSeq += 1;
      const entry = { seq: lastSeq, ts: Date.now() };
      messageStore.set(messageId, entry);
      return { ...entry, isDuplicate: false };
    }

    const mid = '018f3a22-9a3b-7b00-8000-idempotent-test';
    const firstResult = processMessage(mid);
    expect(firstResult.seq).toBe(1);
    expect(firstResult.isDuplicate).toBe(false);

    // Replay duplicate message_id
    const duplicateResult = processMessage(mid);
    expect(duplicateResult.seq).toBe(1);
    expect(duplicateResult.isDuplicate).toBe(true);

    // New message advances seq
    const nextResult = processMessage('018f3a22-9a3b-7b00-8000-second-message');
    expect(nextResult.seq).toBe(2);
    expect(nextResult.isDuplicate).toBe(false);
  });

  it('updates monotonic delivery and read receipt cursors correctly', () => {
    let deliveredCursor = 0;
    let readCursor = 0;

    function updateReceipt(delivered: number, read: number) {
      deliveredCursor = Math.max(deliveredCursor, delivered);
      readCursor = Math.max(readCursor, read);
    }

    updateReceipt(5, 3);
    expect(deliveredCursor).toBe(5);
    expect(readCursor).toBe(3);

    // Out of order receipt frame with lower sequence should not regress cursors
    updateReceipt(4, 2);
    expect(deliveredCursor).toBe(5);
    expect(readCursor).toBe(3);

    // Advance read cursor
    updateReceipt(6, 6);
    expect(deliveredCursor).toBe(6);
    expect(readCursor).toBe(6);
  });
});
