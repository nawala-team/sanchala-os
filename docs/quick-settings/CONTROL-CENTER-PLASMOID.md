# 🎛️ Control Center Plasmoid Specification

## Overview

The Sanchala Control Center is a Plasma 6 plasmoid that provides macOS-style unified quick settings access from the system tray.

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                 CONTROL CENTER PLASMOID                      │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────┐    │
│  │              CompactRepresentation                   │    │
│  │         (System Tray Icon - clickable)              │    │
│  └─────────────────────────────────────────────────────┘    │
│                           │                                  │
│                           ▼                                  │
│  ┌─────────────────────────────────────────────────────┐    │
│  │              FullRepresentation                      │    │
│  │  ┌───────────────────────────────────────────────┐  │    │
│  │  │              Header Section                    │  │    │
│  │  │     User Avatar | Name | Settings Gear        │  │    │
│  │  └───────────────────────────────────────────────┘  │    │
│  │  ┌───────────────────────────────────────────────┐  │    │
│  │  │              Toggle Grid (3x2)                 │  │    │
│  │  │   WiFi | Bluetooth | DND                      │  │    │
│  │  │   Dark | AirPlay  | Focus                     │  │    │
│  │  └───────────────────────────────────────────────┘  │    │
│  │  ┌───────────────────────────────────────────────┐  │    │
│  │  │              Slider Section                    │  │    │
│  │  │   Volume Slider | Brightness Slider           │  │    │
│  │  └───────────────────────────────────────────────┘  │    │
│  │  ┌───────────────────────────────────────────────┐  │    │
│  │  │              Media Player Section              │  │    │
│  │  │   Album Art | Title/Artist | Controls         │  │    │
│  │  └───────────────────────────────────────────────┘  │    │
│  └─────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────┘
```

---

## 📦 Package Structure

```
org.sanchala.controlcenter/
├── metadata.json
├── contents/
│   ├── ui/
│   │   ├── main.qml                 # Entry point
│   │   ├── ControlCenter.qml        # Full representation
│   │   ├── CompactIcon.qml          # Tray icon
│   │   ├── ToggleGrid.qml           # Toggle container
│   │   ├── ToggleButton.qml         # Individual toggle
│   │   ├── SliderControl.qml        # Volume/brightness
│   │   ├── MediaWidget.qml          # Now playing
│   │   ├── ExpandedWiFi.qml         # WiFi details
│   │   ├── ExpandedBluetooth.qml    # BT details
│   │   └── ExpandedFocus.qml        # Focus modes
│   ├── code/
│   │   ├── NetworkBackend.js        # WiFi D-Bus
│   │   ├── BluetoothBackend.js      # BT D-Bus
│   │   ├── AudioBackend.js          # PipeWire
│   │   └── MediaBackend.js          # MPRIS
│   └── config/
│       ├── main.xml                 # Config schema
│       └── config.qml               # Config UI
└── ControlCenter.desktop
```

---

## 🔧 metadata.json

```json
{
    "KPlugin": {
        "Id": "org.sanchala.controlcenter",
        "Name": "Sanchala Control Center",
        "Description": "macOS-style unified quick settings",
        "Icon": "preferences-system",
        "Authors": [
            {
                "Name": "Sanchala Team",
                "Email": "team@sanchala.id"
            }
        ],
        "Category": "System Information",
        "License": "GPL-3.0",
        "Version": "1.0.0",
        "Website": "https://sanchala.id"
    },
    "X-Plasma-API": "declarativeappletscript",
    "X-Plasma-MainScript": "ui/main.qml",
    "X-Plasma-Provides": ["org.kde.plasma.systemtray"],
    "X-Plasma-NotificationArea": true,
    "X-Plasma-NotificationAreaCategory": "SystemServices"
}
```

---

## 🎨 Visual Specifications

### Dimensions
| Element | Size |
|---------|------|
| Panel Width | 340px |
| Panel Max Height | 520px |
| Toggle Button | 100px × 72px |
| Toggle Icon | 24px |
| Slider Height | 40px |
| Corner Radius | 16px (panel), 12px (toggles) |
| Blur Radius | 40px |
| Padding | 16px outer, 12px inner |

### Colors (Theme-Aware)
```qml
// Light Theme
property color bgColor: Qt.rgba(1, 1, 1, 0.85)
property color toggleActive: "#3949AB"
property color toggleInactive: Qt.rgba(0.5, 0.5, 0.5, 0.15)
property color textPrimary: "#212121"
property color textSecondary: "#757575"

// Dark Theme  
property color bgColorDark: Qt.rgba(0.13, 0.13, 0.13, 0.85)
property color toggleActiveDark: "#536DFE"
property color toggleInactiveDark: Qt.rgba(1, 1, 1, 0.1)
property color textPrimaryDark: "#FAFAFA"
property color textSecondaryDark: "#BDBDBD"
```

---

## 📱 Responsive Behavior

| Screen Width | Layout |
|--------------|--------|
| < 400px | 2-column toggle grid |
| 400-600px | 3-column toggle grid |
| > 600px | 3-column + expanded media |

---

**Document Version:** 1.0  
**Last Updated:** Phase 3 Sprint
