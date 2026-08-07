# 🔧 SANCHALA OS - Input Troubleshooting

## Diagnostic Commands

### Check Device Detection

```bash
# List all input devices
libinput list-devices

# Show X11 input devices
xinput list

# Kernel input devices
cat /proc/bus/input/devices

# USB devices
lsusb
```

### Monitor Input Events

```bash
# libinput events (recommended)
sudo libinput debug-events

# Specific device
sudo libinput debug-events --device /dev/input/event5

# X11 events
xinput test "Device Name"

# Raw kernel events
sudo evtest /dev/input/event5
```

---

## Common Issues

### Touchpad Not Detected

**Symptoms:** No touchpad in settings, cursor doesn't move

**Solutions:**

1. Check if device exists:
```bash
libinput list-devices | grep -i touchpad
```

2. Load kernel module:
```bash
# For I2C touchpads
sudo modprobe i2c_hid_acpi

# For Synaptics
sudo modprobe psmouse
```

3. Check BIOS settings - ensure touchpad is enabled

4. Try blacklisting conflicting modules:
```bash
echo "blacklist i2c_hid" | sudo tee /etc/modprobe.d/touchpad-fix.conf
sudo mkinitcpio -P
# Reboot
```

### Touchpad Detected But Not Working

**Check permissions:**
```bash
ls -la /dev/input/event*
# Should show group 'input'

# Add yourself to input group
sudo usermod -aG input $USER
# Log out and back in
```

### Gestures Not Working

1. Ensure touchégg is running:
```bash
systemctl --user status touchegg
```

2. Start touchégg:
```bash
systemctl --user enable --now touchegg
```

3. Check X11/Wayland compatibility:
   - Touchégg works on X11 and Wayland
   - Some features may differ

### Keyboard Layout Wrong

```bash
# Check current layout
setxkbmap -query

# Reset to US
setxkbmap us

# Check for stuck modifiers
xdotool key --clearmodifiers Escape
```

### IME Not Activating

```bash
# Verify environment
env | grep -i fcitx

# Restart fcitx5
fcitx5 -r -d

# Run diagnostics
fcitx5-diagnose
```

---

## Device-Specific Fixes

### Apple Magic Trackpad

```bash
# Pair via Bluetooth settings
# If connection drops, remove and re-pair

# Adjust sensitivity
echo "options hid_magicmouse scroll_speed=45" | \
  sudo tee /etc/modprobe.d/magicmouse.conf
```

### Lenovo TrackPoint

```bash
# Adjust sensitivity
echo 200 | sudo tee /sys/devices/platform/i8042/serio1/serio2/sensitivity
echo 100 | sudo tee /sys/devices/platform/i8042/serio1/serio2/speed

# Make permanent via udev rule
```

### Gaming Mouse Not Detected

```bash
# Add udev rule for device
# Check vendor/product ID
lsusb

# Create rule
echo 'SUBSYSTEM=="usb", ATTR{idVendor}=="XXXX", MODE="0666"' | \
  sudo tee /etc/udev/rules.d/99-gaming-mouse.rules
sudo udevadm control --reload-rules
```

---

## Log Files

```bash
# System logs
journalctl -b | grep -i input
journalctl -b | grep -i touchpad
journalctl -b | grep -i libinput

# Xorg logs
cat /var/log/Xorg.0.log | grep -i input

# dmesg
dmesg | grep -i hid
dmesg | grep -i input
```

---

## Reset to Defaults

### Reset Touchpad Settings

```bash
# Remove user config
rm ~/.config/touchpadxlibinputrc
rm ~/.config/kcminputrc

# Restart KDE
kquitapp5 plasmashell && kstart5 plasmashell
```

### Reset Keyboard Settings

```bash
# Reset XKB
setxkbmap -layout us -option

# Clear KDE keyboard settings
rm ~/.config/kxkbrc
```

### Reset IME

```bash
# Remove fcitx5 user config
rm -rf ~/.config/fcitx5
rm -rf ~/.local/share/fcitx5

# Restart
fcitx5 -r -d
```

---

## Getting Help

If issues persist:

1. **Collect diagnostics:**
```bash
libinput list-devices > ~/input-devices.txt
fcitx5-diagnose > ~/ime-diagnose.txt
journalctl -b | grep -i input > ~/input-logs.txt
```

2. **Check Arch Wiki:** https://wiki.archlinux.org/title/Libinput

3. **Report bugs:** Include device info, kernel version, and logs
