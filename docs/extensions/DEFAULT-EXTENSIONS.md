# Default Extensions Pack

## Overview

SANCHALA OS ships with a curated set of extensions that provide essential functionality while showcasing the extension framework capabilities.

## Included Plasmoids

### 1. Sanchala Control Center
**ID:** `org.sanchala.controlcenter`

macOS-style unified quick settings panel with:
- Wi-Fi/Bluetooth toggles
- Volume/brightness sliders
- Do Not Disturb mode
- Screen mirroring
- Night light toggle
- Now playing mini-widget

**Location:** `/usr/share/plasma/plasmoids/org.sanchala.controlcenter/`

### 2. Sanchala Now Playing
**ID:** `org.sanchala.nowplaying`

Elegant media player widget featuring:
- Album art display with blur background
- Track info (title, artist, album)
- Playback controls
- MPRIS integration (all media players)

**Location:** `/usr/share/plasma/plasmoids/org.sanchala.nowplaying/`

### 3. Sanchala System Monitor
**ID:** `org.sanchala.sysmonitor`

Real-time system resource monitor:
- CPU usage (per-core graphs)
- Memory usage
- Network throughput
- Disk I/O
- Temperature sensors

**Location:** `/usr/share/plasma/plasmoids/org.sanchala.sysmonitor/`

### 4. Sanchala Quick Note
**ID:** `org.sanchala.quicknote`

Desktop sticky notes widget:
- Multiple notes support
- Color coding
- Markdown preview
- Cloud sync ready

**Location:** `/usr/share/plasma/plasmoids/org.sanchala.quicknote/`

## Included KWin Scripts

### 1. Sanchala Tiling
**ID:** `sanchala-tiling`

Intelligent window tiling system:
- Layouts: Master/Stack, Grid, Columns, Golden Ratio
- Per-desktop layout memory
- Gap customization
- App exclusion rules

**Shortcuts:**
- `Meta+T` - Cycle layouts
- `Meta+Return` - Promote to master
- `Meta+Shift+T` - Retile

### 2. Sanchala Stage Manager
**ID:** `sanchala-stage-manager`

macOS Ventura-style window organization:
- App-based window grouping
- Sidebar strip thumbnails
- Quick group switching
- Focus mode

**Shortcuts:**
- `Meta+S` - Toggle Stage Manager
- `Meta+`` - Cycle groups

### 3. Sanchala Quick Tile
**ID:** `sanchala-quick-tile`

Enhanced snap layouts:
- Half/quarter/third tiling
- Center snap
- Custom gap spacing

**Shortcuts:**
- `Meta+Arrows` - Half tiles
- `Meta+U/I/J/K` - Quarter corners
- `Meta+C` - Center

**Location:** `~/.local/share/kwin/scripts/`

## Included Themes

### Plasma Desktop Themes
- **sanchala** - Light theme with glassmorphism
- **sanchala-dark** - Dark theme, OLED-optimized

### Color Schemes
- **SanchalaLight.colors** - Light color palette
- **SanchalaDark.colors** - Dark color palette

### Window Decorations
- **Sanchala Aurorae** - macOS-style traffic light buttons

## Installation Paths

```
/usr/share/plasma/plasmoids/
├── org.sanchala.controlcenter/
├── org.sanchala.nowplaying/
├── org.sanchala.sysmonitor/
└── org.sanchala.quicknote/

~/.local/share/kwin/scripts/
├── sanchala-tiling/
├── sanchala-stage-manager/
└── sanchala-quick-tile/

/usr/share/plasma/desktoptheme/
├── sanchala/
└── sanchala-dark/

/usr/share/color-schemes/
├── SanchalaLight.colors
└── SanchalaDark.colors
```

## Disabling Default Extensions

```bash
# Disable a plasmoid
sanchala-extensions disable org.sanchala.sysmonitor

# Disable KWin script
sanchala-extensions disable sanchala-tiling

# Or via System Settings → Extensions
```

## Updating Default Extensions

Default extensions update with system updates:
```bash
sudo pacman -Syu sanchala-extensions-default
```

---
**Version:** 1.0 | **Last Updated:** August 2026
