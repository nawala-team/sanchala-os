# Keyboard Navigation Guide

Complete guide to keyboard-only navigation in Sanchala OS, ensuring WCAG 2.1 AA compliance for keyboard accessibility (Success Criteria 2.1.1, 2.1.2, 2.4.3, 2.4.7).

## Core Principles

1. **All functionality available via keyboard** - No mouse required
2. **No keyboard traps** - Users can always navigate away
3. **Visible focus indicators** - Always clear which element has focus
4. **Logical tab order** - Focus moves in predictable sequence

## Global Navigation

### Window Management

| Shortcut | Action |
|----------|--------|
| `Alt+Tab` | Switch between windows |
| `Alt+Shift+Tab` | Switch windows (reverse) |
| `Alt+F4` | Close window |
| `Super+Up` | Maximize window |
| `Super+Down` | Minimize/restore window |
| `Super+Left/Right` | Tile window left/right |
| `Alt+F3` | Window operations menu |

### Desktop Navigation

| Shortcut | Action |
|----------|--------|
| `Super+1-4` | Switch to desktop 1-4 |
| `Super+Ctrl+Left/Right` | Previous/next desktop |
| `Super+Tab` | Overview (all windows) |
| `Super+D` | Show desktop |

### Application Launching

| Shortcut | Action |
|----------|--------|
| `Super` | Application launcher |
| `Super+Space` | Search/launcher (KRunner) |
| `Super+E` | File manager |
| `Ctrl+Alt+T` | Terminal |
| `Super+I` | System Settings |

## Focus Navigation

### Tab Navigation

- `Tab` - Move focus to next element
- `Shift+Tab` - Move focus to previous element
- Focus cycles through: buttons, links, form fields, toolbars

### Arrow Key Navigation

**Lists and Menus:**
- `Up/Down` - Previous/next item
- `Home/End` - First/last item
- `Enter` - Select item

**Grids and Tables:**
- `Up/Down` - Previous/next row
- `Left/Right` - Previous/next column
- `Ctrl+Home/End` - First/last cell

### Activation

- `Enter` - Activate focused button/link
- `Space` - Toggle checkbox, press button
- `Escape` - Close dialog, cancel action

## Skip Links

Jump to main content areas:

| Shortcut | Target |
|----------|--------|
| `Alt+1` | Main content area |
| `Alt+2` | Navigation |
| `Alt+3` | Search field |

## Focus Indicators

Default focus ring: 3px solid border, high contrast color (#1A73E8).

Enhanced focus (accessibility mode):
```ini
[Focus]
EnhancedFocus=true
FocusWidth=4
FocusColor=#1A73E8
```

## Sticky Keys

For users who cannot press multiple keys simultaneously:

```bash
sanchala-accessibility sticky-keys enable
```

- Press modifier once → applies to next key
- Press modifier twice → locks modifier
- Audio and visual feedback included

## Mouse Keys

Control mouse pointer with numeric keypad (`Alt+Shift+Num Lock`):

```
7 8 9   (diagonal + up)
4 5 6   (left, click, right)  
1 2 3   (diagonal + down)
```

- `5` = left click, `+` = right click
- `0` = begin drag, `.` = drop

## Configuration

File: `~/.config/sanchala/accessibility/keyboard-nav.conf`

```ini
[General]
Enabled=true
AlwaysShowFocus=true

[FocusIndicator]
Width=3
Color=#1A73E8

[TabNavigation]
TabCycleAll=true
TabWrap=true

[Shortcuts]
SkipToMain=Alt+1
AccessibilityPanel=Super+U
```
