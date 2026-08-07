# ✍️ SANCHALA OS - Stylus & Graphics Tablet Guide

## Supported Devices

Sanchala OS provides out-of-the-box support for:

| Brand | Support Level | Driver |
|-------|--------------|--------|
| Wacom | ⭐⭐⭐⭐⭐ Full | wacom (kernel + libwacom) |
| Huion | ⭐⭐⭐⭐ Good | digimend / hid-uclogic |
| XP-Pen | ⭐⭐⭐⭐ Good | digimend |
| Gaomon | ⭐⭐⭐ Fair | digimend |
| Ugee | ⭐⭐⭐ Fair | digimend |

---

## Quick Setup

### Wacom Tablets

Wacom devices work automatically. To configure:

```bash
# List devices
xsetwacom list devices

# Get device options
xsetwacom get "Wacom Intuos Pro M Pen stylus" all

# Map to specific monitor (for multi-monitor setups)
xsetwacom set "Wacom Intuos Pro M Pen stylus" MapToOutput HEAD-0
```

### Huion / XP-Pen / Other Tablets

1. Install digimend drivers:
```bash
sudo pacman -S digimend-kernel-drivers-dkms
```

2. Reboot or reload modules:
```bash
sudo modprobe hid-uclogic
```

---

## Configuration

### KDE Wacom Settings

```
System Settings → Input Devices → Drawing Tablet
```

Features:
- Pressure curve adjustment
- Button mapping
- Area mapping
- Per-application profiles

### Command Line (xsetwacom)

```bash
# Adjust pressure curve (softer tip feel)
xsetwacom set "device name" PressureCurve 0 25 75 100

# Set button actions
xsetwacom set "device name" Button 2 "key ctrl z"  # Undo
xsetwacom set "device name" Button 3 "key ctrl shift z"  # Redo

# Rotate tablet
xsetwacom set "device name" Rotate half  # 180°

# Enable touch (for touch-enabled tablets)
xsetwacom set "device touch" Touch on
```

### Wayland Configuration

On Wayland, use `libinput` and KDE's tablet settings. The `xsetwacom` tool only works in X11/XWayland.

For Wayland-native apps:
```bash
# Check tablet detection
libinput list-devices | grep -i tablet
```

---

## Application Setup

### Krita

1. Settings → Configure Krita → Tablet Settings
2. Use "Windows Ink" mode on Windows tablets
3. Adjust pressure curve per brush

### GIMP

1. Edit → Input Devices
2. Set device mode to "Screen" for pen tablets
3. Configure pressure for size/opacity

### Blender

1. Edit → Preferences → Input
2. Enable "Emulate 3 Button Mouse" if needed
3. Tablet pressure works in Sculpt/Paint modes

### Inkscape

Pressure sensitivity works automatically for supported tools.

---

## Troubleshooting

### Tablet Not Detected

```bash
# Check USB connection
lsusb | grep -i wacom  # or huion/xp-pen

# Check kernel module
lsmod | grep wacom
lsmod | grep hid_uclogic

# View kernel messages
dmesg | grep -i tablet
```

### Wrong Pressure Curve

Adjust in KDE settings or use:
```bash
xsetwacom set "device" PressureCurve 0 0 100 100  # Linear
xsetwacom set "device" PressureCurve 0 50 50 100  # Soft
xsetwacom set "device" PressureCurve 50 0 100 50  # Firm
```

### Multi-Monitor Mapping

```bash
# Map to primary monitor only
xsetwacom set "device" MapToOutput "DP-1"

# Map proportionally to all monitors
xsetwacom set "device" MapToOutput "desktop"
```

---

## Tips for Artists

1. **Calibrate regularly**: Tablet surfaces wear over time
2. **Use tablet area mapping**: Match tablet aspect ratio to monitor
3. **Create application profiles**: Different settings for Krita vs Blender
4. **Consider screen protectors**: Reduces nib wear on display tablets
5. **Backup configurations**: Export xsetwacom scripts or KDE profiles
