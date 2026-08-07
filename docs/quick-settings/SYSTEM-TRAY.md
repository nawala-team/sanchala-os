# 📊 System Tray Organization

## Overview

The Sanchala OS system tray provides a clean, organized notification area following macOS design principles - minimal icons, grouped functionality, and consistent visual language.

---

## 🎯 Design Goals

1. **Minimal Clutter** - Only essential icons visible by default
2. **Logical Grouping** - Related items grouped together
3. **Consistent Icons** - Sanchala icon theme throughout
4. **Quick Access** - One click to common actions
5. **Expandable** - Hidden items accessible via arrow

---

## 📐 Tray Layout

```
┌─────────────────────────────────────────────────────────────────────────┐
│ Panel                                                                    │
│  ┌────────────────────────────────────────────────────────────────────┐ │
│  │ Apps  │ Workspace │                    │ System Tray  │ Clock      │ │
│  │       │  Switcher │                    │              │            │ │
│  └────────────────────────────────────────────────────────────────────┘ │
│                                                ▼                         │
│                              ┌─────────────────────────────────┐        │
│                              │ 🔋 📶 🔊 🔔 ⚙️ │ ◀ │ 🔒 📧 💬 │        │
│                              │ Always Visible │   │  Hidden   │        │
│                              └─────────────────────────────────┘        │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 📋 Icon Categories

### Always Visible (5 max)

| Priority | Icon | Description | Click Action |
|----------|------|-------------|--------------|
| 1 | 🔋 Battery | Power status | Power settings |
| 2 | 📶 Network | WiFi/Ethernet | Control Center |
| 3 | 🔊 Volume | Audio level | Volume popup |
| 4 | 🔔 Notifications | Alert badge | Notification panel |
| 5 | ⚙️ Control Center | Quick settings | Control Center |

### Auto-Show (when active)

| Icon | Condition | Description |
|------|-----------|-------------|
| 🔵 Bluetooth | When connected | Active BT device |
| 📍 Location | When in use | GPS active |
| 🎤 Microphone | When recording | Mic in use |
| 📹 Camera | When active | Camera in use |
| 🔴 Recording | When active | Screen recording |
| 🌙 DND | When enabled | Do Not Disturb |

### Hidden (expandable)

| Icon | Description |
|------|-------------|
| 📧 Email | Thunderbird/email client |
| 💬 Chat | Discord, Telegram, etc. |
| 🔄 Sync | Cloud sync status |
| 🎵 Media | Media player controls |
| 🔒 VPN | VPN connection status |
| ☁️ Weather | Weather widget |

---

## ⚙️ Configuration

**Location:** `~/.config/plasma-org.kde.plasma.desktop-appletsrc`

```ini
[SystemTray]
# Known items configuration
knownItems=org.kde.plasma.battery,org.kde.plasma.networkmanagement,org.kde.plasma.volume,org.kde.plasma.notifications,org.sanchala.controlcenter

# Always shown items
shownItems=org.kde.plasma.battery,org.kde.plasma.networkmanagement,org.kde.plasma.volume,org.kde.plasma.notifications,org.sanchala.controlcenter

# Always hidden items  
hiddenItems=org.kde.plasma.clipboard,org.kde.kdeconnect

# Extra items (auto-show based on status)
extraItems=org.kde.plasma.bluetooth,org.kde.plasma.mediacontroller

[Appearance]
iconSize=22
iconSpacing=4
```

---

## 🎨 Visual Specifications

### Icon Sizes
| Context | Size |
|---------|------|
| Tray Icon | 22px |
| Popup Icon | 48px |
| Status Badge | 8px |

### Spacing
| Element | Value |
|---------|-------|
| Icon Gap | 4px |
| Section Separator | 8px |
| Tray Padding | 4px |

### Indicators
```
● Active indicator: 4px dot below icon (accent color)
● Badge: 8px circle, top-right corner (red for alerts)
● Progress: 2px arc around icon (downloads, etc.)
```

---

## 🔔 Notification Integration

### Badge Display
```qml
// Notification badge on tray icon
Rectangle {
    id: badge
    visible: notificationCount > 0
    width: 16; height: 16; radius: 8
    color: "#E53935"
    anchors {
        top: parent.top
        right: parent.right
        margins: -4
    }
    
    Text {
        anchors.centerIn: parent
        text: notificationCount > 9 ? "9+" : notificationCount
        color: "white"
        font.pixelSize: 9
        font.weight: Font.Bold
    }
}
```

---

## 📱 Privacy Indicators

When sensitive hardware is in use, indicators appear automatically:

| Indicator | Trigger | Color |
|-----------|---------|-------|
| 🎤 Microphone | App using mic | Orange |
| 📹 Camera | App using camera | Green |
| 📍 Location | App using GPS | Blue |
| 🔴 Recording | Screen recording | Red |

These indicators:
- Cannot be hidden by applications
- Show tooltip with app name on hover
- Click opens Privacy settings

---

## 🔧 Plasma Configuration

**File:** `/etc/skel/.config/plasma-org.kde.plasma.desktop-appletsrc`

```ini
[Containments][2][Applets][19]
immutability=1
plugin=org.kde.plasma.systemtray

[Containments][2][Applets][19][Configuration]
PreloadWeight=100
SystrayContainmentId=20

[Containments][20]
activityId=
formfactor=2
immutability=1
lastScreen=0
location=4
plugin=org.kde.plasma.private.systemtray
wallpaperplugin=org.kde.image

[Containments][20][General]
extraItems=org.kde.plasma.bluetooth,org.kde.plasma.mediacontroller,org.kde.plasma.devicenotifier
hiddenItems=org.kde.plasma.clipboard
knownItems=org.kde.plasma.battery,org.kde.plasma.bluetooth,org.kde.plasma.clipboard,org.kde.plasma.devicenotifier,org.kde.plasma.mediacontroller,org.kde.plasma.networkmanagement,org.kde.plasma.notifications,org.kde.plasma.volume,org.sanchala.controlcenter
shownItems=org.kde.plasma.battery,org.kde.plasma.networkmanagement,org.kde.plasma.volume,org.kde.plasma.notifications,org.sanchala.controlcenter
```

---

**Document Version:** 1.0  
**Last Updated:** Phase 3 Sprint
