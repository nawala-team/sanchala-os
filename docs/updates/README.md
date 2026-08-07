# 🔄 SANCHALA OS - Update System Documentation

## Overview

Sanchala OS features an atomic update system with Btrfs snapshot-based rollback, delta updates for bandwidth efficiency, and seamless auto-update capabilities.

---

## 🎯 Key Features

| Feature | Description |
|---------|-------------|
| **Atomic Updates** | Pre/post snapshots ensure safe rollback |
| **Delta Updates** | Download only changed portions of packages |
| **Auto-Updates** | Configurable automatic download/install |
| **Rollback** | One-command system restore via snapshots |
| **GRUB Integration** | Boot into any previous snapshot |
| **Notifications** | Desktop and system log alerts |

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                 SANCHALA UPDATE SYSTEM                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────┐  │
│  │  Update Daemon  │───▶│  Delta Engine   │───▶│  Notifier   │  │
│  │  (Timer-based)  │    │  (Bandwidth ↓)  │    │  (Desktop)  │  │
│  └────────┬────────┘    └─────────────────┘    └─────────────┘  │
│           │                                                      │
│           ▼                                                      │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │              Snapshot Integration Layer                  │    │
│  │    ┌──────────┐    ┌──────────┐    ┌──────────────┐     │    │
│  │    │   Pre    │───▶│  Update  │───▶│    Post      │     │    │
│  │    │ Snapshot │    │  Apply   │    │  Snapshot    │     │    │
│  │    └──────────┘    └──────────┘    └──────────────┘     │    │
│  └─────────────────────────────────────────────────────────┘    │
│           │                                                      │
│           ▼                                                      │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │                  Btrfs + Snapper                         │    │
│  │         /.snapshots/N/snapshot (read-only)               │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📁 File Structure

```
/usr/bin/sanchala-updater           # Main CLI tool
/usr/lib/sanchala-updater/          # Library modules
├── common.sh                        # Shared functions
├── snapshot.sh                      # Btrfs/Snapper integration
├── delta.sh                         # Delta update engine
└── notify.sh                        # Notification system

/etc/sanchala-updater/
├── updater.conf                     # Main configuration
└── hooks.d/                         # Custom hooks
    ├── pre-update/                  # Run before updates
    └── post-update/                 # Run after updates

/var/lib/sanchala-updater/          # State data
├── last_check                       # Last update check time
├── last_update                      # Last update time
└── history.log                      # Update history

/var/cache/sanchala-updater/        # Cache
├── packages/                        # Downloaded packages
└── deltas/                          # Delta files
```

---

## 🛠️ Commands

| Command | Description |
|---------|-------------|
| `sanchala-updater check` | Check for available updates |
| `sanchala-updater update` | Download and apply updates |
| `sanchala-updater rollback [N]` | Rollback to snapshot N |
| `sanchala-updater history` | Show update history |
| `sanchala-updater status` | Show system status |
| `sanchala-updater clean` | Clean update cache |

---

## 📚 Related Documentation

- [Update Guide](UPDATE-GUIDE.md) - Detailed usage instructions
- [Delta Updates](DELTA-UPDATES.md) - Delta update specification
- [Auto-Update](AUTO-UPDATE.md) - Automatic update configuration
- [Rollback Guide](ROLLBACK-GUIDE.md) - System recovery procedures

---

**Part of SANCHALA OS Documentation**
