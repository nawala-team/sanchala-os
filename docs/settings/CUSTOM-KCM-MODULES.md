# 🔧 Sanchala Custom KCM Modules Specification

## Overview

Sanchala OS extends KDE System Settings with custom KCM (KDE Control Module) 
modules for features unique to our distribution.

---

## Custom Modules

### 1. sanchala_kcm_privacy

**Purpose:** Unified privacy control center (macOS-style TCC)

**Location:** `/usr/share/kpackage/kcms/sanchala_kcm_privacy/`

**D-Bus Service:** `org.sanchala.Privacy`

#### Features
- Location services control
- Camera/Microphone permissions
- Screen recording permissions  
- File system access control
- Analytics/Telemetry toggle
- Recent activity management

#### Config File
`~/.config/sanchala/privacy.conf`

```ini
[Location]
Enabled=false
AllowedApps=

[Camera]
Enabled=true
ShowIndicator=true
AllowedApps=

[Microphone]
Enabled=true
ShowIndicator=true
AllowedApps=

[ScreenRecording]
AllowedApps=

[Analytics]
UsageData=false
CrashReports=false

[RecentFiles]
Enabled=true
MaxAge=7
```

---

### 2. sanchala_kcm_guardian

**Purpose:** Sanchala Guardian security center integration

**Location:** `/usr/share/kpackage/kcms/sanchala_kcm_guardian/`

**D-Bus Service:** `org.sanchala.Guardian`

#### Features
- Security status overview
- Firewall management
- AppArmor profile status
- Secure Boot status
- Encryption status
- Security update management

#### Config File
`/etc/sanchala/guardian.conf`

```ini
[Guardian]
ProtectionLevel=high
AutoScan=weekly
RealTimeProtection=true

[Firewall]
Enabled=true
DefaultIncoming=deny
DefaultOutgoing=allow

[AppArmor]
Enforcing=true
NotifyOnDeny=true

[Updates]
AutoSecurityUpdates=true
NotifyOnAvailable=true
```

---

### 3. sanchala_kcm_storage

**Purpose:** Storage management with Btrfs/Snapper integration

**Location:** `/usr/share/kpackage/kcms/sanchala_kcm_storage/`

**D-Bus Service:** `org.sanchala.Storage`

#### Features
- Disk usage visualization
- Btrfs subvolume management
- Snapper snapshot control
- Storage cleanup tools
- SMART disk health
- Encryption management

#### Config File
`~/.config/sanchala/storage.conf`

```ini
[Snapshots]
AutoCreate=true
KeepHourly=5
KeepDaily=7
KeepWeekly=4
KeepMonthly=6

[Cleanup]
AutoCleanup=true
CleanupInterval=weekly
PackageCacheMaxAge=30
```

---

### 4. sanchala_kcm_about

**Purpose:** System information and Sanchala branding

**Location:** `/usr/share/kpackage/kcms/sanchala_kcm_about/`

#### Features
- Sanchala version and codename
- Hardware information
- System resources
- Support links
- Legal information
- Update checker

#### Display Information
```
╭─────────────────────────────────────────╮
│         ◉ SANCHALA OS                   │
│         Version 1.0 "Gati"              │
│                                         │
│  Kernel:    6.x.x-sanchala              │
│  Desktop:   KDE Plasma 6.x              │
│  CPU:       [Detected]                  │
│  Memory:    [Detected]                  │
│  Graphics:  [Detected]                  │
│  Disk:      [Detected]                  │
│                                         │
│  [Check for Updates]  [Support]         │
╰─────────────────────────────────────────╯
```

---

### 5. sanchala_kcm_vpn

**Purpose:** Enhanced VPN management with WireGuard focus

**Location:** `/usr/share/kpackage/kcms/sanchala_kcm_vpn/`

**D-Bus Service:** `org.sanchala.VPN`

#### Features
- WireGuard configuration
- OpenVPN support
- Kill switch toggle
- DNS leak protection
- Auto-connect on untrusted networks

#### Config File
`~/.config/sanchala/vpn.conf`

```ini
[VPN]
KillSwitch=false
DNSLeakProtection=true
AutoConnectUntrusted=false
PreferredProtocol=wireguard
```

---

## Module Structure

Each KCM module follows this structure:

```
sanchala_kcm_<name>/
├── metadata.json           # Module metadata
├── contents/
│   ├── ui/
│   │   └── main.qml       # Main QML interface
│   └── code/
│       └── main.cpp       # C++ backend (if needed)
├── kcm_<name>.desktop     # Desktop entry
└── CMakeLists.txt         # Build configuration
```

### metadata.json Example

```json
{
    "KPlugin": {
        "Id": "sanchala_kcm_privacy",
        "Name": "Privacy",
        "Description": "Manage privacy and permissions",
        "Icon": "preferences-security",
        "Authors": [
            {
                "Name": "Sanchala Team",
                "Email": "team@sanchala.id"
            }
        ],
        "Category": "Security",
        "License": "GPL-3.0",
        "Version": "1.0"
    },
    "X-KDE-System-Settings-Parent-Category": "security",
    "X-KDE-Keywords": "privacy,permissions,location,camera,microphone"
}
```

---

## Build Requirements

```cmake
find_package(KF6 REQUIRED COMPONENTS
    CoreAddons
    KCMUtils
    I18n
    ConfigWidgets
    Declarative
)

find_package(Qt6 REQUIRED COMPONENTS
    Core
    Quick
    Qml
    DBus
)
```

---

## Installation Paths

| Component | Path |
|-----------|------|
| KCM Package | `/usr/share/kpackage/kcms/` |
| Desktop Entry | `/usr/share/applications/` |
| D-Bus Service | `/usr/share/dbus-1/services/` |
| Config Schema | `/usr/share/config.kcfg/` |
| Translations | `/usr/share/locale/` |

---

**Document Version:** 1.0  
**Last Updated:** Phase 1 Sprint
