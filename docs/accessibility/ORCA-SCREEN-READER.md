# Orca Screen Reader Configuration Guide

This document covers the Orca screen reader integration in Sanchala OS.

## Overview

Orca is the default screen reader for Sanchala OS, providing:
- Text-to-speech output via Speech Dispatcher
- Braille display support
- Magnification integration
- Web and document navigation

## Installation

Orca is pre-installed in Sanchala OS. If needed:

```bash
sudo pacman -S orca speech-dispatcher espeak-ng
```

## Quick Start

### Enable Orca

```bash
# Via command line
sanchala-accessibility screen-reader start

# Or keyboard shortcut
Alt+Super+S
```

### First Run

On first launch, Orca presents a configuration wizard:

1. **Voice Selection** - Choose speech synthesizer and voice
2. **Speech Rate** - Adjust reading speed
3. **Key Echo** - Configure what keystrokes are announced
4. **Modifier Key** - Choose Insert or Caps Lock as Orca modifier

## Configuration

### Configuration File

Location: `~/.config/orca/user-settings.conf`

### Speech Settings

```python
# Speech rate (0-100, default 50)
orca.settings.speechRate = 50

# Speech pitch (0-10, default 5)
orca.settings.speechPitch = 5.0

# Speech volume (0-10, default 10)
orca.settings.speechVolume = 10.0
```

### Verbosity

```python
# Punctuation: NONE, SOME, MOST, ALL
orca.settings.verbalizePunctuationStyle = orca.settings.PUNCTUATION_STYLE_SOME

# Verbosity: BRIEF, VERBOSE
orca.settings.speechVerbosityLevel = orca.settings.VERBOSITY_LEVEL_VERBOSE
```

### Key Echo

```python
orca.settings.enableKeyEcho = True
orca.settings.enableEchoByWord = True      # Speak words as typed
orca.settings.enableEchoByCharacter = False # Speak each character
orca.settings.enableModifierKeys = True     # Announce Ctrl, Alt, etc.
orca.settings.enableFunctionKeys = True     # Announce F1-F12
```

## Keyboard Commands

### Orca Modifier Key

The Orca modifier (Insert or Caps Lock) is used with other keys:

| Shortcut | Action |
|----------|--------|
| `Orca+H` | Enter help mode |
| `Orca+Space` | Open preferences |
| `Orca+S` | Toggle speech |
| `Orca+Q` | Quit Orca |
| `Orca+F` | Read current item |
| `Orca+Tab` | Read window title |

### Flat Review

Navigate screen content independently of focus:

| Shortcut | Action |
|----------|--------|
| `Orca+Up` | Previous line |
| `Orca+Down` | Next line |
| `Orca+Left` | Previous word |
| `Orca+Right` | Next word |
| `Orca+Home` | Top of window |
| `Orca+End` | Bottom of window |

### Table Navigation

| Shortcut | Action |
|----------|--------|
| `Alt+Shift+Up` | Previous row |
| `Alt+Shift+Down` | Next row |
| `Alt+Shift+Left` | Previous column |
| `Alt+Shift+Right` | Next column |

### Web Navigation

| Shortcut | Action |
|----------|--------|
| `H` | Next heading |
| `Shift+H` | Previous heading |
| `L` | Next link |
| `B` | Next button |
| `F` | Next form field |
| `T` | Next table |
| `1-6` | Heading level 1-6 |

## Speech Dispatcher

Orca uses Speech Dispatcher for speech output.

### Configuration

Location: `~/.config/speech-dispatcher/speechd.conf`

### Available Voices

```bash
# List available voices
spd-say -L

# Test voice
spd-say "Hello, this is a test"
```

### Supported Synthesizers

- **espeak-ng** (default) - Lightweight, many languages
- **Festival** - Natural sounding
- **Pico TTS** - Android TTS engine
- **SVOX** - Commercial quality

## Braille Support

### Enable Braille

```python
orca.settings.enableBraille = True
orca.settings.brailleRolenameStyle = orca.settings.BRAILLE_ROLENAME_STYLE_LONG
```

### Supported Displays

Orca supports displays via BRLTTY:
- Freedom Scientific
- HumanWare
- HIMS
- Baum
- And many more

### Configuration

```bash
# Install BRLTTY
sudo pacman -S brltty

# Configure display
sudo brltty-setup
```

## Troubleshooting

### No Speech Output

1. Check Speech Dispatcher:
   ```bash
   systemctl --user status speech-dispatcher
   ```

2. Test speech:
   ```bash
   spd-say "test"
   ```

3. Check audio:
   ```bash
   pactl list sinks
   ```

### Orca Not Starting

1. Check dependencies:
   ```bash
   pacman -Q orca at-spi2-core speech-dispatcher
   ```

2. Enable AT-SPI:
   ```bash
   gsettings set org.gnome.desktop.interface toolkit-accessibility true
   ```

### Application Not Accessible

Some applications need AT-SPI enabled:

```bash
# For GTK apps
export GTK_MODULES=gail:atk-bridge

# For Qt apps
export QT_ACCESSIBILITY=1
```

## Integration with Sanchala OS

### Auto-Start on Login

```ini
# ~/.config/sanchala/accessibility/accessibility.conf
[ScreenReader]
Enabled=true
AutoStart=true
```

### System Settings Integration

Access via: System Settings → Accessibility → Screen Reader

### Notification Announcements

Orca announces system notifications when enabled:

```ini
[ScreenReader]
AnnounceNotifications=true
```

## Resources

- Orca User Guide: https://help.gnome.org/users/orca/stable/
- Speech Dispatcher: https://freebsoft.org/speechd
- BRLTTY: https://brltty.app/
