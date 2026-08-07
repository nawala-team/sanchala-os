# 🔊 SANCHALA OS - Audio System Documentation

## Overview

Sanchala OS features a best-in-class Linux audio experience built on PipeWire with WirePlumber session management:

- **Low-latency audio** for gaming and music production
- **High-quality Bluetooth codecs** (LDAC, aptX HD, aptX, AAC)
- **Per-application volume control**
- **Smart audio routing** between devices
- **System-wide equalizer** with presets
- **Full PulseAudio/JACK compatibility**

---

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                 SANCHALA AUDIO STACK                        │
├─────────────────────────────────────────────────────────────┤
│  Applications (Firefox, VLC, Discord, Games)                │
│                          │                                  │
│                          ▼                                  │
│  ┌─────────────────────────────────────────────────────┐   │
│  │         PipeWire-Pulse (PulseAudio Server)          │   │
│  └─────────────────────────────────────────────────────┘   │
│                          │                                  │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  PipeWire (Graph Engine, Mixing, Filter Chains)     │   │
│  └─────────────────────────────────────────────────────┘   │
│                          │                                  │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  WirePlumber (Session Mgmt, Policy, Per-app Vol)    │   │
│  └─────────────────────────────────────────────────────┘   │
│                          │                                  │
│  ┌──────────┬────────────┬────────────┬────────────────┐   │
│  │   ALSA   │  Bluetooth │    HDMI    │   USB Audio    │   │
│  └──────────┴────────────┴────────────┴────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

---

## Configuration Files

| Location | Purpose |
|----------|---------|
| `/etc/pipewire/pipewire.conf` | Main PipeWire configuration |
| `/etc/pipewire/pipewire-pulse.conf` | PulseAudio compatibility |
| `/etc/wireplumber/wireplumber.conf` | WirePlumber master config |
| `/etc/wireplumber/main.lua.d/` | ALSA device rules |
| `/etc/wireplumber/bluetooth.lua.d/` | Bluetooth codecs |
| `/etc/wireplumber/policy.lua.d/` | Audio policies |
| `/etc/sanchala/audio/` | Sanchala audio settings |

---

## Bluetooth Codecs (Priority Order)

| Codec | Bitrate | Quality | Use Case |
|-------|---------|---------|----------|
| **LDAC** | 990 kbps | Excellent | Sony headphones |
| **aptX HD** | 576 kbps | Very Good | 24-bit audio |
| **aptX** | 352 kbps | Good | Low latency |
| **AAC** | 256 kbps | Good | Apple devices |
| **SBC-XQ** | 345 kbps | Good | Enhanced SBC |
| **SBC** | 198 kbps | Fair | Universal fallback |

---

## EQ Presets

| Preset | Use Case |
|--------|----------|
| `flat` | Reference, no processing |
| `speakers-balanced` | Laptop/desktop speakers |
| `headphones-flat` | Neutral headphone listening |
| `bass-boost` | EDM, Hip-Hop |
| `vocal-clarity` | Podcasts, audiobooks |
| `gaming` | Footsteps, positional audio |
| `movie` | Cinematic experience |
| `classical` | Orchestral music |
| `rock` | Punchy, aggressive |

---

## Command-Line Tool

```bash
sanchala-audio volume get       # Show volume
sanchala-audio volume set 70    # Set to 70%
sanchala-audio mute             # Toggle mute
sanchala-audio sinks            # List outputs
sanchala-audio eq list          # List EQ presets
sanchala-audio bt status        # Bluetooth status
sanchala-audio restart          # Restart audio
```

---

## Troubleshooting

```bash
# Check services
systemctl --user status pipewire wireplumber

# Restart audio
sanchala-audio restart

# Check devices
wpctl status
```

**Document Version:** 1.0 | Phase 2
