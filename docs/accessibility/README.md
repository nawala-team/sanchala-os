# Sanchala OS Accessibility Guide

Welcome to Sanchala OS accessibility documentation. This guide covers all accessibility features designed to make Sanchala OS usable for everyone, targeting WCAG 2.1 AA compliance.

## Quick Start

### Accessibility Profiles

Sanchala OS includes pre-configured profiles for common accessibility needs:

| Profile | Best For | Features Enabled |
|---------|----------|------------------|
| Default | General use | Basic accessibility support |
| Low Vision | Users with reduced vision | Large text, large cursor, magnifier, reduced motion |
| Blind | Screen reader users | Orca screen reader, reduced motion |
| High Contrast Light | Light-sensitive users | Maximum contrast, light background |
| High Contrast Dark | Users needing high contrast | Maximum contrast, dark background |
| Motor | Users with motor impairments | Sticky keys, large cursor, keyboard navigation |
| Cognitive | Users needing simplified UI | Reduced distractions, extended timeouts |

Apply a profile via command line:
```bash
sanchala-accessibility profile low-vision
```

Or via System Settings → Accessibility.

### Essential Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Alt+Super+S` | Toggle screen reader (Orca) |
| `Super+U` | Open accessibility settings |
| `Super+Alt+H` | Toggle high contrast |
| `Super+=` | Zoom in (magnifier) |
| `Super+-` | Zoom out (magnifier) |
| `Super+0` | Reset zoom |
| `Alt+Tab` | Switch windows |
| `Super+Space` | Application launcher |

## Vision Accessibility

### Screen Reader (Orca)

Sanchala OS uses Orca, the leading Linux screen reader, fully integrated with the desktop.

**Enable Screen Reader:**
```bash
sanchala-accessibility screen-reader start
```

**Orca Keyboard Shortcuts:**
- `Insert` or `Caps Lock` - Orca modifier key
- `Orca+H` - Help
- `Orca+Space` - Preferences
- `Orca+Q` - Quit Orca

**Configuration File:** `~/.config/orca/user-settings.conf`

**Features:**
- Speech synthesis via Speech Dispatcher
- Braille display support
- Key echo (words/characters)
- Structural navigation in web content
- Table navigation with cell announcements

### High Contrast Themes

Two high contrast color schemes optimized for WCAG 2.1 AA (minimum 4.5:1 contrast ratio):

**High Contrast Light:**
- White background (#FFFFFF)
- Black text (#000000)
- Blue links (#0000EE)

**High Contrast Dark:**
- Black background (#000000)  
- White text (#FFFFFF)
- Light blue links (#66B3FF)

**Enable:**
```bash
sanchala-accessibility high-contrast enable dark
# or
sanchala-accessibility high-contrast enable light
```

### Large Text

Scale all system text for better readability:

```bash
# Enable with 150% scaling
sanchala-accessibility large-text enable 1.5

# Available scales: 1.0, 1.25, 1.5, 1.75, 2.0, 2.5
```

**Note:** Log out and back in for full effect.

### Large Cursor

Increase cursor size for better visibility:

```bash
# Enable with 48px cursor
sanchala-accessibility large-cursor enable 48

# Available sizes: 24, 32, 48, 64, 96
```

**Additional cursor features:**
- Locate cursor on Ctrl press
- Cursor halo (colored ring around cursor)
- High contrast cursor themes

### Screen Magnifier

Zoom in on screen content:

```bash
sanchala-accessibility magnifier enable 2.0
```

**Magnifier modes:**
- Full screen - entire display zoomed

## Keyboard Accessibility

### Sticky Keys

Press modifier keys (Ctrl, Alt, Shift, Super) one at a time instead of holding them together.

```bash
sanchala-accessibility sticky-keys enable
```

**Features:**
- Press modifier once to apply to next key
- Press modifier twice to lock it
- Audio feedback when modifier state changes
- Visual indicator in system tray

### Slow Keys

Ignore brief keystrokes - helps prevent accidental key presses.

**Configuration:** `~/.config/sanchala/accessibility/accessibility.conf`
```ini
[Keyboard]
SlowKeys=true
SlowKeysDelay=300  # milliseconds
```

### Bounce Keys

Ignore rapid repeated keystrokes - helps users who have difficulty releasing keys quickly.

```ini
[Keyboard]
BounceKeys=true
BounceKeysDelay=300  # milliseconds
```

### Mouse Keys

Control the mouse pointer using the numeric keypad:

| Key | Action |
|-----|--------|
| `8` | Move up |
| `2` | Move down |
| `4` | Move left |
| `6` | Move right |
| `7,9,1,3` | Diagonal movement |
| `5` | Left click |
| `+` | Right click |
| `0` | Begin drag |
| `.` | End drag |

Enable with: `Alt+Shift+Num Lock`

### Keyboard-Only Navigation

Sanchala OS supports complete keyboard navigation:

**Focus Navigation:**
- `Tab` - Move to next focusable element
- `Shift+Tab` - Move to previous element
- Arrow keys - Navigate within components
- `Enter/Space` - Activate focused element
- `Escape` - Close dialogs/menus

**Skip Links:**
- `Alt+1` - Skip to main content
- `Alt+2` - Skip to navigation
- `Alt+3` - Skip to search

**Window Management:**
- `Alt+Tab` - Switch windows
- `Alt+F4` - Close window
- `Super+Up` - Maximize
- `Super+Down` - Minimize
- `Super+Left/Right` - Tile window

## Motor Accessibility

### Dwell Click

Click by hovering over items for a specified duration:

```ini
[Motor]
DwellClick=true
DwellTime=1200  # milliseconds
DwellAction=single  # single, double, drag, secondary
```

### On-Screen Keyboard

Virtual keyboard for touch or pointer input:

- Maliit (default)
- Onboard
- Squeekboard

Configure in System Settings → Accessibility → Mobility.

## Hearing Accessibility

### Visual Alerts

Flash the screen when system sounds occur:

```ini
[Audio]
VisualAlerts=true
VisualAlertType=window-flash  # screen-flash, window-flash
VisualAlertColor=#FF5722
```

### Mono Audio

Combine stereo channels for users with hearing loss in one ear:

```ini
[Audio]
MonoAudio=true
AudioBalance=0  # -100 (left) to 100 (right)
```

### Captions

System-wide preference for captions and subtitles:

```ini
[Audio]
PreferCaptions=true
```

## Configuration Files

All accessibility settings are stored in:

```
~/.config/sanchala/accessibility/
├── accessibility.conf    # Main settings
├── profiles.conf         # Profile definitions
├── cursor.conf          # Cursor options
└── keyboard-nav.conf    # Keyboard navigation

~/.config/orca/
└── user-settings.conf   # Orca screen reader
```

## Command-Line Tool

The `sanchala-accessibility` command provides full control:

```bash
# Show current status
sanchala-accessibility status

# Screen reader
sanchala-accessibility screen-reader start|stop|toggle

# High contrast
sanchala-accessibility high-contrast enable|disable|toggle [light|dark]

# Large text
sanchala-accessibility large-text enable|disable [scale]

# Large cursor
sanchala-accessibility large-cursor enable|disable [size]

# Magnifier
sanchala-accessibility magnifier enable|disable [level]

# Sticky keys
sanchala-accessibility sticky-keys enable|disable

# Reduce motion
sanchala-accessibility reduce-motion enable|disable

# Apply profile
sanchala-accessibility profile <name>
```

## WCAG 2.1 AA Compliance

Sanchala OS targets WCAG 2.1 Level AA compliance:

### Perceivable
- ✅ 1.1.1 Non-text Content - Alt text support
- ✅ 1.3.1 Info and Relationships - Semantic structure
- ✅ 1.4.1 Use of Color - Not sole indicator
- ✅ 1.4.3 Contrast (Minimum) - 4.5:1 ratio
- ✅ 1.4.4 Resize Text - Up to 200%
- ✅ 1.4.10 Reflow - Responsive layouts
- ✅ 1.4.11 Non-text Contrast - 3:1 for UI

### Operable
- ✅ 2.1.1 Keyboard - Full keyboard access
- ✅ 2.1.2 No Keyboard Trap - No focus traps
- ✅ 2.4.3 Focus Order - Logical tab order
- ✅ 2.4.7 Focus Visible - Clear focus indicators
- ✅ 2.5.1 Pointer Gestures - Single pointer alternatives

### Understandable
- ✅ 3.2.1 On Focus - Predictable behavior
- ✅ 3.2.2 On Input - No unexpected changes
- ✅ 3.3.1 Error Identification - Clear error messages

### Robust
- ✅ 4.1.1 Parsing - Valid markup
- ✅ 4.1.2 Name, Role, Value - AT-DT API support

**Note:** Full WCAG validation requires manual testing with assistive technologies and expert accessibility review.

## Getting Help

- **Accessibility Settings:** Super+U or System Settings → Accessibility
- **Screen Reader Help:** Orca+H (when Orca is running)
- **Documentation:** /usr/share/doc/sanchala-os/accessibility/
- **Community:** https://sanchala.org/community/accessibility

- Lens - magnified area follows cursor
- Docked - zoomed view in screen region

**Keyboard controls:**
- `Super+=` - Zoom in
- `Super+-` - Zoom out
- `Super+0` - Reset to 100%

### Color Filters

For users with color vision deficiency:

- **Protanopia** - Red-green (red-weak)
- **Deuteranopia** - Red-green (green-weak)
- **Tritanopia** - Blue-yellow
- **Grayscale** - Complete color removal

Configure in System Settings → Accessibility → Vision → Color Filter.
