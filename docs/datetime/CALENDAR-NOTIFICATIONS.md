# Calendar Event Notifications Guide

## Overview

SANCHALA OS provides intelligent calendar notifications with smart reminders, meeting integration, and daily agenda briefings.

## Configuration

**File**: `~/.config/sanchala/calendar-notifications.conf`

## Reminder System

### Default Reminders
```ini
[Reminders]
DefaultReminders=15,60,1440
NewEventDefaultReminder=15
AllDayReminderTime=09:00
AllDayReminderDays=1
```

Events receive reminders at:
- 15 minutes before
- 1 hour before
- 1 day before (1440 minutes)

### Smart Reminders

Intelligent adjustments based on context:

```ini
[SmartReminders]
Enabled=true
TravelTimeAware=true
TrafficAware=true
WeatherAware=true
LocationAware=true
```

| Feature | Behavior |
|---------|----------|
| Travel Time | Adds commute to reminder |
| Traffic | Earlier warning for congestion |
| Weather | Extra buffer for bad weather |
| Location | Reminds when you should leave |

## Notification Actions

### Meeting Notifications
```
┌─────────────────────────────────────────────┐
│ 📅 Team Standup in 15 minutes              │
│    9:00 AM - Conference Room A              │
│    Join: https://meet.google.com/xyz        │
│                                             │
│  [Join Meeting]  [Snooze 5m]  [Dismiss]    │
└─────────────────────────────────────────────┘
```

### One-Click Video Join
Supported platforms:
- Zoom
- Google Meet
- Microsoft Teams
- Webex
- Jitsi

## Daily Briefings

### Morning Agenda
```ini
[DayView]
MorningAgenda=true
MorningAgendaTime=07:30
```

Notification at 7:30 AM showing today's events.

### Evening Preview
```ini
EveningPreview=true
EveningPreviewTime=21:00
```

Preview of tomorrow's schedule at 9:00 PM.

### Weekly Agenda
```ini
WeeklyAgenda=true
WeeklyAgendaDay=Monday
WeeklyAgendaTime=08:00
```

Monday morning overview of the week ahead.

## Conflict Detection

Automatic warnings for scheduling conflicts:

```ini
[Conflicts]
ConflictDetection=true
DoubleBookWarning=true
TravelConflicts=true
SuggestResolution=true
```

### Conflict Types
- **Double-booking**: Overlapping events
- **Travel conflicts**: No time between locations
- **Back-to-back**: No break between meetings

## Focus Mode Integration

```ini
[Focus]
RespectFocusMode=true
FocusExempt=urgent,medical,family
ShowUpcomingInFocus=true
FocusPreviewMinutes=5
```

During focus mode:
- Non-critical notifications suppressed
- Exempt categories still notify
- 5-minute preview for upcoming events

## Privacy Settings

### Lock Screen Display
```ini
[Privacy]
LockScreenDetails=minimal
```

Options:
- **full**: Show event title and details
- **minimal**: Show time only
- **hidden**: No notification on lock screen

## Calendar Integration

Supported calendar backends:
- KOrganizer / Kalendar (KDE)
- GNOME Calendar
- Thunderbird / Lightning
- CalDAV servers
- Google Calendar
- Microsoft 365

```ini
[Integration]
KDECalendarIntegration=true
CalDAVIntegration=true
GoogleCalendarIntegration=true
```

## Shared Calendar Events

```ini
[Shared]
InviteNotifications=true
UpdateNotifications=true
CancellationNotifications=true
RSVPNotifications=true
```

Notifications for:
- New meeting invitations
- Event updates/changes
- Cancellations
- RSVP responses from attendees

## Keyboard Shortcuts

| Action | Shortcut |
|--------|----------|
| Today's Events | Meta+Shift+T |
| Next Event | Meta+N |
| Dismiss | Escape |
| Snooze | Space |
| Join Meeting | Meta+J |
