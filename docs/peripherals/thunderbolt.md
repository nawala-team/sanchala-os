# Sanchala OS - Thunderbolt & USB4 Security Guide

Secure Thunderbolt device management with user-controlled authorization.

## Understanding Thunderbolt Security

Thunderbolt provides PCIe-level access enabling:
- **High bandwidth**: 40 Gbps (TB3/USB4) to 80 Gbps (TB4)
- **Direct Memory Access (DMA)**: Devices can read/write system memory

⚠️ **Security Warning**: DMA enables powerful attacks. A malicious device can read encryption keys or inject code—even on a locked system.

---

## Security Levels

| Level | Description | Recommendation |
|-------|-------------|----------------|
| `none` | Auto-authorize all | ❌ Insecure |
| `user` | User must authorize | ✅ Desktop default |
| `secure` | User + key verification | ✅ Laptops |
| `dponly` | DisplayPort only, no PCIe | 🔒 High security |

### Check Current Level

```bash
cat /sys/bus/thunderbolt/devices/domain0/security
```

Security level is set in BIOS/UEFI settings.

---

## Managing Devices

### Using boltctl

```bash
# List all devices
boltctl list

# Authorize device (temporary)
boltctl authorize DEVICE-UUID

# Enroll device (permanent, auto-authorize future connections)
boltctl enroll DEVICE-UUID

# Forget a device
boltctl forget DEVICE-UUID

# Device details
boltctl info DEVICE-UUID
```

### KDE Integration

**System Settings → Hardware → Thunderbolt**

- View connected devices
- Authorize new devices
- Manage trusted devices

---

## Common Devices

### Thunderbolt Docks

Docks are generally safe. Recommended:
- CalDigit TS3 Plus / TS4
- OWC Thunderbolt Dock
- Dell WD19TB / WD22TB4

```bash
# Enroll dock for auto-authorization
boltctl enroll --policy auto DOCK-UUID
```

### External GPUs (eGPU)

eGPUs require manual authorization:

1. Connect eGPU enclosure
2. Authorize in System Settings
3. Log out and back in
4. Check detection:
```bash
lspci | grep -i vga
```

### Thunderbolt Displays

Work automatically, even with `dponly` security (DisplayPort tunneling only).

---

## Pre-Authorizing Devices

Add trusted device UUIDs to `/etc/sanchala/thunderbolt-authorized.conf`:

```conf
# CalDigit TS4
xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

---

## Troubleshooting

### Device Not Detected

```bash
# Check controller
lspci | grep -i thunderbolt

# Check kernel messages
dmesg | grep -i thunderbolt

# Restart bolt daemon
sudo systemctl restart bolt
```

### Authorization Fails

```bash
# Manual authorization
echo 1 | sudo tee /sys/bus/thunderbolt/devices/DEVICE/authorized
```

### Device Disconnects

```bash
# Disable power management
echo on | sudo tee /sys/bus/thunderbolt/devices/domain0/power/control
```

### Firmware Updates

```bash
fwupdmgr get-updates
fwupdmgr update
```
