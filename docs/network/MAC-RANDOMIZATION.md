# 🎭 SANCHALA OS - MAC Address Randomization

## Overview

MAC randomization prevents network tracking by changing your device's hardware identifier.

---

## 🔒 Privacy Modes

| Mode | Behavior | Best For |
|------|----------|----------|
| **stable** | Same random MAC per network | Daily use (default) |
| **random** | New random MAC each connection | Public WiFi, hotels |
| **permanent** | Use real hardware MAC | Enterprise networks |

---

## ⚙️ Configuration

### System Default
Location: `/etc/NetworkManager/conf.d/10-sanchala-privacy.conf`

```ini
[device]
wifi.scan-rand-mac-address=yes

[connection]
wifi.cloned-mac-address=stable
ethernet.cloned-mac-address=stable
```

### Per-Connection Override

```bash
# Use random MAC for specific connection
nmcli connection modify "CoffeeShop" wifi.cloned-mac-address random

# Use permanent MAC (enterprise network)
nmcli connection modify "CorpWiFi" wifi.cloned-mac-address permanent

# Check current setting
nmcli connection show "ConnectionName" | grep mac
```

---

## 🔍 Verify Randomization

```bash
# Check current MAC
ip link show wlan0 | grep ether

# Compare with hardware MAC
cat /sys/class/net/wlan0/address

# If different, randomization is working!
```

---

## 📊 How It Works

```
┌────────────────────────────────────────────────────────────────┐
│                    MAC RANDOMIZATION                           │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  Stable Mode (per-network):                                    │
│  ┌──────────┐     ┌──────────┐     ┌──────────┐              │
│  │ Network A│     │ Network B│     │ Network A│              │
│  │ MAC: X1  │     │ MAC: Y2  │     │ MAC: X1  │              │
│  └──────────┘     └──────────┘     └──────────┘              │
│       ↑               ↑               ↑                       │
│  Same network = Same MAC    Different network = Different MAC │
│                                                                │
│  Random Mode:                                                  │
│  ┌──────────┐     ┌──────────┐     ┌──────────┐              │
│  │ Connect 1│     │ Connect 2│     │ Connect 3│              │
│  │ MAC: A1  │     │ MAC: B2  │     │ MAC: C3  │              │
│  └──────────┘     └──────────┘     └──────────┘              │
│       ↑               ↑               ↑                       │
│           Every connection = New random MAC                   │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

---

## ⚠️ Troubleshooting

### MAC Randomization Not Working
```bash
# Ensure NetworkManager is managing the interface
nmcli device status

# Check if config is loaded
nmcli general | grep -i running
```

### Network Requires Real MAC
```bash
# Temporarily use permanent MAC
nmcli connection modify "NetworkName" wifi.cloned-mac-address permanent
nmcli connection up "NetworkName"
```

**Document Version:** 1.0 | **Author:** Network Stack Engineer
