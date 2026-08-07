# 🔄 SANCHALA OS - User Switching Optimization

## Overview

Fast user switching (<2 seconds) with session preservation, inspired by macOS Fast User Switching but optimized for KDE Plasma and Linux.

---

## 🎯 Performance Targets

| Metric | Target | macOS Reference |
|--------|--------|-----------------|
| Switch time | <2 seconds | ~2-3 seconds |
| Memory overhead | <200MB/session | ~300MB |
| Resume latency | <500ms | ~1 second |
| Animation | 60fps cube | Cube effect |

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                 SANCHALA FAST USER SWITCH                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐         │
│  │   User A    │    │   User B    │    │   User C    │         │
│  │  (Active)   │    │ (Suspended) │    │ (Suspended) │         │
│  │  Plasma     │    │  Plasma     │    │  Plasma     │         │
│  │  Session    │    │  Session    │    │  Session    │         │
│  └──────┬──────┘    └──────┬──────┘    └──────┬──────┘         │
│         │                  │                  │                 │
│         └──────────────────┼──────────────────┘                 │
│                            │                                    │
│                    ┌───────┴───────┐                            │
│                    │   systemd     │                            │
│                    │  user slices  │                            │
│                    │  + cgroups v2 │                            │
│                    └───────┬───────┘                            │
│                            │                                    │
│  ┌─────────────────────────┴─────────────────────────┐         │
│  │            sanchala-user-switch daemon             │         │
│  │  ┌──────────┐  ┌──────────┐  ┌────────────────┐   │         │
│  │  │ Session  │  │ Memory   │  │ D-Bus Switch   │   │         │
│  │  │ Manager  │  │ Manager  │  │ Coordinator    │   │         │
│  │  └──────────┘  └──────────┘  └────────────────┘   │         │
│  └───────────────────────────────────────────────────┘         │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## ⚡ Optimization Strategies

### 1. Session Preservation (Memory)

```toml
# /etc/sanchala/users/switch.conf

[session_preservation]
# Keep sessions in memory when switching
preserve_sessions = true

# Max sessions to keep alive
max_preserved_sessions = 3

# Memory limit per preserved session
session_memory_limit_mb = 1024

# Swap preference for inactive sessions
swap_inactive_sessions = true
swappiness_inactive = 80
```

### 2. Cgroups v2 Resource Management

```ini
# /etc/systemd/system/user-.slice.d/sanchala-switch.conf

[Slice]
# Memory management for user sessions
MemoryHigh=2G
MemoryMax=4G

# CPU weight (lower for inactive)
CPUWeight=100
CPUWeightInactive=10

# IO priority
IOWeight=100
IOWeightInactive=10
```

### 3. Pre-warming System

```bash
# When user logs in, pre-warm potential switch targets
sanchala-user-switch --prewarm

# Pre-load:
# - User's KDE config (kdeglobals, plasmashellrc)
# - Theme assets
# - D-Bus activation files
# - Keyring preparation
```

---

## 🎨 Visual Transition

### KWin Cube Effect

```qml
// /usr/share/kwin/effects/sanchala-userswitch/main.qml

import QtQuick 2.15
import org.kde.kwin 3.0

Effect {
    id: userSwitchEffect
    
    property real animationDuration: 400  // ms
    property real cubeRotation: 0
    
    NumberAnimation on cubeRotation {
        from: 0
        to: 90
        duration: animationDuration
        easing.type: Easing.InOutCubic
    }
    
    // 3D cube rotation between sessions
    transform: Rotation {
        origin.x: width / 2
        axis { x: 0; y: 1; z: 0 }
        angle: cubeRotation
    }
}
```

---

## 🔧 Implementation

### D-Bus Interface

```xml
<!-- /usr/share/dbus-1/interfaces/id.sanchala.UserSwitch.xml -->
<interface name="id.sanchala.UserSwitch">
  <method name="SwitchToUser">
    <arg type="s" name="username" direction="in"/>
    <arg type="b" name="success" direction="out"/>
  </method>
  
  <method name="ListActiveSessions">
    <arg type="as" name="sessions" direction="out"/>
  </method>
  
  <method name="GetSwitchTime">
    <arg type="u" name="milliseconds" direction="out"/>
  </method>
  
  <signal name="SwitchStarted">
    <arg type="s" name="from_user"/>
    <arg type="s" name="to_user"/>
  </signal>
  
  <signal name="SwitchCompleted">
    <arg type="s" name="to_user"/>
    <arg type="u" name="duration_ms"/>
  </signal>
</interface>
```

### Switch Flow

1. **User initiates switch** (panel menu / keyboard shortcut)
2. **Lock current session** (optional, configurable)
3. **Start KWin transition animation**
4. **Activate target user's systemd slice**
5. **Switch VT to target session's tty**
6. **Resume target Plasma session**
7. **Complete animation, emit signal**

---

## ⌨️ Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Ctrl+Alt+Delete` | User switch menu |
| `Super+L` | Lock & show switch screen |
| `Ctrl+Alt+F1-F6` | Direct VT switch (advanced) |

---

## 📊 Memory Management

### Active Session
- Full resources, normal priority
- All apps running normally

### Suspended Session  
- Reduced CPU priority (nice +10)
- Memory pressure applied
- Background apps suspended
- Screen buffers released

### Hibernated Session (optional)
- Session state saved to disk
- Memory freed completely
- Slower resume (~5 seconds)
