# Sanchala Store - Application Center

## Overview

**sanchala-store** is the unified application management center for Sanchala OS. It provides a curated, secure app discovery experience with Flatpak as the primary package format, supplemented by native Arch packages.

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                      SANCHALA STORE                              │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────────┐    │
│  │                  Qt/QML Frontend                         │    │
│  │  ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐           │    │
│  │  │Discover│ │Installed│ │Updates │ │Settings│           │    │
│  │  └────────┘ └────────┘ └────────┘ └────────┘           │    │
│  └─────────────────────────────────────────────────────────┘    │
│                              │                                   │
│                    ┌─────────┴─────────┐                        │
│                    │   Rust Backend    │                        │
│                    │ (sanchala-stored) │                        │
│                    └─────────┬─────────┘                        │
│                              │                                   │
│         ┌────────────────────┼────────────────────┐             │
│         ▼                    ▼                    ▼             │
│  ┌────────────┐      ┌────────────┐      ┌────────────┐        │
│  │  Flatpak   │      │   Pacman   │      │  AppStream │        │
│  │   libflatpak│      │  libalpm   │      │  Metadata  │        │
│  └────────────┘      └────────────┘      └────────────┘        │
└─────────────────────────────────────────────────────────────────┘
```

## Features

### Discovery
- Curated homepage with featured apps
- Category browsing
- Editorial collections ("Best for Productivity", etc.)
- Search with filters

### App Details
- Screenshots and videos
- Ratings and reviews
- Permission requirements (sandbox info)
- Version history
- Developer information

### Installation
- One-click install
- Progress tracking
- Automatic updates (configurable)
- Rollback support (Flatpak)

### Security Integration
- Sandbox permission display
- Security rating indicator
- Verified publisher badges
- sanchala-guardian integration

## Package Source Priority

1. **Flatpak (Flathub)** - Primary, sandboxed
2. **Sanchala Repo** - Curated native packages
3. **Arch Repos** - System packages (with warning)
4. **AUR** - Disabled by default, opt-in

## CLI Interface

```bash
# Search for apps
sanchala-store search firefox

# Install app
sanchala-store install com.brave.Browser

# List installed
sanchala-store list --installed

# Update all
sanchala-store update

# Show app info
sanchala-store info org.libreoffice.LibreOffice

# Launch store GUI
sanchala-store --gui
```

## D-Bus Interface

**Bus Name:** `id.sanchala.Store`

### Methods
- `Search(query: s) -> (s)` - Search apps, return JSON
- `Install(app_id: s, source: s) -> (b)` - Install app
- `Remove(app_id: s) -> (b)` - Remove app
- `GetUpdates() -> (s)` - List available updates
- `ApplyUpdates() -> (b)` - Install all updates

### Signals
- `InstallProgress(app_id: s, progress: i)`
- `InstallComplete(app_id: s, success: b)`
- `UpdatesAvailable(count: i)`

## Configuration

```toml
# /etc/sanchala/store.toml

[sources]
flatpak = true
sanchala_repo = true
arch_repos = false  # Requires confirmation
aur = false         # Disabled by default

[updates]
auto_check = true
auto_install = false
check_interval = "daily"

[security]
show_permissions = true
warn_unverified = true
block_dangerous = true
```

## File Locations

| File | Purpose |
|------|---------|
| `/etc/sanchala/store.toml` | Configuration |
| `/var/cache/sanchala/store/` | Metadata cache |
| `/usr/share/sanchala/store/` | QML/assets |
| `~/.local/share/sanchala/store/` | User preferences |

## Security Features

- **Permission Display**: Clear visualization of app sandbox permissions
- **Verified Publishers**: Badge system for trusted developers
- **Security Scores**: Integration with sanchala-guardian
- **Update Verification**: GPG signature verification
- **Sandboxing Info**: Show isolation level per app
