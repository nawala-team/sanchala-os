# Audio Routing Profiles

## Overview

Sanchala OS automatically switches audio settings based on connected devices and running applications.

## Available Profiles

### Hardware-Triggered Profiles

| Profile | Trigger | Key Settings |
|---------|---------|--------------|
| **Speakers** | Default | Balanced EQ, bass boost +3dB |
| **Headphones** | 3.5mm jack | Flat EQ, crossfeed enabled |
| **USB Audio** | USB DAC | Bit-perfect, flat response |
| **HDMI** | HDMI/DP | Lip sync +50ms offset |
| **Bluetooth Headphones** | BT connect | LDAC preferred, auto-switch |
| **Bluetooth Speaker** | BT speaker | Latency -20ms, enhanced bass |

### Application-Triggered Profiles

| Profile | Trigger Apps | Key Settings |
|---------|--------------|--------------|
| **Gaming** | steam, lutris | 256 samples, spatial audio |
| **Communication** | discord, zoom | Echo cancel, AGC, noise suppression |
| **Production** | ardour, reaper | 64 samples, 96kHz, passthrough |

## Configuration

Profiles defined in:
```
/etc/sanchala/audio/routing-profiles/default.conf
```

### Profile Structure

```ini
[Profile:Gaming]
Name=Gaming Mode
Description=Optimized for low latency gaming
Priority=50
Trigger.Application=steam,lutris,wine

Latency.Target=low
Quantum=256
Rate=48000

EQ.Preset=gaming
Spatial.Enable=true
```

## Latency Targets

| Target | Quantum | Latency | Use Case |
|--------|---------|---------|----------|
| ultra-low | 64 | ~1.3ms | Production |
| low | 256 | ~5ms | Gaming |
| normal | 1024 | ~21ms | General |
| high | 2048 | ~43ms | HiFi music |

## Manual Profile Selection

```bash
# List profiles
sanchala-audio profiles

# Profile switching via GUI
# System Settings → Audio → Profile
```

## Profile Priority

Higher priority profiles override lower ones:
1. Communication (400) - Voice calls take precedence
2. Production (350) - DAW sessions
3. USB Audio (300) - External DAC
4. Bluetooth (250) - Wireless devices
5. Headphones (200) - Wired headphones
6. Gaming (50) - When games running
7. Speakers (100) - Default fallback
