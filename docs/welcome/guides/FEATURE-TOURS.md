# Feature Tours System

Interactive guided tours that highlight Sanchala OS features using spotlight overlays.

## Available Tours

| Tour ID | Name | Duration | Description |
|---------|------|----------|-------------|
| `desktop` | Desktop Essentials | 3 min | Panel, dock, launcher, workspaces |
| `security` | Security Features | 2 min | Guardian, firewall, permissions |
| `privacy` | Privacy Dashboard | 2 min | Privacy score, audit, controls |

## Tour Architecture

```
┌──────────────────┐
│   Tour Engine    │  ← Manages tour state and navigation
└────────┬─────────┘
         │
┌────────┴─────────┐
│ Spotlight Layer  │  ← KWin script for visual overlay
└────────┬─────────┘
         │
┌────────┴─────────┐
│   Tour Tooltip   │  ← Floating explanation panel
└──────────────────┘
```

## Tour Definition Format

Tours are defined in TOML files at `/usr/share/sanchala/welcome/tours/`.

```toml
[tour]
id = "desktop"
name = "Desktop Essentials"
description = "Learn the basics of Sanchala OS"
estimated_minutes = 3

[[steps]]
id = "panel"
title = "The Top Panel"
description = "Quick access to system status and notifications."
target = { type = "panel", name = "top" }
position = "bottom"

[[steps]]
id = "launcher"
title = "App Launcher"
description = "Press Super to search for apps."
target = { type = "widget", id = "app-menu" }
position = "right"
action = { type = "click", target = "app-menu" }
```

## Target Types

| Type | Description | Properties |
|------|-------------|------------|
| `fullscreen` | Dim entire screen | None |
| `panel` | Highlight a panel | `name`: top, bottom, dock |
| `widget` | Highlight a widget | `id`: widget identifier |
| `window` | Highlight a window | `class`: window class |
| `area` | Highlight screen area | `x`, `y`, `width`, `height` |

## Tooltip Positions

- `top` - Above the target
- `bottom` - Below the target
- `left` - Left of target
- `right` - Right of target
- `center` - Center of screen
- `auto` - Automatic best fit

## Actions

```toml
# Simulate click
action = { type = "click", target = "widget-id" }

# Open application
action = { type = "open_app", app_id = "org.kde.dolphin" }

# Open settings page
action = { type = "show_settings", page = "privacy" }

# Wait before continuing
action = { type = "wait", seconds = 2 }
```

## Media Attachments

```toml
# Image
media = { type = "image", path = "/path/to/image.png" }

# Animation (Lottie)
media = { type = "animation", path = "/path/to/anim.json" }

# Video
media = { type = "video", path = "/path/to/video.webm" }
```

## CLI Usage

```bash
# Start default tour
sanchala-welcome --tour

# Start specific tour
sanchala-welcome --tour=security

# List available tours
sanchala-welcome --tour --list

# Reset tour progress
sanchala-welcome --tour --reset
```

## D-Bus API

```bash
# Start tour
dbus-send --session --dest=id.sanchala.Welcome1 \
  /id/sanchala/Welcome1 \
  id.sanchala.Welcome1.StartTour string:"desktop"

# Navigate
dbus-send ... id.sanchala.Welcome1.TourNext
dbus-send ... id.sanchala.Welcome1.TourPrevious
dbus-send ... id.sanchala.Welcome1.TourExit
```

## Creating Custom Tours

1. Create TOML file in `/usr/share/sanchala/welcome/tours/`
2. Define tour metadata and steps
3. Test with `sanchala-welcome --tour=your-tour-id`

---

**Document Version:** 1.0
