# ⚙️ SANCHALA OS - Clipboard Configuration Reference

## Configuration Files

| File | Purpose |
|------|---------|
| `~/.config/klipperrc` | Klipper backend settings |
| `~/.config/sanchala/clipboard.conf` | Sanchala clipboard extensions |
| `~/.config/kglobalshortcutsrc` | Keyboard shortcuts |

## Complete Settings Reference

### General Settings

```ini
[General]
KeepClipboardContents=true       # Keep clipboard across logout
PreventEmptyClipboard=true       # Prevent empty clipboard
MaxClipItems=100                 # Maximum history items (1-1000)
SyncClipboards=true              # Sync X11 clipboard and selection
IgnoreImages=false               # Support images
PopupAtMousePosition=true        # Popup at mouse position
```

### History Settings

```ini
[History]
MaxItems=100                     # Maximum items (1-1000)
MaxItemSize=10485760             # Max size per item (10MB)
PersistHistory=true              # Persist across sessions
MaxAgeDays=30                    # Auto-expire (0=never)
RemoveDuplicates=true            # Remove duplicates
ShowTimestamps=true              # Show timestamps
SearchEnabled=true               # Enable search
FuzzySearch=true                 # Fuzzy search
```

### Security Settings

```ini
[Security]
Enabled=true                     # Enable protection
AutoClearTimeout=30              # Auto-clear timeout (seconds)
SensitivePatterns=password,secret,token,api_key
PasswordManagerApps=keepassxc,bitwarden,1password
DetectCreditCards=true
DetectAPIKeys=true
DetectOTP=true
OTPClearTimeout=60               # OTP timeout (seconds)
ExcludeSensitiveFromHistory=true
ClearOnLogout=true
NotifyOnAutoClear=true
```

### Sync Settings

```ini
[Sync]
Enabled=true                     # Enable sync
Provider=kdeconnect              # Sync provider
SyncMode=auto                    # auto/manual/ask
SyncDirection=both               # both/send/receive
SyncText=true
SyncImages=true
MaxTextSyncSize=65536            # 64KB
MaxImageSyncSize=5242880         # 5MB
CompressImagesForSync=true
SyncImageQuality=80
EncryptSync=true
TrustedDevicesOnly=true
SyncSensitiveData=false
NotifyOnReceive=true
SyncDebounce=500                 # milliseconds
```

### Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Meta+V` | Show clipboard history |
| `Meta+Ctrl+V` | Show actions menu |
| `Meta+Shift+V` | Clear clipboard |
| `Meta+Shift+Ctrl+V` | Paste as plain text |
| `Meta+1/2/3` | Quick paste from history |
| `Meta+Ctrl+F` | Search history |
| `Meta+Ctrl+S` | Sync now |

## Default Paths

| Path | Purpose |
|------|---------|
| `~/.local/share/sanchala/clipboard/` | Clipboard data |
| `~/.local/share/sanchala/clipboard/history.db` | History database |
| `~/.local/share/sanchala/clipboard/snippets/` | Text snippets |
| `~/.cache/sanchala/clipboard/` | Thumbnails, cache |

## CLI Commands

```bash
sanchala-clipboard show          # Show current clipboard
sanchala-clipboard history       # Show history
sanchala-clipboard clear         # Clear clipboard
sanchala-clipboard search "q"    # Search history
sanchala-clipboard sync-status   # Sync status
sanchala-clipboard sync-now      # Force sync
```

## D-Bus Interface

```bash
# Get clipboard content
dbus-send --session --dest=org.kde.klipper \
  --print-reply /klipper org.kde.klipper.klipper.getClipboardContents

# Clear history
dbus-send --session --dest=org.kde.klipper \
  /klipper org.kde.klipper.klipper.clearClipboardHistory
```

## Troubleshooting

```bash
# Reset to defaults
cp /etc/skel/.config/klipperrc ~/.config/

# Restart Klipper
kquitapp5 klipper && klipper &

# Check status
pgrep -a klipper
kdeconnect-cli --list-devices
```

---

**Document Version:** 1.0  
**Part of SANCHALA OS** - Universal Clipboard
