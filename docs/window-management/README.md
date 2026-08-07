# SANCHALA OS - Window Management System

## Overview

SANCHALA OS features a macOS-quality window management system built on KWin with custom scripts for intelligent tiling, Stage Manager, and smooth 60fps animations.

## Features

### 1. Intelligent Tiling (sanchala-tiling)

**Layouts:**
- **Floating** - Free-form window placement
- **Master/Stack** - Large master + stacked secondary windows
- **Grid** - Automatic grid based on window count
- **Golden Ratio** - Fibonacci-inspired spiral layout
- **Columns** - Equal-width vertical columns
- **Rows** - Equal-height horizontal rows
- **Centered Master** - Master centered with flanking stacks

### 2. Stage Manager (sanchala-stage-manager)

macOS Ventura-style window organization:
- Window grouping by application
- Sidebar strips for inactive groups
- Quick focus switching

### 3. Quick Tile (sanchala-quick-tile)

Enhanced window snapping:
- Half/quarter/third tiles
- Center snap
- Keyboard-driven positioning

## Keyboard Shortcuts

### Tiling
| Shortcut | Action |
|----------|--------|
| `Meta+T` | Cycle layouts |
| `Meta+Shift+T` | Retile desktop |
| `Meta+Return` | Promote to master |
| `Meta+Shift+M` | Master/Stack |
| `Meta+Shift+G` | Grid layout |

### Quick Tile
| Shortcut | Action |
|----------|--------|
| `Meta+Left/Right` | Half left/right |
| `Meta+Up/Down` | Half top/bottom |
| `Meta+U/I/J/K` | Quarter corners |
| `Meta+C` | Center |
| `Meta+1-5` | Thirds |

### Stage Manager
| Shortcut | Action |
|----------|--------|
| `Meta+S` | Toggle Stage Manager |
| `Meta+`` ` | Cycle groups |

### Desktops
| Shortcut | Action |
|----------|--------|
| `Meta+Ctrl+Arrows` | Switch desktop |
| `Meta+1-4` | Jump to desktop |
| `Meta+W` | Overview |

## Virtual Desktops

4 pre-configured desktops in 2x2 grid:
1. **Main** - Primary workspace
2. **Work** - Productivity
3. **Development** - IDEs/terminals
4. **Media** - Entertainment

## Screen Edges

- **Top-Left:** Overview
- **Top:** Show Desktop
- **Top-Right:** App Launcher

## Files

```
~/.config/kwinrc           # Main config
~/.config/kwinrulesrc      # Window rules
~/.config/kwinshortcutsrc  # Shortcuts
~/.local/share/kwin/scripts/
  ├── sanchala-tiling/
  ├── sanchala-stage-manager/
  └── sanchala-quick-tile/
```

## Customization

Edit `~/.config/kwinrc`:

```ini
[Script-sanchala-tiling]
innerGap=8
outerGap=12
masterRatio=55

[Compositing]
AnimationSpeed=2  # 1=instant, 4=slow
```
