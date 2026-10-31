import crypto from 'crypto';
import jwt from 'jsonwebtoken';

export interface UserTokenPayload {
  userId: string;
  deviceId: string;
  username: string;
}

export function signAccessToken(payload: UserTokenPayload, secret: string): string {
  return jwt.sign(payload, secret, { expiresIn: '15m' });
}

export function verifyAccessToken(token: string, secret: string): UserTokenPayload {
  return jwt.verify(token, secret) as UserTokenPayload;
}

export function generateRefreshToken(): string {
  return crypto.randomBytes(32).toString('hex');
}

export function hashToken(token: string): string {
  return crypto.createHash('sha256').update(token).digest('hex');
}

// Dev OTP Provider
const otpStore = new Map<string, { code: string; expiresAt: number }>();

export const otpProvider = {
  sendOtp(phone: string): string {
    const code = '123456'; // standard dev OTP
    otpStore.set(phone, {
      code,
      expiresAt: Date.now() + 5 * 60 * 1000,
    });
    return code;
  },

  verifyOtp(phone: string, code: string): boolean {
    const entry = otpStore.get(phone);
    if (!entry) return false;
    if (Date.now() > entry.expiresAt) {
      otpStore.delete(phone);
      return false;
    }
    const valid = entry.code === code;
    if (valid) {
      otpStore.delete(phone);
    }
    return valid;
  },
};
