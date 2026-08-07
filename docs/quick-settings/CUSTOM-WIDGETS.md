# 🧩 Sanchala Custom Widgets

## Overview

Sanchala OS includes custom Plasma widgets designed to enhance the desktop experience with macOS-inspired aesthetics and functionality.

---

## 📦 Widget Collection

### 1. Control Center Widget
**ID:** `org.sanchala.controlcenter`

The flagship widget providing unified quick settings access.

```
┌─────────────────────────────┐
│ ⚙️ Control Center           │
│ ─────────────────────────── │
│ [WiFi] [BT] [DND]           │
│ [Dark] [Cast] [Focus]       │
│ 🔊 ━━━━━━━━━━━━━━━━━━  75%  │
│ ☀️ ━━━━━━━━━━━━━━━━━━  60%  │
│ 🎵 Now Playing...           │
└─────────────────────────────┘
```

### 2. Now Playing Widget
**ID:** `org.sanchala.nowplaying`

Elegant media player widget with album art and controls.

```
┌─────────────────────────────┐
│ ┌─────┐  Starboy            │
│ │ 🎵  │  The Weeknd         │
│ │     │  Starboy (Album)    │
│ └─────┘                     │
│   ◄◄    ▶    ►►             │
│ ━━━━━━━●━━━━━━━  2:34/3:50  │
└─────────────────────────────┘
```

**Features:**
- Album art with blur background
- Artist/title/album display
- Progress bar with seeking
- Play/pause, next, previous
- Volume on hover
- MPRIS integration

### 3. Quick Note Widget
**ID:** `org.sanchala.quicknote`

Sticky note widget for quick thoughts.

```
┌─────────────────────────────┐
│ 📝 Quick Note          ✕    │
│ ─────────────────────────── │
│ Remember to:                │
│ - Review PR #234            │
│ - Call mom                  │
│ - Buy groceries             │
│                             │
│              [Save to Keep] │
└─────────────────────────────┘
```

### 4. System Monitor Widget
**ID:** `org.sanchala.sysmonitor`

Minimal system resource display.

```
┌─────────────────────────────┐
│ CPU  ████████░░  78%        │
│ RAM  ██████░░░░  62%        │
│ SSD  ████░░░░░░  45%        │
│ NET  ↓ 2.4 MB/s ↑ 0.8 MB/s  │
└─────────────────────────────┘
```

### 5. Weather Widget
**ID:** `org.sanchala.weather`

Clean weather display with forecast.

```
┌─────────────────────────────┐
│      ☀️  28°C               │
│    Jakarta                  │
│    Partly Cloudy            │
│ ─────────────────────────── │
│ Mon  Tue  Wed  Thu  Fri     │
│ 🌤️   ☀️   🌧️   ☀️   ☀️      │
│ 29°  31°  27°  30°  29°     │
└─────────────────────────────┘
```

### 6. Calendar Widget
**ID:** `org.sanchala.calendar`

Monthly calendar with event integration.

```
┌─────────────────────────────┐
│     ◄  August 2026  ►       │
│ Su Mo Tu We Th Fr Sa        │
│                    1        │
│  2  3  4  5  6  7  8        │
│  9 10 11 12 13 14 15        │
│ 16 17 18 19 20 21 22        │
│ 23 24 25 26 27 28 29        │
│ 30 31                       │
│ ─────────────────────────── │
│ • Team standup - 10:00 AM   │
│ • Dentist - 2:00 PM         │
└─────────────────────────────┘
```

---

## 📁 Widget Package Structure

```
org.sanchala.<widget>/
├── metadata.json
├── contents/
│   ├── ui/
│   │   ├── main.qml
│   │   ├── CompactRepresentation.qml
│   │   ├── FullRepresentation.qml
│   │   └── ConfigGeneral.qml
│   └── config/
│       └── main.xml
└── <Widget>.desktop
```

---

## 🔧 Widget metadata.json Template

```json
{
    "KPlugin": {
        "Id": "org.sanchala.widgetname",
        "Name": "Widget Name",
        "Description": "Widget description",
        "Icon": "widget-icon",
        "Authors": [{
            "Name": "Sanchala Team",
            "Email": "team@sanchala.id"
        }],
        "Category": "System Information",
        "License": "GPL-3.0",
        "Version": "1.0.0"
    },
    "X-Plasma-API": "declarativeappletscript",
    "X-Plasma-MainScript": "ui/main.qml"
}
```

---

## 🎨 Design Guidelines

### Visual Consistency
- Corner radius: 12px for containers, 8px for buttons
- Blur background: 40px radius, 85% opacity
- Shadow: 0 4px 12px rgba(0,0,0,0.15)
- Padding: 12-16px

### Animation Standards
- Duration: 200ms for toggles, 300ms for panels
- Easing: `Easing.OutCubic` for most animations
- Hover scale: 1.02 for interactive elements

### Typography
- Headers: Inter SemiBold 14px
- Body: Inter Regular 12px
- Captions: Inter Regular 10px, 70% opacity

---

## 📦 Installation

Widgets are installed to:
```
/usr/share/plasma/plasmoids/          # System-wide
~/.local/share/plasma/plasmoids/      # User-specific
```

---

**Document Version:** 1.0  
**Last Updated:** Phase 3 Sprint
