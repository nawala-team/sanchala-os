# 📱 SANCHALA OS - Touchscreen Configuration

## Overview

Sanchala OS provides full touchscreen support for:
- Laptop convertibles (2-in-1 devices)
- All-in-one PCs
- External USB touchscreens
- Wacom/pen display tablets

---

## Default Behavior

| Feature | Status |
|---------|--------|
| Tap to click | ✅ Enabled |
| Multi-touch gestures | ✅ Via Touchégg |
| Palm rejection | ✅ Enabled |
| On-screen keyboard | ✅ Available |

---

## Calibration

### Automatic Calibration

Most modern touchscreens are pre-calibrated. If touch accuracy is off:

```bash
# Install calibration tool
sudo pacman -S xinput_calibrator

# Run calibration (X11)
xinput_calibrator
```

### Manual Calibration Matrix

For Wayland or advanced needs, edit the calibration matrix:

```bash
# Get device ID
xinput list | grep -i touch

# Apply calibration matrix
xinput set-prop "Device Name" "libinput Calibration Matrix" 1 0 0 0 1 0 0 0 1
```

**Matrix format:** `[a b c d e f 0 0 1]`
- Standard: `1 0 0 0 1 0 0 0 1` (identity)
- Rotate 90°: `0 -1 1 1 0 0 0 0 1`
- Rotate 180°: `-1 0 1 0 -1 1 0 0 1`
- Rotate 270°: `0 1 0 -1 0 1 0 0 1`

---

## Multi-Touch Gestures

Touchscreen gestures work via Touchégg:

| Gesture | Action |
|---------|--------|
| 3-finger swipe up | Overview |
| 3-finger swipe left/right | Switch desktop |
| 4-finger tap | App launcher |
| Pinch (2 fingers) | Zoom in apps |

---

## On-Screen Keyboard

### Maliit Keyboard (Recommended for touch)

```bash
sudo pacman -S maliit-keyboard maliit-framework

# Enable for KDE
systemctl --user enable --now maliit-server
```

### KDE Virtual Keyboard

Built into KDE Plasma:
```
System Settings → Input Devices → Virtual Keyboard
```

Select "Maliit" as the virtual keyboard.

---

## Tablet Mode (2-in-1 Devices)

### Automatic Detection

Sanchala OS can detect when laptop is in tablet mode:

```bash
# Check tablet mode switch
cat /sys/class/input/*/name | grep -i tablet
libinput debug-events | grep -i switch
```

### Configuring Tablet Mode Actions

Edit KWin rules or use `systemd` triggers:

```bash
# Example: Disable touchpad in tablet mode
# Create /etc/udev/rules.d/99-tablet-mode.rules
ACTION=="change", SUBSYSTEM=="input", ATTR{name}=="*Tablet Mode*", \
  RUN+="/usr/local/bin/sanchala-tablet-mode.sh"
```

---

## Screen Rotation

### Automatic Rotation (accelerometer)

```bash
# Install iio-sensor-proxy
sudo pacman -S iio-sensor-proxy

# Enable service
sudo systemctl enable --now iio-sensor-proxy

# KDE handles rotation automatically when enabled:
# System Settings → Display → Orientation: Automatic
```

### Manual Rotation

```bash
# Using kscreen
kscreen-doctor output.eDP-1.rotation.left

# Using xrandr (X11)
xrandr --output eDP-1 --rotate left
```

---

## Troubleshooting

### Touch Not Working

```bash
# Check device detection
xinput list | grep -i touch
libinput list-devices | grep -i touch

# Check permissions
ls -la /dev/input/event*
groups  # Should include 'input'
```

### Touch Offset After Rotation

Recalibrate after rotation or use coordinate transformation:

```bash
# Get correct matrix for rotation
# Apply via xinput or libinput
```

### Palm Rejection Issues

Adjust palm threshold in quirks file:
```
/etc/libinput/local-overrides.quirks
```

Add device-specific `AttrPalmPressureThreshold` value.

---

## Device-Specific Notes

### Microsoft Surface

```bash
# Install Surface kernel and IPTSD
sudo pacman -S linux-surface iptsd

# Enable touch daemon
sudo systemctl enable --now iptsd
```

### Wacom Display Tablets

Use both touch and pen:
```bash
# Enable/disable touch
xsetwacom set "Wacom device touch" Touch on
xsetwacom set "Wacom device touch" Touch off
```
