# 🖥️ SANCHALA OS - GRUB Bootloader Theme

## Overview

**Theme Name:** `sanchala`  
**Target:** GRUB 2.06+  
**Resolution:** 1920x1080 (auto-scales)  
**Style:** Clean, minimal, macOS-inspired

## Theme Structure

```
/boot/grub/themes/sanchala/
├── theme.txt                 # Theme configuration
├── background.png            # 1920x1080 background
├── logo.png                  # Top logo (160x160)
├── icons/                    # Boot entry icons
│   ├── sanchala.png
│   ├── sanchala-recovery.png
│   ├── linux.png
│   ├── windows.png
│   └── uefi.png
├── select_*.png             # Selection (9-slice)
├── menu_box_*.png           # Menu container (9-slice)
└── fonts/*.pf2              # GRUB fonts
```

## Color Specifications

| Element | Color | Hex |
|---------|-------|-----|
| Background | Deep Black | `#0D0D0D` |
| Menu BG | Charcoal 80% | `#1E1E1E` |
| Item Text | Light Gray | `#E0E0E0` |
| Selected BG | Sanchala Indigo | `#3949AB` |
| Selected Text | White | `#FFFFFF` |
| Timeout Text | Medium Gray | `#9E9E9E` |
| Scrollbar | Electric Blue | `#536DFE` |

## Layout (1920x1080)

```
┌────────────────────────────────────────────┐
│                  [LOGO]                    │
│             SANCHALA OS 1.0                │
│                                            │
│    ┌────────────────────────────────┐      │
│    │ [•] Sanchala OS          ◀─── │      │
│    │ [ ] Sanchala OS (Recovery)    │      │
│    │ [ ] Windows Boot Manager      │      │
│    │ [ ] UEFI Firmware Settings    │      │
│    └────────────────────────────────┘      │
│                                            │
│          Starting in 5 seconds...          │
│      [E] Edit  [C] Console  [Enter] Boot   │
└────────────────────────────────────────────┘
```

## Element Positions

| Element | Position | Size |
|---------|----------|------|
| Logo | Center, Y:80 | 160x160 |
| Title | Center, Y:260 | Auto |
| Menu Box | Center, Y:340 | 700x320 |
| Menu Item | - | 660x48, icon 32x32 |
| Timeout | Center, Y:700 | Auto |
