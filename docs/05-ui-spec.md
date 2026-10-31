# 05 UI & Design Specification: Stealth Dark

## Palette & Design Tokens
- Background Base: `#101010`
- Surface Card: `#1C1C1C`
- Border & Subtle Dividers: `#262626`
- Outgoing Bubble: `#2563EB` (Electric Blue) or `#1E3A8A`
- Incoming Bubble: `#1F1F1F`
- Text Primary: `#FFFFFF`
- Text Secondary: `#9CA3AF`
- Accent presets: Emerald `#10B981`, Purple `#8B5CF6`, Amber `#F59E0B`, Crimson `#EF4444`

## Micro-Interactions
- Swipe-to-reply: Horizontal swipe threshold with haptic feedback.
- Morphing send button: Mic icon morphs to send paperplane smoothly.
- Zero-flicker keyboard tray: Cached keyboard height prevents layout jumps when opening emoji/media tray.
- Waveform voice notes: 64 pre-sampled amplitude bars rendered via `CustomPainter`.
