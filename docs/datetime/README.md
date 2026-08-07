# SANCHALA OS - Date/Time Systems Documentation

## Overview

SANCHALA OS provides a comprehensive, reliable time management system with automatic synchronization, timezone detection, world clocks, and productivity tools.

## Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                    SANCHALA TIME MANAGEMENT                         │
├─────────────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌────────────┐ │
│  │  NTP Sync   │  │  Timezone   │  │ World Clock │  │   Timer    │ │
│  │  Service    │  │  Detection  │  │   Widget    │  │   Alarm    │ │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘  └─────┬──────┘ │
│         │                │                │                │        │
│         └────────────────┼────────────────┼────────────────┘        │
│                          ▼                ▼                         │
│              ┌───────────────────────────────────────┐              │
│              │      System Time Infrastructure       │              │
│              │   (systemd-timesyncd + timedatectl)   │              │
│              └───────────────────────────────────────┘              │
│                          │                │                         │
│         ┌────────────────┼────────────────┼────────────────┐        │
│         ▼                ▼                ▼                ▼        │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌────────────┐ │
│  │  Calendar   │  │    Focus    │  │   Desktop   │  │  Hardware  │ │
│  │  Events     │  │    Modes    │  │   Widgets   │  │    RTC     │ │
│  └─────────────┘  └─────────────┘  └─────────────┘  └────────────┘ │
└─────────────────────────────────────────────────────────────────────┘
```

## Components

### 1. NTP Time Synchronization
- **Config**: `/etc/systemd/timesyncd.conf`
- **Service**: systemd-timesyncd
- Uses pool.ntp.org with geographic routing
- NTS (Network Time Security) support
- Battery-aware polling intervals

### 2. Timezone Auto-Detection
- **Config**: `~/.config/sanchala/timezone.conf`
- GPS, network, and IP-based detection
- Privacy-respecting (approximate location only)
- Travel mode with dual-time display
- DST transition notifications

### 3. World Clock Widget
- **Config**: `~/.config/sanchala/world-clock.conf`
- Desktop widget and system tray
- Meeting planner with overlap finder
- Business hours highlighting
- Up to 8 simultaneous clocks

### 4. Timer & Alarm App
- **Config**: `~/.config/sanchala/timer-alarm.conf`
- Multiple alarms with smart wake
- Timer presets and custom timers
- Stopwatch with lap tracking
- Pomodoro technique support

### 5. Calendar Notifications
- **Config**: `~/.config/sanchala/calendar-notifications.conf`
- Smart reminders with travel time
- Video meeting quick-join
- Morning agenda briefings
- Conflict detection

## Configuration Files

| File | Location | Purpose |
|------|----------|---------|
| timesyncd.conf | /etc/systemd/ | NTP server configuration |
| timezone.conf | ~/.config/sanchala/ | Timezone detection settings |
| world-clock.conf | ~/.config/sanchala/ | World clock widget |
| timer-alarm.conf | ~/.config/sanchala/ | Timer/alarm application |
| calendar-notifications.conf | ~/.config/sanchala/ | Event notifications |

## Quick Start

### Check Time Sync Status
```bash
timedatectl status
timedatectl timesync-status
```

### Set Timezone Manually
```bash
timedatectl set-timezone America/New_York
timedatectl list-timezones | grep America
```

### Enable NTP
```bash
sudo timedatectl set-ntp true
```

## Key Features

### Smart Alarms
- Gradual volume increase for gentle wake
- Pre-alarm soft sound 5 minutes before
- Sleep tracking integration (optional)
- Skip alarms on holidays

### Travel Mode
- Automatic timezone detection
- Show both home and local time
- Calendar adjustments
- Return detection

### Pomodoro Timer
- 25-minute work sessions
- 5-minute short breaks
- 15-minute long breaks every 4 sessions
- Focus mode integration
- Statistics tracking

## Integration Points

- **Calendar**: KOrganizer, Kalendar, Thunderbird, CalDAV
- **Focus Modes**: Automatic DND during Pomodoro
- **Notifications**: Full system notification integration
- **Cloud Sync**: Alarms and world clocks sync across devices
