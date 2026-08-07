# World Clock Widget Guide

## Overview

The World Clock widget displays multiple timezones simultaneously on your desktop and system tray.

## Configuration

**File**: `~/.config/sanchala/world-clock.conf`

## Adding Clocks

### Via Configuration
```ini
[Clocks]
Clock1=America/New_York|New York|true
Clock2=Europe/London|London|true
Clock3=Asia/Tokyo|Tokyo|true
Clock4=Australia/Sydney|Sydney|true
```

Format: `Timezone|Label|Enabled`

### Via GUI
1. Click world clock widget
2. Select "Add Clock"
3. Search for city or timezone
4. Click to add

### Keyboard Shortcut
Press `Meta+Shift+W` to quickly add a new clock.

## Display Options

### Clock Styles
- **Digital**: Time in numbers (default)
- **Analog**: Traditional clock face
- **Both**: Combined display

### Information Shown
```ini
[Display]
ShowLocationName=true
ShowCountryFlag=true
ShowTimezoneAbbrev=true
ShowUTCOffset=true
ShowDate=true
ShowDayNight=true
ShowRelativeTime=true
HighlightBusinessHours=true
```

## Widget Layouts

### Horizontal (Default)
```
┌──────────────────────────────────────────────────────┐
│ 🇺🇸 New York   │ 🇬🇧 London    │ 🇯🇵 Tokyo      │
│   14:30 EST    │   19:30 GMT   │   04:30+1 JST  │
│   -5 hours     │   Local       │   +9 hours     │
└──────────────────────────────────────────────────────┘
```

### Vertical
```
┌─────────────────┐
│ 🇺🇸 New York    │
│   14:30 EST     │
├─────────────────┤
│ 🇬🇧 London      │
│   19:30 GMT     │
├─────────────────┤
│ 🇯🇵 Tokyo       │
│   04:30+1 JST   │
└─────────────────┘
```

### Grid
```
┌─────────────┬─────────────┐
│ New York    │ London      │
│ 14:30       │ 19:30       │
├─────────────┼─────────────┤
│ Tokyo       │ Sydney      │
│ 04:30+1     │ 06:30+1     │
└─────────────┴─────────────┘
```

## Meeting Planner

Find overlapping business hours across timezones:

```ini
[Meetings]
MeetingPlanner=true
FindOverlap=true
MinOverlapMinutes=60
BusinessHoursStart=09:00
BusinessHoursEnd=17:00
```

### Usage
1. Open world clock popup
2. Click "Meeting Planner"
3. Select participants' timezones
4. View suggested meeting times

### Copy Format
```ini
CopyFormat={time} {timezone} / {utc}
```
Example: "14:00 EST / 19:00 UTC"

## System Tray

### Display Modes
- **Primary**: Shows one selected clock
- **Rotating**: Cycles through clocks
- **Multi**: Shows multiple mini-clocks

```ini
[SystemTray]
Enabled=true
TrayMode=rotating
RotationInterval=5
```

## Keyboard Shortcuts

| Action | Shortcut |
|--------|----------|
| Toggle Widget | Meta+W |
| Add Clock | Meta+Shift+W |
| Meeting Planner | Meta+Alt+W |
| Quick Convert | Meta+Ctrl+T |

## Quick Time Conversion

Press `Meta+Ctrl+T` for instant conversion:
1. Enter time (e.g., "3pm")
2. Select source timezone
3. See conversion to all configured clocks

## Popular Cities

Quick-add preset for common cities:
- New York, London, Tokyo, Paris
- Sydney, Dubai, Singapore, Hong Kong
- Mumbai, Berlin, Moscow, São Paulo
- Toronto, Chicago, San Francisco
