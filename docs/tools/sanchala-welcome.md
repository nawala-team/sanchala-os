# Sanchala Welcome - First-Boot Wizard

## Overview

**sanchala-welcome** is the first-boot setup wizard that guides new users through initial system configuration, providing a polished onboarding experience similar to macOS Setup Assistant.

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    SANCHALA WELCOME                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │                    Qt/QML Frontend                       │    │
│  │    ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐      │    │
│  │    │Language │→│ Region  │→│ Account │→│Security │→...  │    │
│  │    └─────────┘ └─────────┘ └─────────┘ └─────────┘      │    │
│  └─────────────────────────────────────────────────────────┘    │
│                              │                                   │
│                    ┌─────────┴─────────┐                        │
│                    │   Rust Backend    │                        │
│                    │  (sanchala-welcome│                        │
│                    │      -daemon)     │                        │
│                    └─────────┬─────────┘                        │
│                              │                                   │
└──────────────────────────────┼───────────────────────────────────┘
                               │
           ┌───────────────────┼───────────────────┐
           ▼                   ▼                   ▼
      ┌─────────┐       ┌───────────┐       ┌──────────┐
      │ AccountsD│       │  Locale   │       │ NetworkMgr│
      └─────────┘       └───────────┘       └──────────┘
```

## Setup Wizard Pages

### 1. Welcome & Language
- Animated Sanchala logo
- Language selection with live preview
- Keyboard layout detection

### 2. Region & Timezone
- Interactive map for timezone
- Regional format preferences
- Currency/date format preview

### 3. Network Setup
- WiFi network selection
- Ethernet configuration
- Optional: VPN setup for enterprise

### 4. User Account
- Full name and username
- Password with strength meter
- Avatar selection (camera/file/generated)
- Optional: Connect online accounts

### 5. Security Configuration
- Disk encryption confirmation
- Secure Boot status
- Biometric setup (if hardware present)
- Privacy settings overview

### 6. Privacy & Telemetry
- Telemetry opt-in (OFF by default)
- Location services preference
- Crash reporting preference

### 7. Appearance
- Light/Dark/Auto theme
- Accent color selection
- Wallpaper preview

### 8. Getting Started
- Tour offer
- Quick tips
- Application recommendations

## Technology Stack

| Component | Technology |
|-----------|------------|
| Backend | Rust |
| Frontend | Qt 6 / QML |
| IPC | D-Bus |
| Styling | KDE Breeze + Sanchala theme |

## CLI Interface

```bash
# Launch wizard (normal mode)
sanchala-welcome

# Force re-run setup
sanchala-welcome --force

# Skip to specific page
sanchala-welcome --page=security

# Headless setup with config file
sanchala-welcome --config=/path/to/setup.toml

# Check if first boot
sanchala-welcome --check-first-boot
```

## Configuration File Format

```toml
# /etc/sanchala/welcome.toml

[general]
skip_pages = []
force_pages = ["security"]

[defaults]
language = "en_US"
timezone = "auto"
theme = "auto"

[enterprise]
domain_join = false
preset_config = ""
```

## D-Bus Interface

**Bus Name:** `id.sanchala.Welcome`

### Methods
- `GetCurrentPage() -> (s)` - Current wizard page
- `SetPageComplete(page: s, data: s) -> (b)` - Mark page complete
- `SkipPage(page: s) -> (b)` - Skip a page
- `GetSetupProgress() -> (i)` - Progress percentage

### Signals  
- `PageChanged(page: s)` - Wizard page changed
- `SetupComplete()` - Setup finished

## File Locations

| File | Purpose |
|------|---------|
| `/etc/sanchala/welcome.toml` | Configuration |
| `/var/lib/sanchala/setup-complete` | First-boot flag |
| `/usr/share/sanchala/welcome/` | QML/assets |

## Integration Points

- **systemd**: Auto-start on first boot
- **AccountsService**: User creation
- **NetworkManager**: Network setup
- **sanchala-guardian**: Security defaults
- **KDE Plasma**: Theme application
