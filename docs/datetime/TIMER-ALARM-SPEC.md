# Timer & Alarm Application Specification

## Overview

The SANCHALA TimeKeeper application provides comprehensive time management tools including alarms, timers, stopwatch, and Pomodoro functionality.

## D-Bus Interface

**Service**: `org.sanchala.TimeKeeper`
**Object Path**: `/org/sanchala/TimeKeeper`

### Methods

```xml
<interface name="org.sanchala.TimeKeeper.Alarm">
  <method name="Create">
    <arg name="time" type="s" direction="in"/>
    <arg name="label" type="s" direction="in"/>
    <arg name="recurring" type="s" direction="in"/>
    <arg name="alarm_id" type="u" direction="out"/>
  </method>
  <method name="Delete">
    <arg name="alarm_id" type="u" direction="in"/>
  </method>
  <method name="Enable">
    <arg name="alarm_id" type="u" direction="in"/>
    <arg name="enabled" type="b" direction="in"/>
  </method>
  <method name="Snooze">
    <arg name="alarm_id" type="u" direction="in"/>
    <arg name="minutes" type="u" direction="in"/>
  </method>
  <method name="List">
    <arg name="alarms" type="a(ussbss)" direction="out"/>
  </method>
</interface>

<interface name="org.sanchala.TimeKeeper.Timer">
  <method name="Start">
    <arg name="seconds" type="u" direction="in"/>
    <arg name="label" type="s" direction="in"/>
    <arg name="timer_id" type="u" direction="out"/>
  </method>
  <method name="Pause">
    <arg name="timer_id" type="u" direction="in"/>
  </method>
  <method name="Resume">
    <arg name="timer_id" type="u" direction="in"/>
  </method>
  <method name="Cancel">
    <arg name="timer_id" type="u" direction="in"/>
  </method>
</interface>

<interface name="org.sanchala.TimeKeeper.Pomodoro">
  <method name="Start">
    <arg name="task" type="s" direction="in"/>
  </method>
  <method name="Stop"/>
  <method name="Skip"/>
  <method name="GetStatus">
    <arg name="status" type="(suu)" direction="out"/>
  </method>
</interface>
```

## Alarm Features

### Types
- **One-time**: Single occurrence
- **Daily**: Every day at specified time
- **Weekdays**: Monday through Friday
- **Weekends**: Saturday and Sunday
- **Weekly**: Specific days of week
- **Custom**: User-defined pattern

### Smart Wake
```
┌─────────────────────────────────────────┐
│  SMART ALARM TIMELINE                   │
├─────────────────────────────────────────┤
│                                         │
│  -5min     -30sec    0         +snooze  │
│    │          │      │            │     │
│    ▼          ▼      ▼            ▼     │
│  Pre-alarm  Fade   ALARM      Snooze    │
│  (soft)     Start  (full)     (repeat)  │
│                                         │
└─────────────────────────────────────────┘
```

## Timer Presets

| Name | Duration | Use Case |
|------|----------|----------|
| 1 minute | 60s | Quick reminder |
| 3 minutes | 180s | Brewing tea |
| 5 minutes | 300s | Short break |
| 10 minutes | 600s | Power nap |
| 15 minutes | 900s | Focused task |
| 30 minutes | 1800s | Meeting |
| 1 hour | 3600s | Deep work |
| 2 hours | 7200s | Extended session |

## Pomodoro Workflow

```
┌──────────────────────────────────────────────────────────┐
│                    POMODORO CYCLE                        │
├──────────────────────────────────────────────────────────┤
│                                                          │
│  ┌─────┐   ┌─────┐   ┌─────┐   ┌─────┐   ┌──────────┐  │
│  │WORK │──▶│BREAK│──▶│WORK │──▶│BREAK│──▶│   WORK   │  │
│  │25min│   │5min │   │25min│   │5min │   │  25min   │  │
│  └─────┘   └─────┘   └─────┘   └─────┘   └────┬─────┘  │
│                                               │         │
│  ┌─────┐   ┌─────┐                           ▼         │
│  │WORK │◀──│LONG │◀────────────────────────────        │
│  │25min│   │BREAK│                                     │
│  └─────┘   │15min│  (After 4 pomodoros)                │
│            └─────┘                                      │
└──────────────────────────────────────────────────────────┘
```

## Notification Actions

### Alarm Notification
- **Dismiss**: Stop alarm completely
- **Snooze**: Delay by configured minutes
- **Stop All**: Cancel all active alarms

### Timer Notification
- **Dismiss**: Acknowledge completion
- **Restart**: Run same timer again
- **Add Time**: Extend by 1/5/10 minutes

## Keyboard Shortcuts

| Action | Shortcut |
|--------|----------|
| Open TimeKeeper | Meta+A |
| Quick Alarm | Meta+Shift+A |
| Quick Timer | Meta+T |
| Toggle Stopwatch | Meta+Shift+S |
| Start Pomodoro | Meta+P |
| Dismiss | Escape |
| Snooze | Space |

## Integration

### Focus Mode
- Pomodoro auto-enables focus mode
- Suppresses non-critical notifications
- Status shown in system tray

### Calendar
- Import calendar events as alarms
- Sync recurring alarms
- Meeting reminders

### Cloud Sync
- Alarms sync across devices
- Pomodoro statistics shared
- Timer presets synchronized
