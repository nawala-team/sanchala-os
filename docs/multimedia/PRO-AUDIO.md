# Pro Audio Guide

Setting up SANCHALA OS for music production and professional audio work.

## Prerequisites

### 1. User Groups

```bash
sudo usermod -aG audio,realtime $USER
# Log out and back in
```

### 2. Realtime Limits

Already configured in SANCHALA OS at `/etc/security/limits.d/99-realtime.conf`:

```
@realtime - rtprio 98
@realtime - memlock unlimited
```

### 3. Switch to Pro Mode

```bash
sanchala-audio-mode pro
```

## Latency Targets

| Use Case | Quantum | Latency | Notes |
|----------|---------|---------|-------|
| Monitoring | 64 | 1.33ms | USB interface recommended |
| Recording | 128 | 2.67ms | Safe for most hardware |
| Mixing | 256 | 5.33ms | Comfortable for long sessions |

## JACK Compatibility

PipeWire provides full JACK compatibility. JACK apps work automatically:

```bash
# Start any JACK application
ardour7
bitwig-studio
carla
```

### Connection Management

```bash
# GUI tools
qjackctl
helvum

# Command line
pw-jack jack_lsp
pw-jack jack_connect
```

## USB Audio Interfaces

### Recommended Interfaces

Tested with low latency on SANCHALA OS:
- Focusrite Scarlett series
- PreSonus AudioBox
- MOTU M-series
- RME Babyface

### Interface-Specific Settings

WirePlumber automatically applies optimized settings for known interfaces.

Custom settings in `/etc/wireplumber/main.lua.d/51-sanchala-alsa.lua`.

## Monitoring Performance

### Real-time Stats

```bash
pw-top
```

Watch for:
- **Quantum**: Should match your mode
- **Rate**: Sample rate
- **Wait/Busy**: CPU timing
- **XRuns**: Audio dropouts (should be 0)

### Xrun Tracking

```bash
# Check for xruns
pw-cli info all | grep xrun
```

## Optimization Tips

1. **Disable Wi-Fi power saving** during sessions
2. **Use wired ethernet** instead of Wi-Fi
3. **Close unnecessary applications**
4. **Use USB 3.0 ports** for audio interfaces
5. **Avoid USB hubs** - connect interface directly

## Recommended Software

### DAWs
- Ardour
- Bitwig Studio
- REAPER
- LMMS

### Plugins
- Carla (plugin host)
- LSP Plugins
- Calf Studio
- ZynAddSubFX

### Utilities
- QjackCtl
- Helvum (connection graph)
- EasyEffects (system-wide EQ)
