# 🎛️ Sanchala OS Quick Settings & Control Center

## Overview

Sanchala OS Quick Settings delivers a **macOS Control Center-style experience** through a unified, elegant plasmoid that provides instant access to system controls, toggles, and media playback.

---

## 📚 Documentation Index

| Document | Description |
|----------|-------------|
| [CONTROL-CENTER-PLASMOID.md](CONTROL-CENTER-PLASMOID.md) | Control Center plasmoid specification |
| [QUICK-TOGGLES.md](QUICK-TOGGLES.md) | Quick toggle buttons configuration |
| [SYSTEM-TRAY.md](SYSTEM-TRAY.md) | System tray organization and layout |
| [SLIDERS-SPEC.md](SLIDERS-SPEC.md) | Brightness, volume, and WiFi quick access |
| [CUSTOM-WIDGETS.md](CUSTOM-WIDGETS.md) | Sanchala custom widget designs |

---

## 🎯 Design Philosophy

### macOS Control Center Inspiration

```
┌─────────────────────────────────────┐
│  ⚙️  CONTROL CENTER                  │
├─────────────────────────────────────┤
│  ┌─────────┐ ┌─────────┐ ┌────────┐ │
│  │  📶     │ │  🔵     │ │  🌙    │ │
│  │  Wi-Fi  │ │Bluetooth│ │  DND   │ │
│  └─────────┘ └─────────┘ └────────┘ │
│  ┌─────────┐ ┌─────────┐ ┌────────┐ │
│  │  🌓     │ │  📡     │ │  🔒    │ │
│  │Dark Mode│ │ AirPlay │ │ Focus  │ │
│  └─────────┘ └─────────┘ └────────┘ │
├─────────────────────────────────────┤
│  🔊 ━━━━━━━━━━━━━━━━━━━━━━━━━━  75% │
│  ☀️ ━━━━━━━━━━━━━━━━━━━━━━━━━━  60% │
├─────────────────────────────────────┤
│  🎵 Now Playing - The Weeknd        │
│     ◄◄  ▶  ►►                       │
└─────────────────────────────────────┘
```

### Key Principles

1. **One-Click Access** - Most-used controls always visible
2. **Expandable Sections** - Click toggles to reveal detailed settings
3. **Visual Hierarchy** - Important controls prominent
4. **Smooth Animations** - 200ms transitions, blur effects
5. **Unified Aesthetics** - Matches Sanchala visual identity

---

## 📁 File Locations

### Plasmoid Package
```
/usr/share/plasma/plasmoids/org.sanchala.controlcenter/
├── metadata.json
├── contents/
│   ├── ui/
│   │   ├── main.qml
│   │   ├── ControlCenter.qml
│   │   ├── ToggleGrid.qml
│   │   └── SliderSection.qml
│   └── config/
│       └── main.xml
```

### Configuration
```
~/.config/sanchala/controlcenter.conf
/etc/skel/.config/sanchala/controlcenter.conf
```

---

## ⌨️ Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Meta+C` | Open Control Center |
| `Meta+F1` | Toggle Wi-Fi |
| `Meta+F2` | Toggle Bluetooth |
| `Meta+F3` | Toggle Do Not Disturb |
| `Meta+F4` | Toggle Dark Mode |

---

**Document Version:** 1.0  
**Maintainer:** Quick Settings Engineer
