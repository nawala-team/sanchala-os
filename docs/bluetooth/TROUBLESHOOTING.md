# Bluetooth Troubleshooting Guide

## Common Issues

### 1. Bluetooth Adapter Not Found

```bash
# Check if adapter exists
lsusb | grep -i bluetooth
hciconfig -a

# Load Bluetooth modules
sudo modprobe btusb
sudo modprobe bluetooth

# Start service
sudo systemctl start bluetooth
sudo systemctl enable bluetooth
```

### 2. Device Won't Pair

```bash
# Reset pairing
sanchala-bluetooth remove AA:BB:CC:DD:EE:FF

# Restart Bluetooth
sudo systemctl restart bluetooth

# Try again in bluetoothctl
bluetoothctl
> power on
> agent on
> default-agent
> scan on
> pair AA:BB:CC:DD:EE:FF
> trust AA:BB:CC:DD:EE:FF
> connect AA:BB:CC:DD:EE:FF
```

### 3. Audio Stuttering/Dropouts

**Causes:**
- WiFi interference (2.4GHz)
- USB 3.0 interference
- Weak signal

**Solutions:**
```bash
# Use 5GHz WiFi if possible

# Move USB 3.0 devices away from BT adapter

# Try lower quality codec
sanchala-bluetooth audio codec MAC sbc

# Increase buffer
# In /etc/wireplumber/bluetooth.lua.d/
["api.bluez5.latency-offset"] = 10000
```

### 4. No Sound from Bluetooth Device

```bash
# Check PipeWire
wpctl status

# Set as default sink
wpctl set-default <sink-id>

# Restart audio
systemctl --user restart pipewire wireplumber
```

### 5. Microphone Not Working (Calls)

```bash
# Switch to HFP profile
pactl set-card-profile bluez_card.XX_XX_XX a2dp-sink-aac headset-head-unit

# Check input
wpctl status | grep -A5 "Audio/Source"
```

### 6. Device Disconnects Randomly

```bash
# Disable power saving for adapter
# Check /etc/udev/rules.d/70-sanchala-bluetooth.rules

# Increase supervision timeout
# In /etc/bluetooth/main.conf:
LinkSupervisionTimeout = 10
```

### 7. Battery Level Not Showing

```bash
# Requires BlueZ 5.65+ experimental
# Check service config
cat /etc/systemd/system/bluetooth.service.d/10-sanchala.conf

# Should have: --experimental --plugin=battery
```

---

## Diagnostic Commands

```bash
# Adapter info
bluetoothctl show

# Device info
bluetoothctl info AA:BB:CC:DD:EE:FF

# Audio cards
pactl list cards | grep -A20 bluez

# WirePlumber status
wpctl status

# BlueZ logs
journalctl -u bluetooth -f

# dmesg Bluetooth
dmesg | grep -i bluetooth
```

---

## Reset Everything

```bash
# Nuclear option - reset all Bluetooth
sudo systemctl stop bluetooth
sudo rm -rf /var/lib/bluetooth/*
sudo systemctl start bluetooth

# Re-pair all devices
```

---

**Document Version:** 1.0 | Phase 2
