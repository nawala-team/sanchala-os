# ⚙️ Sanchala OS - Default Settings Reference

## Overview

This document defines all default settings for a fresh Sanchala OS installation.
Settings are optimized for security, privacy, and a macOS-like user experience.

---

## 🎨 Appearance Defaults

### Theme
```ini
[General]
ColorScheme=SanchalaDark
Name=Sanchala Dark
widgetStyle=Breeze

[KDE]
LookAndFeelPackage=org.kde.sanchala.desktop
AnimationDurationFactor=0.5
SingleClick=false
```

### Colors (Sanchala Dark)
| Element | Color | Hex |
|---------|-------|-----|
| Window Background | Dark Gray | #212121 |
| View Background | Near Black | #1E1E1E |
| Selection | Sanchala Indigo | #3949AB |
| Accent | Electric Blue | #536DFE |
| Text Primary | White | #FFFFFF |
| Text Secondary | Light Gray | #B0B0B0 |

### Fonts
| Usage | Font | Size | Weight |
|-------|------|------|--------|
| General | Inter | 10pt | Regular |
| Fixed Width | JetBrains Mono | 10pt | Regular |
| Small | Inter | 8pt | Regular |
| Toolbar | Inter | 10pt | Regular |
| Menu | Inter | 10pt | Regular |
| Window Title | Inter | 10pt | Semi-Bold |

### Icons
```ini
[Icons]
Theme=sanchala-icons
Size=48
```

### Cursors
```ini
[Cursors]
Theme=breeze_cursors
Size=24
```

---

## 🖥️ Desktop & Window Manager

### KWin Compositing
```ini
[Compositing]
Backend=OpenGL
GLCore=true
GLTextureFilter=2
VSync=true
AnimationSpeed=3
MaxFPS=60
AllowTearing=true
```

### Window Decorations
```ini
[org.kde.kdecoration2]
ButtonsOnLeft=XIA
ButtonsOnRight=
BorderSize=None
library=org.kde.breeze
theme=Breeze
```

### Desktop Effects
| Effect | Enabled | Settings |
|--------|---------|----------|
| Blur | ✅ | Strength: 8 |
| Contrast | ✅ | - |
| Sliding Popups | ✅ | - |
| Magic Lamp | ✅ | - |
| Fade | ✅ | - |
| Scale | ✅ | - |
| Desktop Grid | ✅ | - |
| Overview | ✅ | - |
| Night Color | ✅ | 4500K |
| Wobbly Windows | ❌ | - |
| Dim Inactive | ❌ | - |

### Virtual Desktops
```ini
[Desktops]
Number=4
Rows=2
Name_1=Desktop 1
Name_2=Desktop 2
Name_3=Desktop 3
Name_4=Desktop 4
```

---

## 🔒 Privacy & Security Defaults

### Privacy Settings
| Setting | Default | Reason |
|---------|---------|--------|
| Location Services | OFF | Privacy-first |
| Telemetry | OFF | No data collection |
| Crash Reports | OFF | User consent required |
| Recent Files | 7 days | Balance convenience/privacy |
| Camera Indicator | ON | Awareness |
| Microphone Indicator | ON | Awareness |

### Security Settings
| Setting | Default | Reason |
|---------|---------|--------|
| Firewall | ON | Protection by default |
| AppArmor | ENFORCING | Mandatory sandboxing |
| Auto Updates | SECURITY ONLY | Critical patches only |
| Screen Lock | 5 minutes | Reasonable security |
| Password Strength | Strong required | Security baseline |

### Network Privacy
```ini
[NetworkManager]
wifi.mac-address-randomization=1
connection.stable-id=${CONNECTION}/${BOOT}
```

---

## 📶 Network Defaults

### Wi-Fi
```ini
[WiFi]
Enabled=true
MACRandomization=true
PowerSave=balanced
```

### DNS
```ini
[DNS]
Servers=9.9.9.9,149.112.112.112
DNSOverHTTPS=true
DNSSEC=true
```

### Firewall (UFW)
```ini
[Firewall]
Enabled=true
DefaultIncoming=deny
DefaultOutgoing=allow
LogLevel=low
```

---

## 🔊 Sound Defaults

### Output
```ini
[Output]
DefaultDevice=auto
Volume=70
Muted=false
```

### Input
```ini
[Input]
DefaultDevice=auto
Volume=80
NoiseSuppression=true
```

### Notifications
```ini
[Sounds]
SystemSounds=true
NotificationSound=true
Volume=50
```

---

## ⌨️ Keyboard Defaults

### Layout
```ini
[Keyboard]
Layout=us
Model=pc105
Options=
```

### Key Behavior
```ini
[KeyRepeat]
Enabled=true
Delay=400
Rate=25
```

### Global Shortcuts
| Action | Shortcut |
|--------|----------|
| Open Settings | Meta+, |
| Show Desktop | Meta+D |
| Overview | Meta |
| App Launcher | Meta+Space |
| Terminal | Meta+T |
| File Manager | Meta+E |
| Lock Screen | Meta+L |
| Screenshot | Print |
| Area Screenshot | Shift+Print |
| Switch Desktop Left | Meta+Left |
| Switch Desktop Right | Meta+Right |
| Close Window | Alt+F4 |
| Maximize | Meta+Up |
| Minimize | Meta+Down |

---

## 🖱️ Mouse & Touchpad Defaults

### Mouse
```ini
[Mouse]
Acceleration=-0.5
NaturalScrolling=false
LeftHanded=false
```

### Touchpad
```ini
[Touchpad]
Enabled=true
TapToClick=true
NaturalScrolling=true
TwoFingerScroll=true
DisableWhileTyping=true
PointerAcceleration=0
```

### Gestures
| Gesture | Action |
|---------|--------|
| 3-finger swipe up | Overview |
| 3-finger swipe down | Show Desktop |
| 3-finger swipe left/right | Switch Desktop |
| 4-finger swipe up | App Grid |
| Pinch | Zoom |

---

## 🔋 Power Defaults

### Profiles
| Profile | CPU | Display | Sleep |
|---------|-----|---------|-------|
| Balanced | Powersave | 5 min | 15 min |
| Power Saver | Powersave | 2 min | 5 min |
| Performance | Performance | 10 min | Never |

### Battery
```ini
[Battery]
LowBatteryLevel=20
CriticalBatteryLevel=5
LowBatteryAction=notify
CriticalBatteryAction=hibernate
```

### Lid Actions
```ini
[LidSwitch]
OnAC=sleep
OnBattery=sleep
ExternalMonitor=nothing
```

---

## 📦 Application Defaults

### Default Applications
| Type | Application |
|------|-------------|
| Web Browser | Brave Browser |
| File Manager | Dolphin |
| Terminal | Konsole |
| Text Editor | Kate |
| Email | Thunderbird |
| Media Player | VLC |
| Image Viewer | Gwenview |
| PDF Viewer | Okular |
| Archive Manager | Ark |
| Calculator | KCalc |

### Flatpak Settings
```ini
[Flatpak]
DefaultRemote=flathub
AutoUpdate=true
UpdateInterval=daily
```

---

## 🌐 Locale Defaults

### Region
```ini
[Locale]
Language=en_US.UTF-8
Region=en_US.UTF-8
TimeZone=auto-detect
```

### Formats
```ini
[Formats]
Time=24-hour
Date=YYYY-MM-DD
FirstDayOfWeek=Monday
Currency=auto
Measurement=metric
```

---

## 📋 Session Defaults

### Login
```ini
[Login]
AutoLogin=false
NumLockOnStartup=on
```

### Session
```ini
[Session]
RestoreSession=emptySession
ConfirmLogout=true
```

---

**Document Version:** 1.0  
**Last Updated:** Phase 1 Sprint
