# Sanchala OS - External Displays Guide

Complete guide for external monitor support, hotplug, and multi-display configuration.

## Automatic Detection

Sanchala OS automatically detects displays connected via:
- HDMI
- DisplayPort
- USB-C (DisplayPort Alt Mode)
- Thunderbolt
- VGA/DVI (legacy)

When you connect a display:
1. Detected within 2-3 seconds
2. KScreen auto-configures layout
3. Previous configuration restored if recognized

---

## Display Configuration

### KDE Plasma Settings

**System Settings → Display and Monitor**

- Arrange display positions
- Set resolution and refresh rate
- Choose primary display
- Configure per-display scaling

### Command Line (Wayland)

```bash
# List outputs
kscreen-doctor --outputs

# Enable output
kscreen-doctor output.HDMI-1.enable

# Set mode
kscreen-doctor output.HDMI-1.mode.1920x1080@60

# Set position
kscreen-doctor output.HDMI-1.position.1920,0

# Disable output
kscreen-doctor output.HDMI-1.disable
```

### Command Line (X11)

```bash
# List outputs
xrandr --query

# Set resolution
xrandr --output HDMI-1 --mode 1920x1080 --rate 60

# Position right of primary
xrandr --output HDMI-1 --right-of eDP-1

# Mirror displays
xrandr --output HDMI-1 --same-as eDP-1
```

---

## Monitor Control (DDC/CI)

Control external monitor settings directly:

```bash
# Detect DDC-capable monitors
ddcutil detect

# Get brightness (VCP code 10)
ddcutil getvcp 10

# Set brightness to 70%
ddcutil setvcp 10 70

# Get contrast (VCP code 12)
ddcutil getvcp 12

# List all controls
ddcutil capabilities
```

### GUI Control

```bash
ddcui
```

### Common VCP Codes

| Code | Function |
|------|----------|
| 10 | Brightness |
| 12 | Contrast |
| 60 | Input Source |
| D6 | Power Mode |

---

## HiDPI & Scaling

### Global Scaling (Wayland)

System Settings → Display → Global Scale

Recommended values:
- 4K 27": 150% (1.5)
- 4K 32": 125% (1.25)
- 1440p 27": 100% (1.0)

### Per-Display Scaling

For mixed DPI setups (e.g., 4K laptop + 1080p external):

1. System Settings → Display
2. Select each display
3. Set individual scale factor

### Environment Variables

Already configured in `/etc/environment.d/60-sanchala-hidpi.conf`:

```bash
# For Qt applications
QT_AUTO_SCREEN_SCALE_FACTOR=1

# For GTK applications  
GDK_SCALE=1
GDK_DPI_SCALE=1
```

---

## Saved Profiles

### Automatic (KScreen)

KScreen remembers configurations based on connected displays.

### Manual (autorandr)

```bash
# Save current config
autorandr --save work-setup

# List profiles
autorandr --list

# Load profile
autorandr --load home-setup

# Auto-detect and apply
autorandr --change
```

---

## Troubleshooting

### Display Not Detected

```bash
# Check DRM status
cat /sys/class/drm/card*/card*-*/status

# Force rescan
echo 1 | sudo tee /sys/class/drm/card0/device/rescan

# Check kernel messages
dmesg | grep -i drm

# Restart display manager
sudo systemctl restart sddm
```

### Wrong Resolution

```bash
# List available modes
kscreen-doctor --outputs

# Force specific mode
kscreen-doctor output.HDMI-1.mode.1920x1080@60
```

### Black Screen on Connect

1. Try different cable
2. Check display input source
3. Force lower resolution first
4. Update GPU drivers

### Display Flickers

```bash
# Try different refresh rate
kscreen-doctor output.HDMI-1.mode.1920x1080@50

# Check for compositor issues
# Disable compositor temporarily: Alt+Shift+F12
```

### No Sound Over HDMI/DP

```bash
# List audio outputs
wpctl status

# Set HDMI as default
wpctl set-default <hdmi-device-id>

# Or use pavucontrol
pavucontrol
```
