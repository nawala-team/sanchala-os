# Focus Modes Guide

> macOS Monterey-style Focus modes for Sanchala OS

## Overview

Focus modes help you concentrate by filtering notifications based on what you're doing. Sanchala OS includes 7 pre-configured focus modes that can be customized or extended.

## Built-in Focus Modes

### 💼 Work
- **Purpose**: Minimize distractions during work hours
- **Allows**: Calendar, email, Slack, Teams, Zoom
- **Silences**: Social media, gaming, personal messaging
- **Auto-triggers**: Work WiFi, productivity apps, schedule (9-5 weekdays)

### 👤 Personal  
- **Purpose**: Connect with friends and family
- **Allows**: Telegram, Signal, Discord, WhatsApp
- **Silences**: Work email, Slack, Teams
- **Auto-triggers**: Home WiFi

### 🌙 Sleep
- **Purpose**: Peaceful rest without interruptions
- **Allows**: Alarms, emergency contacts only
- **Silences**: Everything else
- **Features**: Dim lock screen, night light, dark wallpaper
- **Auto-triggers**: Schedule (10 PM - 7 AM)

### 🎮 Gaming
- **Purpose**: Immersive gaming sessions
- **Allows**: Discord, Steam
- **Silences**: Everything else
- **Features**: Game mode (performance boost)
- **Auto-triggers**: Steam, Lutris, fullscreen games

### 📹 Meeting
- **Purpose**: Stay focused during video calls
- **Allows**: Zoom, Teams, Meet, Slack
- **Silences**: Everything else
- **Features**: Hide notifications during screen share
- **Auto-triggers**: Video call apps, calendar events

### 🚗 Driving
- **Purpose**: Safe driving without distractions
- **Allows**: Calls only (hands-free)
- **Silences**: Everything else
- **Features**: Audio-only mode, auto-reply
- **Auto-triggers**: Bluetooth car connection

### 📖 Reading
- **Purpose**: Quiet time for reading
- **Allows**: Nothing (repeat callers only)
- **Silences**: Everything
- **Features**: Reading mode (warm colors)
- **Auto-triggers**: E-reader apps (Foliate, Calibre)

## Configuration

### Enable/Disable Focus Mode

```ini
# ~/.config/sanchala/focus-modes.conf
[Work]
Enabled=true
```

### Customize Allowed Apps

```ini
[Work][Notifications]
AllowedApps=org.kde.kalendar,slack,custom-app
SilencedApps=discord,telegram-desktop
```

### Set Up Automation

```ini
[Work][Automation]
Enabled=true
WiFiNetworks=office-5g,work-vpn
TriggerApps=code,libreoffice
ScheduleEnabled=true
ScheduleStart=09:00
ScheduleEnd=17:00
ScheduleDays=Mon,Tue,Wed,Thu,Fri
```

### Configure Auto-Reply

```ini
[Driving][Status]
AutoReplyEnabled=true
AutoReplyMessage=I'm driving. I'll reply when I arrive safely.
```

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Meta+Shift+F` | Open Focus Mode menu |
| `Meta+F` | Quick toggle last used Focus |
| `Meta+Shift+D` | Toggle Do Not Disturb |

## Emergency Contacts

Emergency contacts can always reach you, even in Sleep mode:

```ini
[EmergencyContacts]
Enabled=true
ContactIDs=Mom:+1234567890,Partner:+0987654321
```

## Creating Custom Focus Modes

```ini
[CustomMode]
Enabled=true
DisplayName=My Custom Focus
Description=Custom focus mode description
Icon=custom-icon-symbolic
Color=#FF5722

[CustomMode][Notifications]
AllowedApps=app1,app2
SilencedApps=app3,app4
AllowTimeSensitive=true
AllowCalls=true

[CustomMode][Automation]
Enabled=true
TriggerApps=my-trigger-app
ScheduleEnabled=false
```
