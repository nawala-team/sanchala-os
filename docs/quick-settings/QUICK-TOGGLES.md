# 🔘 Quick Toggles Configuration

## Overview

Quick toggles provide one-tap access to frequently used system settings. Each toggle supports three interaction modes: tap (toggle), long-press (expand), and right-click (settings).

---

## 🎛️ Default Toggle Grid

```
┌────────────────────────────────────────────────┐
│  ┌──────────┐  ┌──────────┐  ┌──────────┐     │
│  │    📶    │  │    🔵    │  │    🌙    │     │
│  │  Wi-Fi   │  │Bluetooth │  │   DND    │     │
│  │ HomeNet  │  │    On    │  │   Off    │     │
│  └──────────┘  └──────────┘  └──────────┘     │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐     │
│  │    🌓    │  │    📡    │  │    🔒    │     │
│  │Dark Mode │  │ Screen   │  │  Focus   │     │
│  │    On    │  │  Cast    │  │  Work    │     │
│  └──────────┘  └──────────┘  └──────────┘     │
└────────────────────────────────────────────────┘
```

---

## 📋 Toggle Specifications

### Core Toggles

| ID | Icon On | Icon Off | D-Bus Service |
|----|---------|----------|---------------|
| `wifi` | `network-wireless` | `network-wireless-off` | `org.freedesktop.NetworkManager` |
| `bluetooth` | `bluetooth-active` | `bluetooth-disabled` | `org.bluez` |
| `dnd` | `notifications-disabled` | `notifications` | `org.freedesktop.Notifications` |
| `darkmode` | `weather-clear-night` | `weather-clear` | `org.kde.plasmashell` |
| `screencast` | `view-media-visualization` | - | `org.kde.kdeconnect` |
| `focus` | `focus-mode` | - | `org.sanchala.Focus` |

### Interaction Modes

| Action | Result |
|--------|--------|
| **Tap** | Toggle on/off |
| **Long Press** | Expand detailed panel |
| **Right Click** | Open full settings |

---

## ➕ Additional Toggles

| Toggle | Icon | Description |
|--------|------|-------------|
| `nightlight` | `redshift-status-on` | Blue light filter |
| `airplane` | `airplane-mode` | Airplane mode |
| `hotspot` | `network-wireless-hotspot` | Mobile hotspot |
| `vpn` | `network-vpn` | VPN quick connect |
| `rotation` | `rotation-locked` | Screen rotation lock |
| `battery` | `battery-profile-performance` | Power profile |
| `location` | `gps` | Location services |
| `caffeine` | `cafe` | Keep screen awake |

---

## 🔧 Configuration

**Location:** `~/.config/sanchala/quick-toggles.conf`

```ini
[General]
GridColumns=3
ShowLabels=true
ShowSubtitles=true
AnimationDuration=200

[EnabledToggles]
wifi=true
bluetooth=true
dnd=true
darkmode=true
screencast=true
focus=true

[ToggleOrder]
Order=wifi,bluetooth,dnd,darkmode,screencast,focus
```

---

## 🎨 Toggle Visual Specs

| Property | Value |
|----------|-------|
| Size | 100px × 72px |
| Corner Radius | 12px |
| Icon Size | 24px |
| Label Font | Inter Medium 11px |
| Subtitle Font | Inter Regular 10px |
| Active Color | `#3949AB` (Sanchala Indigo) |
| Inactive Color | `rgba(128,128,128,0.1)` |

---

**Document Version:** 1.0  
**Last Updated:** Phase 3 Sprint
