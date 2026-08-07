# 🔐 SANCHALA OS - SDDM Login Theme

## Overview

**Theme Name:** `sanchala`  
**Target:** SDDM 0.20+ with Qt6  
**Style:** macOS-inspired, blur effects, elegant  
**Features:** User avatar, virtual keyboard, session selector

## Theme Structure

```
/usr/share/sddm/themes/sanchala/
├── metadata.desktop          # Theme metadata
├── theme.conf               # Configuration
├── Main.qml                 # Main layout
├── components/
│   ├── UserDelegate.qml     # User list item
│   ├── SessionButton.qml    # Session selector
│   ├── ActionButton.qml     # Power/restart buttons
│   └── Clock.qml            # Time display
├── assets/
│   ├── background.png       # Default wallpaper
│   ├── logo.png            # Sanchala logo
│   └── icons/              # UI icons
└── fonts/                   # Bundled fonts
```

## Color Specifications

| Element | Light | Dark |
|---------|-------|------|
| Background Overlay | `#FFFFFF` 60% | `#000000` 40% |
| Card Background | `#FFFFFF` 80% | `#1E1E1E` 80% |
| Primary Text | `#212121` | `#FFFFFF` |
| Secondary Text | `#757575` | `#9E9E9E` |
| Input Background | `#F5F5F5` | `#2A2A2A` |
| Input Border | `#E0E0E0` | `#424242` |
| Input Focus | `#3949AB` | `#536DFE` |
| Button Primary | `#3949AB` | `#3949AB` |
| Button Hover | `#1A237E` | `#536DFE` |
| Error | `#FF1744` | `#FF1744` |

## Layout Design

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│   12:34                              ⚙️ 🔊 📶 🔋           │
│   Wednesday, August 6                                       │
│                                                             │
│                         ╭───────╮                           │
│                         │ 👤    │                           │
│                         │ Avatar│                           │
│                         ╰───────╯                           │
│                                                             │
│                       John Doe                              │
│                                                             │
│                   ┌─────────────────┐                       │
│                   │ ●●●●●●●●       │                       │
│                   └─────────────────┘                       │
│                                                             │
│                      [ Log In ]                             │
│                                                             │
│                    ◀ KDE Plasma ▶                           │
│                                                             │
│   ⏻ Shutdown    🔄 Restart    😴 Sleep         ⌨️ Keyboard │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## Visual Effects

### Blur
- Background: 40px gaussian blur
- Cards: 20px blur with 80% opacity
- Follows wallpaper dynamically

### Shadows
- Login card: `0 20px 60px rgba(0,0,0,0.3)`
- Buttons: `0 2px 8px rgba(0,0,0,0.15)`
- Input focus: `0 0 0 3px rgba(57,73,171,0.3)`

### Animations
- Card fade-in: 300ms ease-out
- Button hover: 150ms ease
- Input focus: 200ms ease
- Error shake: 400ms
- Success: scale 0.95 → 1.0, 200ms
