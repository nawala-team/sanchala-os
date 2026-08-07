# SANCHALA OS - Screenshot & Recording System

> macOS-quality capture tools with privacy-first design

## Overview

SANCHALA OS provides a comprehensive screenshot and screen recording system built on:
- **Spectacle** - KDE's powerful screenshot tool
- **wf-recorder** - Wayland-native screen recording
- **OBS Studio** - Professional recording/streaming
- **Tesseract** - OCR text extraction
- **Krita/Gwenview** - Annotation tools

## Quick Start

### Screenshots (Spectacle)

| Shortcut | Action |
|----------|--------|
| `Print` | Capture entire desktop |
| `Shift+Print` | Capture rectangular region |
| `Alt+Print` | Capture active window |
| `Super+Print` | Capture current monitor |
| `Ctrl+Print` | Capture all screens |

### Screen Recording

| Shortcut | Action |
|----------|--------|
| `Super+Shift+R` | Start/stop recording |
| `Super+Ctrl+R` | Record window |
| `Super+Alt+R` | Record region |

## Configuration Files

```
~/.config/
├── spectaclerc                    # Main Spectacle config
├── spectacleshortcutsrc           # Keyboard shortcuts
├── obs-studio/
│   ├── global.ini                 # OBS global settings
│   └── basic/profiles/SANCHALA/   # Recording profile
├── simplescreenrecorder/
│   └── settings.conf              # SSR fallback config
├── sanchala/
│   ├── ocr.conf                   # Tesseract settings
│   └── screenshot-share.conf      # Share destinations
└── krita/
    └── sanchala-annotate.profile  # Annotation profile
```

## Documentation

- [Command-Line Tools](TOOLS.md) - CLI utilities reference
- [Spectacle Guide](SPECTACLE.md) - Screenshot features
- [Recording Guide](RECORDING.md) - Screen recording options
- [Privacy & Troubleshooting](PRIVACY.md) - Security and fixes

## Package Requirements

```bash
# Core
sudo pacman -S spectacle wf-recorder slurp grim

# OCR
sudo pacman -S tesseract tesseract-data-eng

# Recording
sudo pacman -S obs-studio simplescreenrecorder

# Annotation
sudo pacman -S krita gwenview

# Sharing
sudo pacman -S wl-clipboard curl
```
