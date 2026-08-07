# Notification Troubleshooting Guide

> Common issues and solutions

## Notifications Not Showing

### Check DND Status
```bash
# Check if DND is enabled
grep -E "^Enabled=" ~/.config/plasmanotifyrc | head -1

# Disable DND
kwriteconfig5 --file plasmanotifyrc --group DoNotDisturb --key Enabled false
```

### Check Focus Mode
```bash
# Check active focus mode
grep "ActiveMode=" ~/.config/sanchala/focus-modes.conf
```

### Verify App Settings
```bash
# Check if app notifications are enabled
grep -A5 "\[Applications\]\[app-name\]" ~/.config/plasmanotifyrc
```

### Check Notification Service
```bash
# Restart notification service
kquitapp5 plasmashell && kstart5 plasmashell
```

## Notifications Not Making Sound

### Check Sound Settings
```ini
# ~/.config/plasmanotifyrc
[Sounds]
Enabled=true
Volume=80
UseSystemVolume=true
```

### Check System Volume
```bash
# Check PipeWire/PulseAudio volume
pactl get-sink-volume @DEFAULT_SINK@
```

### Check DND Sound Muting
```ini
[DoNotDisturb]
NotificationSoundsMuted=false  # Set to false to allow sounds
```

## Focus Mode Not Auto-Activating

### Check Automation Settings
```ini
[Work][Automation]
Enabled=true              # Must be true
WiFiNetworks=my-network   # Correct network name
TriggerApps=code          # Correct app name
```

### Check WiFi Network Name
```bash
# Get current WiFi network
nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2
```

### Check Running Apps
```bash
# List running apps
kdotool search --name ".*" | head -20
```

## Critical Alerts Not Breaking Through

### Verify Critical Alert Settings
```ini
# ~/.config/sanchala/critical-alerts.conf
[General]
Enabled=true
BypassAllFilters=true
BypassDND=true
```

### Check Category Configuration
```ini
[Category][security]
Enabled=true
Sources=sanchala-guardian
```

## Notification History Missing

### Check History Settings
```ini
# ~/.config/sanchala/notification-history.conf
[General]
Enabled=true
MaxNotifications=1000
PersistHistory=true
```

### Check Storage Path
```bash
# Verify history database exists
ls -la ~/.local/share/sanchala/notifications/
```

### Rebuild History Database
```bash
# Backup and rebuild
mv ~/.local/share/sanchala/notifications/history.db{,.bak}
# Restart notification service
```

## Rules Not Working

### Check Rule Syntax
```ini
[Rule][MyRule]
Enabled=true              # Must be enabled
Priority=500              # Higher = evaluated first
Conditions=app:myapp      # Valid condition
Action=silence            # Valid action
```

### Debug Rules
```ini
[General]
LogRuleMatches=true       # Enable logging
```

```bash
# Check logs
journalctl --user -u plasma-notify -f
```

## Reset to Defaults

```bash
# Backup current config
mkdir -p ~/notification-backup
cp ~/.config/plasmanotifyrc ~/notification-backup/
cp -r ~/.config/sanchala/notification* ~/notification-backup/
cp -r ~/.config/sanchala/focus* ~/notification-backup/
cp -r ~/.config/sanchala/critical* ~/notification-backup/

# Reset to defaults
cp /etc/skel/.config/plasmanotifyrc ~/.config/
cp /etc/skel/.config/sanchala/*.conf ~/.config/sanchala/

# Restart
kquitapp5 plasmashell && kstart5 plasmashell
```

## Getting Help

1. Check system logs: `journalctl --user -f`
2. Plasma notification logs: `journalctl -u plasma*`
3. File a bug: [GitHub Issues](https://github.com/sanchala-os/issues)
4. Community forum: [forum.sanchala.id](https://forum.sanchala.id)
