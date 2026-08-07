# 📆 Calendar Widget Integration

## Overview

SANCHALA OS integrates calendar events directly into the Plasma desktop, providing at-a-glance access to schedules similar to macOS menu bar calendar.

---

## 🎯 Features

- **Event Display** - Upcoming events in calendar popup
- **Quick Add** - Natural language event creation
- **Reminders** - Desktop notifications for events
- **Birthday Alerts** - From synced contacts
- **Multi-Calendar** - All calendars in one view

---

## 📍 Access Points

### Plasma Calendar Widget
Click the clock in the top panel to see:
- Month calendar view
- Today's events
- Upcoming events (7 days)
- Quick add button

### KRunner Integration
Press `Alt+Space` and type:
- "calendar" - Open KOrganizer
- "event tomorrow" - Create quick event
- "schedule" - Show today's events

---

## ⚙️ Configuration

Location: `~/.config/sanchala/calendar-widget.conf`

```ini
[Widget]
ShowWeekNumbers=true
ShowHolidays=true
HighlightToday=true

[EventDisplay]
ShowEventTime=true
MaxEventsInPopup=10
DaysAhead=7

[QuickAdd]
QuickAddEnabled=true
NaturalLanguageParsing=true

[Notifications]
UpcomingEventNotification=true
NotificationLeadTime=15
```

---

## ⌨️ Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Meta+C` | Open KOrganizer |
| `Meta+Shift+C` | Quick add event |
| `Meta+Alt+T` | Today view |

---

## 🗣️ Natural Language Examples

The quick-add feature understands:
- "Meeting tomorrow at 2pm"
- "Lunch with John next Monday"  
- "Team standup every weekday at 9am"
- "Dentist appointment on March 15"

---

## 🎂 Birthday Integration

Shows birthdays from KAddressBook contacts:
- Notification 3 days before
- Displayed in calendar widget
- Optional: auto-create calendar events

---

## 🔗 Related Documentation

- [PIM Suite Overview](README.md)
- [Contact Sync](CONTACT-SYNC.md)
