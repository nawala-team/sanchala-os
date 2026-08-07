# Bluetooth Audio Configuration Guide

## High-Quality Codec Setup

Sanchala OS enables all premium Bluetooth codecs by default.

### Codec Priority

1. **LDAC** - Sony's high-resolution codec (up to 990kbps)
2. **aptX HD** - Qualcomm's 24-bit codec (576kbps)
3. **aptX** - Low-latency codec (352kbps)
4. **AAC** - Best for Apple devices (256kbps)
5. **SBC-XQ** - Enhanced standard codec (345kbps)
6. **SBC** - Universal fallback (198kbps)

### Configuration Location

```
/etc/wireplumber/bluetooth.lua.d/50-sanchala-bluetooth.lua
```

### Key Settings

```lua
-- Enable high-quality codecs
["bluez5.enable-sbc-xq"] = true
["bluez5.enable-msbc"] = true
["bluez5.enable-hw-volume"] = true

-- Codec priority order
["bluez5.codecs"] = "[ldac aptx_hd aptx aac sbc_xq sbc]"

-- LDAC quality: auto, hq (990kbps), sq (660kbps), mq (330kbps)
["bluez5.a2dp.ldac.quality"] = "auto"

-- Auto-switch between A2DP (music) and HFP (calls)
["bluez5.autoswitch-profile"] = true
```

### Profile Switching

| Profile | Use | Quality |
|---------|-----|---------|
| A2DP | Music playback | Stereo, high quality |
| HFP | Voice calls | Mono, 16kHz |
| HSP | Legacy headset | Mono, 8kHz |

The system automatically switches profiles when:
- Voice app starts → Switch to HFP
- Voice app stops → Switch back to A2DP

### Checking Active Codec

```bash
# Via pactl
pactl list cards | grep -A5 "bluez"

# Via bluetoothctl
bluetoothctl info <MAC_ADDRESS>
```

### Troubleshooting

**Codec not available:**
```bash
# Check BlueZ version (5.65+ recommended)
bluetoothctl --version

# Verify codec support
pactl list cards | grep "a]2dp.*codec"
```

**Poor audio quality:**
- Move closer to device
- Check for interference (WiFi, USB 3.0)
- Try forcing specific codec in config

**Connection drops:**
```bash
# Restart Bluetooth
sudo systemctl restart bluetooth
sanchala-audio restart
```
