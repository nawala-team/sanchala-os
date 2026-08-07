# Sanchala OS - Peripheral Support Guide

Complete documentation for hardware peripheral support including printers, scanners, USB devices, Thunderbolt, and external displays.

## Quick Reference

| Device Type | Auto-Detected | Config Location |
|-------------|---------------|-----------------|
| USB Storage | ✅ Yes | Auto-mount |
| Printers | ✅ Yes | System Settings → Printers |
| Scanners | ✅ Yes | Simple Scan / Skanlite |
| Thunderbolt | ⚠️ Auth required | System Settings → Thunderbolt |
| External Displays | ✅ Yes | System Settings → Display |
| Game Controllers | ✅ Yes | Ready to use |
| Android (MTP) | ✅ Yes | Dolphin sidebar |

## Documentation

- [Printer Setup Guide](printers.md) - CUPS configuration, drivers, troubleshooting
- [Thunderbolt Security](thunderbolt.md) - Device authorization, eGPU, docks
- [USB Devices](usb-devices.md) - Storage, MTP, controllers, serial devices
- [External Displays](displays.md) - Hotplug, DDC/CI, multi-monitor, HiDPI

## Common Tasks

### Print a Document
1. Connect printer (USB) or ensure network connectivity
2. Open document → File → Print
3. Select printer and print

### Connect Android Phone
1. Connect via USB cable
2. On phone: Select "File Transfer" (MTP)
3. Phone appears in Dolphin sidebar

### Authorize Thunderbolt Dock
1. Connect dock
2. Notification appears
3. Click to authorize in System Settings

### Add External Monitor
1. Connect via HDMI/DP/USB-C
2. Auto-detected in 2-3 seconds
3. Configure in System Settings → Display

## Troubleshooting Quick Fixes

```bash
# Restart printing
sudo systemctl restart cups

# Rescan USB devices
sudo udevadm trigger

# Restart Thunderbolt daemon
sudo systemctl restart bolt

# Force display rescan
echo 1 | sudo tee /sys/class/drm/card0/device/rescan
```

## Getting Help

- Check device-specific docs in this folder
- [Arch Wiki](https://wiki.archlinux.org) for detailed guides
- Sanchala OS community support
