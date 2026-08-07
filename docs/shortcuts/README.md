# Sanchala OS - Keyboard Shortcuts

Complete keyboard shortcut reference for Sanchala OS.

## Overview

Sanchala OS uses standard Linux Ctrl-based shortcuts for consistency with other Linux distributions. The `Super` key (Windows key) is used for system-level shortcuts, while `Ctrl` is used for application-level shortcuts.

## Design Principles

1. **Standard Linux conventions** - Familiar to Linux users
2. **No conflicts** - Each shortcut has one function
3. **Discoverability** - Press `Super+F1` for cheat sheet overlay
4. **Accessibility** - Screen reader and zoom shortcuts included

## Global Shortcuts

### Essential

| Shortcut | Action |
|----------|--------|
| `Super` | Open Application Launcher |
| `Super+Space` | Quick Search (KRunner) |
| `Alt+F2` | Command Runner |
| `Ctrl+Alt+T` | Open Terminal |
| `Super+E` | Open File Manager |
| `Super+I` | Open System Settings |
| `Ctrl+Alt+L` | Lock Screen |
| `Ctrl+Alt+Delete` | Log Out Dialog |

### Window Management

| Shortcut | Action |
|----------|--------|
| `Alt+Tab` | Switch Windows |
| `Alt+Shift+Tab` | Switch Windows (Reverse) |
| `Alt+\`` | Switch Windows of Same App |
| `Alt+F4` | Close Window |
| `Super+Up` | Maximize Window |
| `Super+Down` | Minimize Window |
| `F11` | Toggle Fullscreen |
| `Super+D` | Show Desktop |
| `Super+Tab` | Overview |
| `Alt+F3` | Window Operations Menu |
| `Ctrl+Alt+Escape` | Force Kill Window |

### Window Tiling

| Shortcut | Action |
|----------|--------|
| `Super+Left` | Tile Left |
| `Super+Right` | Tile Right |
| `Super+Shift+Up` | Tile Top |
| `Super+Shift+Down` | Tile Bottom |
| `Super+Shift+U` | Tile Top-Left |
| `Super+Shift+I` | Tile Top-Right |
| `Super+Shift+J` | Tile Bottom-Left |
| `Super+Shift+K` | Tile Bottom-Right |
| `Super+C` | Center Window |
| `Super+T` | Always on Top |
| `Super+A` | Show on All Desktops |

### Virtual Desktops

| Shortcut | Action |
|----------|--------|
| `Super+1` to `Super+4` | Switch to Desktop 1-4 |
| `Super+Shift+1` to `Super+Shift+4` | Move Window to Desktop 1-4 |
| `Super+Ctrl+Left` | Previous Desktop |
| `Super+Ctrl+Right` | Next Desktop |
| `Super+Ctrl+Up/Down` | Desktop Up/Down |
| `Super+F8` | Desktop Grid View |

### Screenshots

| Shortcut | Action |
|----------|--------|
| `Print` | Capture Full Screen |
| `Shift+Print` | Capture Region |
| `Alt+Print` | Capture Active Window |

### Media Controls

| Shortcut | Action |
|----------|--------|
| `Volume Up` | Increase Volume |
| `Volume Down` | Decrease Volume |
| `Volume Mute` | Toggle Mute |
| `Media Play` | Play/Pause |
| `Media Next` | Next Track |
| `Media Previous` | Previous Track |

## Sanchala Quick Access

| Shortcut | Action |
|----------|--------|
| `Super+F1` | Shortcut Cheat Sheet |
| `Super+H` | Open Home Folder |
| `Super+J` | Open Downloads |
| `Super+W` | Open Web Browser |
| `Super+X` | Open Text Editor |
| `Super+V` | Clipboard History |
| `Super+Shift+C` | Color Picker |
| `Super+Shift+N` | Toggle Night Light |
| `Super+Q` | Activity Switcher |
| `Ctrl+Shift+Escape` | System Monitor |

## Accessibility

| Shortcut | Action |
|----------|--------|
| `Super+=` | Zoom In |
| `Super+-` | Zoom Out |
| `Super+0` | Reset Zoom |
| `Alt+Super+S` | Toggle Screen Reader |

## Configuration

Shortcuts are stored in:
- `/etc/skel/.config/kglobalshortcutsrc` - Global shortcuts
- `/etc/skel/.config/kwinshortcutsrc` - Window manager shortcuts
- `/etc/skel/.config/khotkeysrc` - Custom actions
- `/etc/skel/.config/*shortcutsrc` - Per-application shortcuts

Users can customize shortcuts via System Settings → Shortcuts.
