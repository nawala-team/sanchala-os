# 🗄️ SANCHALA OS - Storage Documentation

## Overview

This directory contains comprehensive documentation for Sanchala OS storage architecture, including Btrfs layout, encryption, snapshots, and health monitoring.

---

## 📚 Documents

| Document | Description |
|----------|-------------|
| [BTRFS-SUBVOLUME-LAYOUT.md](BTRFS-SUBVOLUME-LAYOUT.md) | Btrfs subvolume structure and mount options |
| [LUKS2-ENCRYPTION-GUIDE.md](LUKS2-ENCRYPTION-GUIDE.md) | Full disk encryption setup and management |
| [SNAPPER-GUIDE.md](SNAPPER-GUIDE.md) | Snapshot management and rollback procedures |
| [STORAGE-HEALTH-MONITORING.md](STORAGE-HEALTH-MONITORING.md) | Health monitoring and alerting system |

---

## 🏗️ Storage Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    SANCHALA STORAGE STACK                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │                    Btrfs Filesystem                      │    │
│  │  ┌─────┐ ┌───────┐ ┌─────┐ ┌───────┐ ┌───────────────┐  │    │
│  │  │  @  │ │ @home │ │ @log│ │@cache │ │  @snapshots   │  │    │
│  │  └─────┘ └───────┘ └─────┘ └───────┘ └───────────────┘  │    │
│  └─────────────────────────────────────────────────────────┘    │
│                              │                                   │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │                 LUKS2 Encryption Layer                   │    │
│  │           AES-256-XTS • Argon2id • TPM optional         │    │
│  └─────────────────────────────────────────────────────────┘    │
│                              │                                   │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │                    Physical Storage                      │    │
│  │                   NVMe / SSD / HDD                       │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🎯 Key Features

- **Btrfs** - Modern CoW filesystem with compression and snapshots
- **LUKS2** - Enterprise-grade encryption with Argon2id
- **Snapper** - Automated snapshot management with GRUB integration
- **Health Monitoring** - S.M.A.R.T and Btrfs integrity checks

---

## 📁 Related Configuration Files

```
/settings/etc/snapper/
├── snapper.conf           # Global snapper configuration
├── configs/
│   ├── root               # Root subvolume snapshots
│   └── home               # Home subvolume snapshots
└── templates/
    └── default            # Template for new configs

/installer/modules/
└── partition.conf         # Installer partition/storage config
```

---

**Part of SANCHALA OS Documentation**
