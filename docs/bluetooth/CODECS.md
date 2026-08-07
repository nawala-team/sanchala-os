# Bluetooth Audio Codec Guide

## Codec Comparison

### LDAC (Sony)
- **Bitrate:** 330/660/990 kbps
- **Quality:** Near CD quality at 990kbps
- **Latency:** ~200ms
- **Devices:** Sony headphones (WH-1000XM series, WF series)

```lua
-- Force high quality LDAC
["bluez5.a2dp.ldac.quality"] = "hq"  -- 990kbps
```

### aptX HD (Qualcomm)
- **Bitrate:** 576 kbps
- **Quality:** 24-bit audio support
- **Latency:** ~150ms
- **Devices:** Many Android phones, premium headphones

### aptX / aptX Low Latency
- **Bitrate:** 352 kbps
- **Quality:** CD-like quality
- **Latency:** 40ms (LL variant)
- **Best for:** Gaming, video sync

### AAC
- **Bitrate:** Up to 256 kbps VBR
- **Quality:** Good efficiency
- **Latency:** ~150ms
- **Devices:** Apple AirPods, iPhones

### SBC-XQ (Enhanced SBC)
- **Bitrate:** 345 kbps
- **Quality:** Better than standard SBC
- **Latency:** ~150ms
- **Note:** Universal, no licensing

### LC3 (LE Audio)
- **Bitrate:** Variable (16-345 kbps)
- **Quality:** Better than SBC at same bitrate
- **Latency:** ~20ms
- **Requires:** Bluetooth 5.2+

---

## Profile Switching

### A2DP vs HFP

| Feature | A2DP | HFP |
|---------|------|-----|
| Audio | Stereo | Mono |
| Sample Rate | 44.1-96kHz | 8-16kHz |
| Use | Music | Calls |
| Microphone | No | Yes |

Sanchala auto-switches when voice apps start.

### Manual Switch

```bash
# Switch to A2DP (music mode)
pactl set-card-profile bluez_card.XX_XX_XX_XX_XX_XX a2dp-sink

# Switch to HFP (call mode)  
pactl set-card-profile bluez_card.XX_XX_XX_XX_XX_XX headset-head-unit
```

---

## Latency Tuning

For gaming or video sync:

```lua
-- In /etc/wireplumber/bluetooth.lua.d/
["api.bluez5.latency-offset"] = -10000  -- Reduce by 10ms
```

---

**Document Version:** 1.0 | Phase 2
