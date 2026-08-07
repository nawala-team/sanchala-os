# 🔵 SANCHALA OS - Bluetooth Documentation

## Overview

Sanchala OS delivers an Apple-like Bluetooth experience on Linux:

- **Instant pairing** - Quick-pair mode for easy setup
- **Auto-reconnect** - Devices reconnect after sleep/boot
- **High-quality audio** - LDAC, aptX HD, AAC codecs
- **Battery reporting** - See headphone battery in system tray
- **BLE support** - Fitness trackers, smart home devices

---

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                 SANCHALA BLUETOOTH STACK                    │
├─────────────────────────────────────────────────────────────┤
│  Applications (Settings, Audio Apps, File Transfer)         │
│                          │                                  │
│  ┌─────────────────────────────────────────────────────┐   │
│  │     sanchala-bluetooth CLI / KDE Bluetooth GUI      │   │
│  └─────────────────────────────────────────────────────┘   │
│                          │                                  │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              BlueZ 5.x (Bluetooth Daemon)           │   │
│  │  • Device management  • Pairing  • Profiles         │   │
│  └─────────────────────────────────────────────────────┘   │
│                          │                                  │
│  ┌──────────────┬────────────────┬─────────────────────┐   │
│  │  A2DP/AVRCP  │   HFP/HSP      │      BLE/GATT       │   │
│  │  (Audio)     │   (Calls)      │   (Low Energy)      │   │
│  └──────────────┴────────────────┴─────────────────────┘   │
│                          │                                  │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  PipeWire + WirePlumber (Audio Routing & Codecs)    │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

---

## Configuration Files

| File | Purpose |
|------|---------|
| `/etc/bluetooth/main.conf` | Main BlueZ configuration |
| `/etc/bluetooth/audio.conf` | Audio profiles & codecs |
| `/etc/bluetooth/input.conf` | Keyboards, mice, controllers |
| `/etc/wireplumber/bluetooth.lua.d/` | PipeWire Bluetooth rules |
| `/etc/udev/rules.d/70-sanchala-bluetooth.rules` | Device permissions |

---

## Supported Profiles

| Profile | Purpose | Quality |
|---------|---------|---------|
| **A2DP** | Music streaming | Stereo, high-quality |
| **AVRCP** | Media controls | Play/pause/skip |
| **HFP** | Hands-free calls | 16kHz wide-band |
| **HSP** | Headset legacy | 8kHz narrow-band |
| **HID** | Input devices | Keyboards, mice |
| **OBEX** | File transfer | Send/receive files |
| **PAN** | Network tethering | Internet sharing |

---

## Quick Start

### Pair a New Device

```bash
# Method 1: Quick-pair wizard
sanchala-bluetooth quick-pair

# Method 2: Manual pairing
sanchala-bluetooth scan 15
sanchala-bluetooth pair AA:BB:CC:DD:EE:FF
sanchala-bluetooth connect AA:BB:CC:DD:EE:FF
```

### Check Connected Devices

```bash
sanchala-bluetooth list connected
sanchala-bluetooth info
sanchala-bluetooth battery
```

---

## Audio Codecs

Sanchala automatically selects the best codec:

| Codec | Bitrate | Latency | Best For |
|-------|---------|---------|----------|
| **LDAC** | 990 kbps | ~200ms | Sony headphones, hi-res |
| **aptX HD** | 576 kbps | ~150ms | 24-bit audio |
| **aptX** | 352 kbps | ~40ms | Low-latency gaming |
| **AAC** | 256 kbps | ~150ms | Apple devices |
| **SBC-XQ** | 345 kbps | ~150ms | Enhanced standard |
| **LC3** | Variable | ~20ms | LE Audio (BT 5.2+) |

### Force a Specific Codec

```bash
# Check current codec
pactl list cards | grep -A5 bluez

# Set codec (if device supports it)
sanchala-bluetooth audio codec AA:BB:CC:DD:EE:FF ldac
```

---

## Troubleshooting

### Device Won't Pair

```bash
# Remove and re-pair
sanchala-bluetooth remove AA:BB:CC:DD:EE:FF
sanchala-bluetooth pair AA:BB:CC:DD:EE:FF
```

### Audio Dropouts

1. Move closer to the device
2. Check for WiFi interference (2.4GHz)
3. Try a lower-quality codec:
   ```bash
   sanchala-bluetooth audio codec MAC aptx
   ```

### No Battery Reporting

Requires BlueZ 5.65+ with experimental features:
```bash
# Verify experimental mode
systemctl cat bluetooth | grep experimental
```

---

**Document Version:** 1.0 | Phase 2
