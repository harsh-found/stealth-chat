import crypto from 'crypto';

export function uuidv7(): string {
  const bytes = crypto.randomBytes(16);
  const now = Date.now();

  // Timestamp: 48 bits
  bytes.writeUIntBE(Math.floor(now / 0x100000000), 0, 2);
  bytes.writeUInt32BE(now >>> 0, 2);

  // Version 7: 0111
  bytes[6] = (bytes[6] & 0x0f) | 0x70;
  // Variant: 10xx
  bytes[8] = (bytes[8] & 0x3f) | 0x80;

  const hex = bytes.toString('hex');
  return `${hex.slice(0, 8)}-${hex.slice(8, 12)}-${hex.slice(12, 16)}-${hex.slice(16, 20)}-${hex.slice(20)}`;
}
