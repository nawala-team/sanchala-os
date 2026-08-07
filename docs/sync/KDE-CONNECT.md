# KDE Connect Setup Guide

## What is KDE Connect?

KDE Connect is the backbone of Sanchala's phone integration, providing:
- Wireless file transfer
- Clipboard synchronization  
- Notification mirroring
- SMS messaging from desktop
- Media player control
- Remote input (mouse/keyboard)
- Phone battery status

## Installation

### On Your Phone

**Android:**
- Google Play Store: Search "KDE Connect"
- F-Droid: Available in main repository
- Direct APK: https://kdeconnect.kde.org/download.html

**iOS:**
- App Store: Search "KDE Connect" (limited features)

### On Desktop (Pre-installed in Sanchala)

```bash
# Already included, verify installation
kdeconnect-cli --version
```

## Pairing Process

### Step 1: Network Requirements

Both devices must be on the same local network:
- Same WiFi network
- Or wired + WiFi on same subnet
- Firewall must allow ports 1714-1764

### Step 2: Discovery

```bash
# List available (unpaired) devices
kdeconnect-cli --list-available

# Example output:
# - My Phone: abc123def456...
```

### Step 3: Pair

```bash
# Send pairing request
sanchala-sync kdc pair abc123def456

# Or use the GUI
# System Settings → KDE Connect → Request Pair
```

### Step 4: Accept on Phone

- Open KDE Connect app on phone
- Tap the pairing notification
- Confirm the pairing request

### Step 5: Verify

```bash
# List paired devices
kdeconnect-cli --list-devices

# Should show your phone as "paired and reachable"
```

## Firewall Configuration

```bash
# If using firewalld
sudo firewall-cmd --permanent --add-port=1714-1764/tcp
sudo firewall-cmd --permanent --add-port=1714-1764/udp
sudo firewall-cmd --reload

# If using ufw
sudo ufw allow 1714:1764/tcp
sudo ufw allow 1714:1764/udp
```

## Plugin Configuration

Edit `~/.config/kdeconnect/plugins.conf` or use System Settings.

### Essential Plugins

| Plugin | Function |
|--------|----------|
| battery | Phone battery in system tray |
| clipboard | Universal clipboard sync |
| notifications | Mirror phone notifications |
| telephony | Call notifications |
| sms | Send/receive SMS |
| share | File sharing |
| sftp | Browse phone files |

### Privacy-Focused Defaults

```ini
[Plugin][notifications]
showContent=true
allowDismiss=true
allowReply=true
blockedApps=com.android.systemui

[Plugin][clipboard]
autoSync=true
encryptClipboard=true
excludePatterns=password,secret,token
```

## Common Commands

```bash
# Ping device
kdeconnect-cli --ping -d <device_id>

# Share file
kdeconnect-cli --share /path/to/file -d <device_id>

# Share clipboard
kdeconnect-cli --share-text "Hello" -d <device_id>

# Ring phone (find my phone)
kdeconnect-cli --ring -d <device_id>

# Send SMS
kdeconnect-cli --send-sms "Message" --destination "+1234567890" -d <device_id>

# List SMS conversations
kdeconnect-cli --list-sms -d <device_id>
```

## Troubleshooting

### Device Not Found

1. Check both devices on same network
2. Restart KDE Connect on both devices
3. Check firewall settings
4. Try Bluetooth discovery as fallback

### Pairing Fails

1. Ensure KDE Connect app is open on phone
2. Check for pending pairing requests
3. Unpair and try again
4. Restart both devices

### Clipboard Not Syncing

1. Verify clipboard plugin enabled on both devices
2. Check KDE Connect app permissions on phone
3. Test with simple text first

### Notifications Not Appearing

1. Grant notification access in phone settings
2. Check app isn't in blocked list
3. Verify plugin configuration
