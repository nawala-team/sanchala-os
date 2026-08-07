# 🎨 Sanchala OS Theming Engine

The Sanchala Theming Engine provides a seamless, unified visual experience across all applications - Qt, GTK, and native Plasma components - with macOS-like polish and consistency.

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                  Sanchala Theming Engine                     │
├─────────────────────────────────────────────────────────────┤
│  ┌───────────┐  ┌───────────┐  ┌─────────────────────────┐  │
│  │  Plasma   │  │    GTK    │  │     Kvantum/Qt          │  │
│  │  Theme    │  │ 3.0 / 4.0 │  │       Theme             │  │
│  └─────┬─────┘  └─────┬─────┘  └───────────┬─────────────┘  │
│        └──────────────┼────────────────────┘                │
│                       ▼                                      │
│           ┌───────────────────────┐                         │
│           │    Theme Switcher     │                         │
│           │  (Light/Dark/Auto)    │                         │
│           └───────────┬───────────┘                         │
│        ┌──────────────┼──────────────┐                      │
│  ┌─────▼─────┐  ┌─────▼─────┐  ┌─────▼─────┐               │
│  │  Accent   │  │   Auto    │  │   D-Bus   │               │
│  │  Colors   │  │  Daemon   │  │  Signals  │               │
│  └───────────┘  └───────────┘  └───────────┘               │
└─────────────────────────────────────────────────────────────┘
```

## Components

### 1. Plasma Desktop Theme
Location: `/usr/share/plasma/desktoptheme/sanchala/`

- **sanchala** - Light variant with blur effects
- **sanchala-dark** - Dark variant optimized for OLED

### 2. GTK Themes
Location: `/usr/share/themes/Sanchala/`

- GTK 3.0/4.0 light and dark variants
- LibAdwaita compatibility
- CSD window support with 12px rounded corners

### 3. Kvantum Theme (Qt5/Qt6)
Location: `/usr/share/Kvantum/Sanchala/`

- Native Qt widget styling
- Blur and transparency support
- Animated state transitions

### 4. Color Schemes
Location: `/usr/share/color-schemes/`

- **SanchalaLight.colors** - Full KDE color scheme (light)
- **SanchalaDark.colors** - Full KDE color scheme (dark)

## Quick Start

```bash
# Switch themes
sanchala-theme-switch light|dark|toggle

# Enable auto switching (time/sunset based)
systemctl --user enable --now sanchala-theme-auto.service

# Set accent color
sanchala-accent set purple
sanchala-accent wallpaper  # Extract from wallpaper
```

See [USAGE.md](USAGE.md) for detailed documentation.
