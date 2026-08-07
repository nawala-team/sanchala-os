# 🎬 SANCHALA OS - Plymouth Boot Splash Theme

## Overview

**Theme Name:** `sanchala`  
**Type:** Script-based with animations  
**Target:** Modern UEFI systems  
**Inspired By:** macOS boot experience

## Design Philosophy

Embody "Sanchala" meaning (संञ्चल - to set in motion):
- Smooth, elegant animation suggesting momentum
- Minimal visual noise - focus on the logo
- Professional appearance inspiring confidence
- Seamless transition from firmware to desktop

## Theme Structure

```
/usr/share/plymouth/themes/sanchala/
├── sanchala.plymouth          # Theme descriptor
├── sanchala.script            # Animation script
├── logo.png                   # Main logo (256x256)
├── logo@2x.png               # HiDPI logo (512x512)
├── progress-bar.png          # Progress bar fill
├── progress-bar-bg.png       # Progress bar background
├── bullet.png                # Password field bullets
├── entry.png                 # Password entry field
└── lock.png                  # Lock icon
```

## Color Specifications

| Element | Color | Hex |
|---------|-------|-----|
| Background | Deep Black | `#121212` |
| Logo Primary | Sanchala Indigo | `#3949AB` |
| Logo Accent | Electric Blue | `#536DFE` |
| Progress Bar | Electric Blue → Indigo | Gradient |
| Progress BG | Charcoal | `#212121` |
| Text | Light Gray | `#E0E0E0` |

## Animation Sequence

### Phase 1: Logo Fade-In (0-1.5s)
- Background: Solid #121212
- Logo fades in from 0% → 100% opacity
- Easing: ease-out-cubic

### Phase 2: Motion Pulse (ongoing)
- Logo gear arcs subtly rotate (360° / 4s)
- Soft pulsing glow (Electric Blue)
- Glow oscillates 30% - 70% opacity

### Phase 3: Progress Bar
- Appears 80px below logo center
- Size: 200x4px, 2px radius (pill)
- Gradient sweep animation

### Phase 4: Password Entry (if encrypted)
- Progress bar fades, password field slides up
- Lock icon above field
- Bullets for each character

### Phase 5: Fade-Out
- All elements fade (0.5s, ease-in-cubic)
- Seamless transition to SDDM
