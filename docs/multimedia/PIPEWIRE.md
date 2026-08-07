# PipeWire Configuration Guide

Detailed guide to SANCHALA OS PipeWire configuration.

## Configuration Structure

```
/etc/pipewire/
├── pipewire.conf.d/
│   ├── 10-sanchala-defaults.conf    # Core settings
│   ├── 20-sanchala-pro-audio.conf   # Low-latency config
│   ├── 30-sanchala-alsa.conf        # ALSA settings
│   ├── 40-sanchala-bluetooth.conf   # Bluetooth codecs
│   ├── 50-sanchala-pulse.conf       # PulseAudio compat
│   └── 60-sanchala-screencast.conf  # Screen capture
└── pipewire-pulse.conf.d/
    └── (PulseAudio-specific overrides)

/etc/wireplumber/
├── main.lua.d/
│   ├── 50-sanchala-policy.lua       # Session policy
│   ├── 51-sanchala-alsa.lua         # ALSA rules
│   └── 52-sanchala-camera.lua       # Camera rules
└── bluetooth.lua.d/
    └── 50-sanchala-bluetooth.lua    # Bluetooth rules
```

## Core Settings Explained

### Sample Rate

```conf
default.clock.rate = 48000
default.clock.allowed-rates = [ 44100 48000 88200 96000 176400 192000 ]
```

- **48000 Hz**: Default, works with most content
- **44100 Hz**: CD quality, music
- **96000+ Hz**: Pro audio, high-resolution

PipeWire automatically switches rates when needed.

### Quantum (Buffer Size)

```conf
default.clock.quantum = 256
default.clock.min-quantum = 32
default.clock.max-quantum = 2048
```

The quantum determines latency:
- **Latency (ms)** = quantum / sample_rate × 1000
- **256 @ 48kHz** = 5.33ms (desktop default)
- **64 @ 48kHz** = 1.33ms (pro audio)

Lower quantum = lower latency but higher CPU usage.

## Per-Application Rules

### Setting App-Specific Latency

In `/etc/pipewire/pipewire.conf.d/50-sanchala-pulse.conf`:

```conf
pulse.rules = [
    {
        matches = [
            { application.process.binary = "your-app" }
        ]
        actions = {
            update-props = {
                node.latency = 128/48000
            }
        }
    }
]
```

### Match Patterns

```conf
# By binary name
{ application.process.binary = "firefox" }

# By application name
{ application.name = "VLC media player" }

# By media role
{ media.role = "game" }

# Regex pattern
{ application.process.binary = "~.*steam.*" }
```

## ALSA Device Configuration

### USB Audio Interfaces

For professional USB interfaces, lower latency is possible:

```lua
-- /etc/wireplumber/main.lua.d/51-sanchala-alsa.lua
{
    matches = {
        { { "device.name", "matches", "*Focusrite*" } },
    },
    apply_properties = {
        ["api.alsa.period-size"] = 64,
        ["api.alsa.headroom"] = 256,
        ["session.suspend-timeout-seconds"] = 0,
    },
}
```

### Disable Device Suspend

For pro audio, prevent device suspension:

```conf
session.suspend-timeout-seconds = 0
```

## Bluetooth Configuration

### Codec Priority

Edit `/etc/pipewire/pipewire.conf.d/40-sanchala-bluetooth.conf`:

```conf
bluez5.codecs = [ ldac aptx_hd aptx aac sbc_xq sbc ]
```

### LDAC Quality Modes

```conf
bluez5.a2dp.ldac.quality = auto    # Adaptive
bluez5.a2dp.ldac.quality = hq      # High quality (990kbps)
bluez5.a2dp.ldac.quality = sq      # Standard (660kbps)
bluez5.a2dp.ldac.quality = mq      # Mobile (330kbps)
```

## Real-Time Priority

### RTKit (Default)

```conf
{ name = libpipewire-module-rtkit
    args = {
        nice.level = -11
        rt.prio = 88
        rt.time.soft = -1
        rt.time.hard = -1
    }
}
```

### Direct RT (Pro Audio)

For lower latency, use direct RT scheduling:

```conf
{ name = libpipewire-module-rt
    args = {
        nice.level = -19
        rt.prio = 95
        rt.time.soft = 2000000
        rt.time.hard = 2000000
    }
}
```

Requires user in `realtime` group.

## Monitoring & Debugging

### PipeWire Top

```bash
pw-top
```

Shows real-time stats: quantum, rate, xruns, CPU usage.

### Dump Configuration

```bash
# Show all settings
pw-cli dump

# Show specific node
pw-cli info <node-id>
```

### Debug Logging

```bash
# Enable debug output
PIPEWIRE_DEBUG=3 pipewire

# WirePlumber debug
WIREPLUMBER_DEBUG=3 wireplumber
```

## Common Customizations

### Force Specific Sample Rate

```bash
# Temporary
pw-metadata -n settings 0 clock.force-rate 48000

# Permanent - add to config
context.properties = {
    default.clock.rate = 48000
}
```

### Disable Resampling

For bit-perfect playback:

```conf
stream.properties = {
    resample.disable = true
}
```

### Increase Buffer for Stability

If experiencing crackling:

```conf
context.properties = {
    default.clock.quantum = 512
    default.clock.min-quantum = 256
}
```
