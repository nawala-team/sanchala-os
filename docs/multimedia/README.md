# SANCHALA OS Multimedia Documentation

Complete guide to audio, video, and multimedia capabilities in SANCHALA OS.

## Overview

SANCHALA OS uses a modern PipeWire-based multimedia stack designed for:
- **Pro-audio workflows** with ultra-low latency
- **Desktop audio** with automatic device management
- **Hardware video acceleration** for efficient playback
- **Screen recording/streaming** via Wayland portals
- **Bluetooth audio** with high-quality codec support

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Applications                          │
│  (Firefox, VLC, OBS, Ardour, Discord, Games, etc.)      │
├─────────────────────────────────────────────────────────┤
│                    PipeWire Core                         │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐       │
│  │ PulseAudio  │ │    JACK     │ │    ALSA     │       │
│  │ Compat Layer│ │ Compat Layer│ │ Compat Layer│       │
│  └─────────────┘ └─────────────┘ └─────────────┘       │
├─────────────────────────────────────────────────────────┤
│                   WirePlumber                            │
│              (Session/Policy Manager)                    │
├─────────────────────────────────────────────────────────┤
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐   │
│  │  ALSA    │ │ BlueZ5   │ │  V4L2    │ │ libcamera│   │
│  │ Devices  │ │Bluetooth │ │ Cameras  │ │ Cameras  │   │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘   │
└─────────────────────────────────────────────────────────┘
```

## Audio Modes

SANCHALA OS provides four audio profiles optimized for different use cases:

| Mode | Quantum | Latency | Use Case |
|------|---------|---------|----------|
| Desktop | 256 | ~5.33ms | Daily use, media playback |
| Pro | 64 | ~1.33ms | Music production, recording |
| Gaming | 128 | ~2.67ms | Games, voice chat |
| Powersave | 512 | ~10.67ms | Battery life priority |

### Switching Modes

```bash
# Switch to pro audio mode
sanchala-audio-mode pro

# Check current status
sanchala-audio-mode status

# Switch back to desktop mode
sanchala-audio-mode desktop
```

## Documentation Index

- [PipeWire Configuration](PIPEWIRE.md) - Detailed PipeWire settings
- [Hardware Acceleration](HWACCEL.md) - VA-API, VDPAU setup
- [Pro Audio Guide](PRO-AUDIO.md) - Music production setup
- [Troubleshooting](TROUBLESHOOTING.md) - Common issues and fixes

## Quick Reference

### Check Audio Status
```bash
sanchala-audio-mode status
pw-top
```

### Verify Hardware Acceleration
```bash
vainfo
vdpauinfo
```

### Camera Detection
```bash
v4l2-ctl --list-devices
```
