# 🎚️ Sliders Specification

## Overview

The Control Center provides smooth, responsive sliders for Volume, Brightness, and Night Light control with real-time feedback and OSD integration.

---

## 📐 Slider Layout

```
┌────────────────────────────────────────────────┐
│  Volume                                        │
│  🔊 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  75% │
│     ▼ Output: Speakers (Built-in)              │
├────────────────────────────────────────────────┤
│  Brightness                                    │
│  ☀️ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  60% │
├────────────────────────────────────────────────┤
│  Night Light                                   │
│  🌙 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  40% │
│     Color Temperature: 4500K                   │
└────────────────────────────────────────────────┘
```

---

## 🔊 Volume Slider

### Properties
| Property | Value |
|----------|-------|
| Min | 0% |
| Max | 150% (boost) |
| Default | 75% |
| Step | 5% |
| OSD | Yes |

### D-Bus Integration
```javascript
// PipeWire/PulseAudio via D-Bus
const volumeService = "org.kde.kglobalaccel";
const volumeInterface = "org.kde.KGlobalAccel";

// Get current volume
function getVolume() {
    return Math.round(PulseAudio.sinkVolume * 100);
}

// Set volume with OSD
function setVolume(value) {
    PulseAudio.sinkVolume = value / 100;
    showOSD("audio-volume", value);
}
```

### Features
- **Output selector** - Click device name to switch
- **Per-app volume** - Expand for app-level control
- **Boost indicator** - Visual warning above 100%
- **Mute toggle** - Click icon to mute

---

## ☀️ Brightness Slider

### Properties
| Property | Value |
|----------|-------|
| Min | 5% |
| Max | 100% |
| Default | 70% |
| Step | 5% |
| OSD | Yes |

### D-Bus Integration
```javascript
// PowerDevil brightness control
const brightnessService = "org.kde.Solid.PowerManagement";
const brightnessPath = "/org/kde/Solid/PowerManagement/Actions/BrightnessControl";

function setBrightness(value) {
    callDBus(brightnessService, brightnessPath,
             "org.kde.Solid.PowerManagement.Actions.BrightnessControl",
             "setBrightness", value);
    showOSD("video-display-brightness", value);
}
```

### Features
- **Auto-brightness toggle** - Ambient light sensor
- **Display selector** - Multiple monitor support
- **Keyboard backlight** - Separate control if available

---

## 🌙 Night Light Slider

### Properties
| Property | Value |
|----------|-------|
| Min | 2500K (Warm) |
| Max | 6500K (Cool) |
| Default | 4500K |
| Step | 100K |

### D-Bus Integration
```javascript
// Night Color via KWin
const nightColorService = "org.kde.KWin";
const nightColorPath = "/org/kde/KWin/NightColor";

function setColorTemperature(kelvin) {
    callDBus(nightColorService, nightColorPath,
             "org.kde.KWin.NightColor",
             "setNightColorTargetTemperature", kelvin);
}
```

### Features
- **Schedule toggle** - Sunset to sunrise
- **Custom schedule** - Manual time range
- **Temperature presets** - Warm/Neutral/Cool buttons

---

## 🎨 Slider Component

```qml
// SliderControl.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import org.kde.kirigami 2.20 as Kirigami

Item {
    id: root
    height: 48
    
    property string icon
    property string label
    property real value: 0.5
    property real from: 0
    property real to: 1
    property string suffix: "%"
    
    signal valueChanged(real newValue)
    
    Row {
        anchors.fill: parent
        spacing: 12
        
        Kirigami.Icon {
            source: root.icon
            width: 20; height: 20
            anchors.verticalCenter: parent.verticalCenter
        }
        
        Slider {
            id: slider
            width: parent.width - 80
            from: root.from
            to: root.to
            value: root.value
            anchors.verticalCenter: parent.verticalCenter
            
            onMoved: root.valueChanged(value)
            
            background: Rectangle {
                height: 4
                radius: 2
                color: Qt.rgba(0.5, 0.5, 0.5, 0.3)
                
                Rectangle {
                    width: slider.visualPosition * parent.width
                    height: parent.height
                    radius: 2
                    color: Kirigami.Theme.highlightColor
                }
            }
            
            handle: Rectangle {
                x: slider.visualPosition * (slider.width - width)
                y: (slider.height - height) / 2
                width: 18; height: 18; radius: 9
                color: "white"
                border.color: Qt.rgba(0, 0, 0, 0.1)
                border.width: 1
            }
        }
        
        Text {
            text: Math.round(slider.value * 100) + root.suffix
            font.pixelSize: 12
            color: Kirigami.Theme.textColor
            anchors.verticalCenter: parent.verticalCenter
            width: 40
        }
    }
}
```

---

## ⌨️ Keyboard Shortcuts

| Key | Action |
|-----|--------|
| `XF86AudioRaiseVolume` | Volume +5% |
| `XF86AudioLowerVolume` | Volume -5% |
| `XF86AudioMute` | Toggle mute |
| `XF86MonBrightnessUp` | Brightness +5% |
| `XF86MonBrightnessDown` | Brightness -5% |
| `Meta+N` | Toggle Night Light |

---

**Document Version:** 1.0  
**Last Updated:** Phase 3 Sprint
