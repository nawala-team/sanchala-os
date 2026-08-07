# 🎛️ SANCHALA OS - Input Systems Guide

## Overview

Sanchala OS provides MacBook-quality input device support with:
- **Touchpad**: Natural scrolling, multi-finger gestures, palm rejection
- **Touchscreen**: Multi-touch calibration, gesture support
- **Stylus/Pen**: Pressure sensitivity, tilt support (Wacom, Huion, XP-Pen)
- **Keyboard**: Customizable layouts, IME for CJK languages
- **Mouse**: Adaptive acceleration, gaming mouse support

---

## Touchpad Configuration

### Default Behavior (macOS-style)

| Feature | Setting | Description |
|---------|---------|-------------|
| Natural Scrolling | ✅ Enabled | Content follows finger direction |
| Tap to Click | ✅ Enabled | Tap = click, no physical press needed |
| Two-finger Tap | Right-click | Context menu |
| Three-finger Tap | Middle-click | Paste in terminal |
| Palm Detection | ✅ Enabled | Prevents accidental input |
| Disable While Typing | ✅ Enabled | No cursor jumps |

### Adjusting Touchpad Settings

**GUI Method (recommended):**
```
System Settings → Input Devices → Touchpad
```

**Command Line:**
```bash
# List touchpad devices
libinput list-devices | grep -A 20 "Touchpad"

# Test touchpad events
libinput debug-events --device /dev/input/eventX
```

### Configuration Files

| File | Purpose |
|------|---------|
| `/etc/X11/xorg.conf.d/40-libinput.conf` | X11 defaults |
| `/etc/libinput/local-overrides.quirks` | Device-specific tweaks |
| `~/.config/touchpadxlibinputrc` | KDE user settings |

---

## Multi-finger Gestures

Sanchala OS uses **Touchégg** for advanced gestures.

### Gesture Reference

| Gesture | Action |
|---------|--------|
| 3-finger swipe up | Overview (Mission Control) |
| 3-finger swipe down | Minimize all windows |
| 3-finger swipe left/right | Switch virtual desktop |
| 4-finger swipe up | Desktop Grid |
| 4-finger swipe down | Show Desktop |
| 4-finger swipe left/right | Switch windows (Alt+Tab) |
| 4-finger pinch in | Show Desktop |
| 4-finger pinch out | Overview |
| 3-finger pinch | Zoom in/out |

### Starting Gesture Daemon

```bash
# Touchégg (default)
systemctl --user enable --now touchegg

# Alternative: libinput-gestures
systemctl --user enable --now libinput-gestures
```

### Customizing Gestures

Edit `~/.config/touchegg/touchegg.conf` or copy system config:
```bash
cp /etc/touchegg/touchegg.conf ~/.config/touchegg/
```

---

## Keyboard Configuration

### Default Layout: US QWERTY

Special options enabled:
- `Caps Lock` → `Escape` (vim users rejoice!)
- `Ctrl+Alt+Backspace` → Kill X session (emergency)
- `Right Alt` → Compose key (for special characters)

### Changing Keyboard Layout

**GUI:**
```
System Settings → Input Devices → Keyboard → Layouts
```

**Temporary (current session):**
```bash
setxkbmap us           # US layout
setxkbmap de           # German
setxkbmap fr           # French
setxkbmap us,ru        # US + Russian (toggle with Super+Space)
```

**Permanent:**
Edit `/etc/vconsole.conf`:
```
KEYMAP=us
```

### Apple Keyboard Support

Apple keyboards automatically:
- Swap Left Alt ↔ Left Super (Command key position)
- Function keys work as F1-F12 by default

To use media keys, hold `Fn` or configure in System Settings.
