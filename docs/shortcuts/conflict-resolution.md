# Shortcut Conflict Resolution

Guidelines for resolving keyboard shortcut conflicts in Sanchala OS.

## Common Conflicts

### Global vs Application Shortcuts

| Shortcut | Global Action | May Conflict With |
|----------|---------------|-------------------|
| `Ctrl+Q` | - | App Quit (use Alt+F4 globally) |
| `Ctrl+W` | - | Close Tab (app-specific) |
| `F11` | Fullscreen | App Fullscreen |
| `Super+V` | Clipboard | Some apps use Ctrl+V |

### Resolution Strategy

1. **Global shortcuts use Super key** - System-level actions
2. **App shortcuts use Ctrl key** - Application-level actions
3. **Alt key for window operations** - Alt+Tab, Alt+F4, etc.
4. **Function keys for toggles** - F11 fullscreen, F3 split view

## Reserved Shortcuts

These shortcuts are reserved system-wide:

| Shortcut | Reserved For |
|----------|-------------|
| `Super` | App Launcher |
| `Alt+Tab` | Window Switching |
| `Alt+F4` | Close Window |
| `Ctrl+Alt+Delete` | Session Menu |
| `Ctrl+Alt+L` | Lock Screen |
| `Ctrl+Alt+T` | Terminal |
| `Print` | Screenshot |

## Checking for Conflicts

### Command Line
```bash
# Find all shortcuts containing a key
grep -r "Ctrl+F" ~/.config/*shortcutsrc

# List all global shortcuts
cat ~/.config/kglobalshortcutsrc | grep -v "^#" | grep "="
```

### GUI
1. System Settings → Shortcuts
2. Type the key combination in search
3. View all actions using that shortcut

## Sanchala Shortcut Hierarchy

1. **Session shortcuts** (highest priority)
   - Lock, logout, shutdown
   
2. **Window manager shortcuts**
   - Tiling, desktops, window operations
   
3. **Global application launchers**
   - Super+E, Ctrl+Alt+T, etc.
   
4. **Application shortcuts** (lowest priority)
   - Handled by focused application
