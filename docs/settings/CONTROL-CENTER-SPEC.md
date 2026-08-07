# 🎛️ Sanchala Control Center - Design Specification

## Overview

**Sanchala Control Center** is the unified settings application for Sanchala OS, designed to provide a macOS System Preferences-like experience while leveraging KDE's powerful configuration system.

## 🎯 Design Goals

1. **Unified Experience** - Single place for ALL system settings
2. **Searchable** - Global search across all settings (Spotlight-style)
3. **Intuitive Categories** - Logical grouping like macOS System Preferences
4. **Privacy-First** - Security/Privacy prominently featured
5. **Responsive** - Works on all screen sizes
6. **Accessible** - Full keyboard navigation, screen reader support

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                   SANCHALA CONTROL CENTER                           │
├─────────────────────────────────────────────────────────────────────┤
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │  🔍 Search Settings...                                  ⌘ ,   │  │
│  └───────────────────────────────────────────────────────────────┘  │
│                                                                     │
│   ┌───────┐  ┌───────┐  ┌───────┐  ┌───────┐  ┌───────┐           │
│   │  👤   │  │  🖥️   │  │  🎨   │  │  🔔   │  │  🔒   │           │
│   │Account│  │Display│  │Appear.│  │Notif. │  │Privacy│           │
│   └───────┘  └───────┘  └───────┘  └───────┘  └───────┘           │
│                                                                     │
│   ┌───────┐  ┌───────┐  ┌───────┐  ┌───────┐  ┌───────┐           │
│   │  📶   │  │  🔊   │  │  ⌨️   │  │  🖱️   │  │  🖨️   │           │
│   │Network│  │ Sound │  │Keybd  │  │ Mouse │  │Printer│           │
│   └───────┘  └───────┘  └───────┘  └───────┘  └───────┘           │
│                                                                     │
│   ┌───────┐  ┌───────┐  ┌───────┐  ┌───────┐  ┌───────┐           │
│   │  🔋   │  │  💾   │  │  🛡️   │  │  📦   │  │  ♿   │           │
│   │ Power │  │Storage│  │Security│ │ Apps  │  │Access.│           │
│   └───────┘  └───────┘  └───────┘  └───────┘  └───────┘           │
│                                                                     │
│   ┌───────┐  ┌───────┐  ┌───────┐  ┌───────┐                      │
│   │  📅   │  │  🌐   │  │  📱   │  │  ℹ️   │                      │
│   │Date/T │  │Language│ │Devices│  │ About │                      │
│   └───────┘  └───────┘  └───────┘  └───────┘                      │
└─────────────────────────────────────────────────────────────────────┘
```

## 📂 Category Structure

### Row 1: Personal & Display
| Icon | Name | Description | KCM Modules |
|------|------|-------------|-------------|
| 👤 | **Account** | User profile, avatar, password | `kcm_users`, `kcm_kaccounts` |
| 🖥️ | **Display** | Resolution, scaling, arrangement | `kcm_kscreen`, `kcm_nightcolor` |
| 🎨 | **Appearance** | Themes, colors, fonts, icons | `kcm_colors`, `kcm_fonts`, `kcm_icons` |
| 🔔 | **Notifications** | Alert settings, Do Not Disturb | `kcm_notifications` |
| 🔒 | **Privacy** | Permissions, tracking, telemetry | `sanchala_kcm_privacy` |

### Row 2: Hardware
| Icon | Name | Description | KCM Modules |
|------|------|-------------|-------------|
| 📶 | **Network** | Wi-Fi, Ethernet, VPN, Firewall | `kcm_networkmanagement` |
| 🔊 | **Sound** | Volume, input/output, effects | `kcm_pulseaudio` |
| ⌨️ | **Keyboard** | Layout, shortcuts, input methods | `kcm_keyboard`, `kcm_keys` |
| 🖱️ | **Mouse & Touchpad** | Speed, gestures, buttons | `kcm_mouse`, `kcm_touchpad` |
| 🖨️ | **Printers** | Print queues, scanner settings | `kcm_printer_manager` |

### Row 3: System
| Icon | Name | Description | KCM Modules |
|------|------|-------------|-------------|
| 🔋 | **Power** | Battery, sleep, power profiles | `kcm_powerdevil` |
| 💾 | **Storage** | Disks, snapshots, cleanup | `sanchala_kcm_storage` |
| 🛡️ | **Security** | Guardian, firewall, encryption | `sanchala_kcm_guardian` |
| 📦 | **Applications** | Default apps, startup, permissions | `kcm_componentchooser` |
| ♿ | **Accessibility** | Vision, hearing, mobility aids | `kcm_access` |

### Row 4: General
| Icon | Name | Description | KCM Modules |
|------|------|-------------|-------------|
| 📅 | **Date & Time** | Timezone, format, NTP | `kcm_clock` |
| 🌐 | **Language & Region** | Locale, formats, spell check | `kcm_translations` |
| 📱 | **Devices** | Bluetooth, removable, phones | `kcm_bluetooth` |
| ℹ️ | **About Sanchala** | System info, updates, support | `sanchala_kcm_about` |
