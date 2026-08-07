# Timezone Auto-Detection Guide

## Overview

SANCHALA OS automatically detects and sets the correct timezone using multiple privacy-respecting methods.

## Detection Methods

### Priority Order
1. **GPS/GNSS** - Most accurate, requires location hardware
2. **Network** - Cell towers and WiFi positioning
3. **Geolocation** - IP-based lookup (privacy-focused)
4. **Manual** - User-configured fallback

## Configuration

**File**: `~/.config/sanchala/timezone.conf`

```ini
[General]
AutoDetect=true
DetectionOrder=gps,network,geolocation,manual
ConfirmChanges=true
NotifyOnChange=true
```

## Privacy Features

SANCHALA prioritizes privacy in timezone detection:

| Feature | Description |
|---------|-------------|
| Approximate Only | Uses city-level, not exact location |
| No History | Location data not stored |
| Anonymous Requests | No identifying information sent |
| Offline Database | Local timezone lookup available |

### Offline Mode
```ini
[Privacy]
UseOfflineDatabase=true
OfflineDatabasePath=/usr/share/sanchala/timezone/tzdb.dat
```

The offline database maps coordinates to timezones without network requests.

## Travel Mode

Automatic detection when traveling:

```ini
[Travel]
AutoTravelMode=true
ShowDualTime=true
HomeTimezone=America/New_York
NotifyOnTravel=true
AutoRevert=true
RevertDelay=24
```

### Dual Time Display
When traveling, both home and local time appear in:
- System clock widget
- Calendar events
- Alarm displays

## DST Handling

Daylight Saving Time transitions are managed automatically:

```ini
[DST]
NotifyDSTChange=true
NotifyHoursBefore=24
AddDSTToCalendar=true
AutoAdjustAlarms=true
ShowDSTIndicator=true
```

### Notifications
- 24 hours before: "Clocks spring forward tomorrow at 2:00 AM"
- Day of: "Daylight Saving Time is now in effect"

### Alarm Adjustment
Alarms automatically adjust for DST:
- 7:00 AM alarm stays at 7:00 AM local time
- No missed wake-ups during transitions

## Manual Override

### Set Timezone via CLI
```bash
# List available timezones
timedatectl list-timezones

# Set timezone
sudo timedatectl set-timezone Europe/London

# Verify
timedatectl status
```

### Set in Configuration
```ini
[General]
AutoDetect=false
ManualTimezone=Asia/Tokyo
```

## Geolocation Services

### Mozilla Location Service (Default)
- Privacy-focused
- No account required
- Uses WiFi/cell data

### Fallback Services
- ip-api.com
- ipinfo.io

```ini
[GeoLocation]
Providers=mozilla,ip-api,ipinfo
CacheDuration=24
MinAccuracyKm=100
```

## Troubleshooting

### Timezone Not Detected
1. Check network connectivity
2. Verify location services enabled
3. Try manual setting temporarily

### Wrong Timezone
```bash
# Check current setting
timedatectl status

# Force re-detection
sanchala-timezone --detect

# Set manually
timedatectl set-timezone <correct-timezone>
```

### DST Issues
- Verify timezone is correct (not just offset)
- Check `/etc/localtime` symlink
- Ensure tzdata package is updated
