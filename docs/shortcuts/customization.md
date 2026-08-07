# Shortcut Customization Guide

How to customize keyboard shortcuts in Sanchala OS.

## Using System Settings

1. Open **System Settings** (`Super+I`)
2. Navigate to **Shortcuts**
3. Choose a category:
   - **Shortcuts** - Global system shortcuts
   - **Custom Shortcuts** - User-defined actions

## Configuration Files

### Global Shortcuts
```
~/.config/kglobalshortcutsrc
```

Format:
```ini
[component]
Action Name=Shortcut,Default,Description
```

### Window Manager Shortcuts
```
~/.config/kwinshortcutsrc
```

### Custom Actions
```
~/.config/khotkeysrc
```

## Creating Custom Shortcuts

### Via GUI
1. System Settings → Shortcuts → Custom Shortcuts
2. Edit → New → Global Shortcut → Command/URL
3. Set trigger (shortcut) and action (command)

### Via Config File

Add to `~/.config/khotkeysrc`:

```ini
[Data_X_Y]
Comment=My custom action
Enabled=true
Name=My Shortcut
Type=SIMPLE_ACTION_DATA

[Data_X_YActions]
ActionsCount=1

[Data_X_YActions0]
CommandURL=my-command
Type=COMMAND_URL

[Data_X_YTriggers]
TriggersCount=1

[Data_X_YTriggers0]
Key=Super+Shift+M
Type=SHORTCUT
```

## Resolving Conflicts

If a shortcut doesn't work:

1. Check for conflicts: System Settings → Shortcuts
2. Search for the key combination
3. Reassign or disable conflicting shortcuts

## Restoring Defaults

```bash
# Backup current shortcuts
cp ~/.config/kglobalshortcutsrc ~/.config/kglobalshortcutsrc.bak

# Restore Sanchala defaults
cp /etc/skel/.config/kglobalshortcutsrc ~/.config/
cp /etc/skel/.config/kwinshortcutsrc ~/.config/
cp /etc/skel/.config/khotkeysrc ~/.config/

# Restart KWin
kwin_x11 --replace &
# or for Wayland:
# Log out and back in
```

## Best Practices

1. Use `Super` for system actions
2. Use `Ctrl` for application actions
3. Use `Alt` for window management
4. Keep shortcuts consistent across apps
5. Document custom shortcuts
