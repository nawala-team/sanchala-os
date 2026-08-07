# Sanchala Theming Engine - Usage Guide

## Command Line Tools

### sanchala-theme-switch
Switch between light and dark themes across all toolkits.

```bash
sanchala-theme-switch light    # Switch to light mode
sanchala-theme-switch dark     # Switch to dark mode
sanchala-theme-switch toggle   # Toggle between modes
sanchala-theme-switch status   # Check current mode
```

### sanchala-theme-auto
Automatic theme switching based on time or sunset.

```bash
sanchala-theme-auto start      # Start daemon
sanchala-theme-auto once       # Check and apply once
sanchala-theme-auto status     # Show target mode
```

### sanchala-accent
Manage system-wide accent colors.

```bash
sanchala-accent set "#7C4DFF"  # Set by hex color
sanchala-accent set purple     # Set by preset name
sanchala-accent wallpaper      # Extract from wallpaper
sanchala-accent list           # List available presets
sanchala-accent current        # Show current accent
```

## Configuration

### Main Config: `/etc/sanchala/theming/theming.conf`

```ini
[General]
mode=auto                    # light, dark, auto

[Schedule]
light_mode_start=07:00
dark_mode_start=19:00

[AccentColor]
accent=#3949AB
source=manual                # manual, wallpaper, preset

[Transparency]
panel_opacity=85
blur_enabled=true
blur_radius=20
```

User config at `~/.config/sanchala/theming.conf` takes precedence.

## Color Palette

| Name | Hex | Usage |
|------|-----|-------|
| Sanchala Indigo | `#3949AB` | Primary, selections |
| Deep Navy | `#1A237E` | Headers, dark accents |
| Electric Blue | `#536DFE` | Links, focus |
| Success | `#00C853` | Positive actions |
| Warning | `#FFB300` | Caution states |
| Error | `#FF1744` | Destructive actions |

## Accent Presets

| Name | Color |
|------|-------|
| indigo | #3949AB |
| blue | #536DFE |
| navy | #1A237E |
| purple | #7C4DFF |
| teal | #00BCD4 |
| pink | #E91E63 |
| orange | #FF5722 |
| amber | #FFB300 |
| green | #00C853 |
| red | #FF1744 |

## D-Bus Integration

Applications can listen for theme changes:

```
Interface: org.sanchala.ThemeEngine
Path: /org/sanchala/ThemeEngine

Signals:
  ThemeChanged(string mode)    # "light" or "dark"
  AccentChanged(string color)  # hex color
```

## Systemd Services

```bash
# Enable auto theme switching
systemctl --user enable --now sanchala-theme-auto.service

# Check status
systemctl --user status sanchala-theme-auto.service
```
