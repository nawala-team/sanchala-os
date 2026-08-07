# 🏗️ SANCHALA OS - Architecture Document

## Overview

Sanchala OS adalah distribusi Linux berbasis Arch Linux yang dirancang dengan fokus pada **keamanan**, **keindahan**, dan **kemudahan penggunaan**.

---

## 🎯 Design Goals

1. **Security Beyond Apple** - Keamanan 8 layer yang melebihi macOS
2. **Beautiful UI/UX** - Tampilan macOS-style dengan KDE Plasma
3. **100% Linux Compatible** - Semua aplikasi Linux berjalan tanpa modifikasi
4. **Reliable & Recoverable** - Snapshot dan rollback otomatis
5. **Privacy First** - Telemetry OFF by default, Brave browser

---

## 🔐 Security Architecture (8 Layers)

```
┌─────────────────────────────────────────────────────────────────────┐
│                    SANCHALA SECURITY LAYERS                         │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Layer 8: Zero Trust Network                                        │
│  ├── WireGuard VPN integration                                      │
│  ├── DNS-over-HTTPS (DoH) default                                   │
│  ├── mTLS for sensitive connections                                 │
│  └── MAC address randomization                                      │
│                                                                     │
│  Layer 7: Application Security                                      │
│  ├── Flatpak sandboxing (primary)                                   │
│  ├── Bubblewrap for non-Flatpak apps                                │
│  ├── AppArmor mandatory profiles                                    │
│  ├── Sanchala TCC (permission manager)                              │
│  └── Per-app firewall rules                                         │
│                                                                     │
│  Layer 6: Code Integrity                                            │
│  ├── GPG package signature verification                             │
│  ├── Reproducible builds verification                               │
│  ├── SLSA attestation support                                       │
│  └── Binary transparency logs                                       │
│                                                                     │
│  Layer 5: Memory Protection                                         │
│  ├── Control-Flow Integrity (CFI)                                   │
│  ├── Full ASLR                                                      │
│  ├── Stack protection (SSP)                                         │
│  ├── NX/XD bit enforcement                                          │
│  └── Hardened memory allocator                                      │
│                                                                     │
│  Layer 4: Kernel Fortress                                           │
│  ├── linux-hardened kernel                                          │
│  ├── Kernel lockdown mode                                           │
│  ├── Restricted kernel modules                                      │
│  ├── Sysctl hardening                                               │
│  └── LKRG (optional)                                                │
│                                                                     │
│  Layer 3: System Integrity                                          │
│  ├── Immutable /usr (optional)                                      │
│  ├── IMA/EVM integrity measurement                                  │
│  ├── dm-verity for system partitions                                │
│  └── Audit logging                                                  │
│                                                                     │
│  Layer 2: Data Protection                                           │
│  ├── LUKS2 full disk encryption                                     │
│  ├── TPM-sealed encryption keys                                     │
│  ├── fscrypt for per-file encryption                                │
│  └── Secure key storage                                             │
│                                                                     │
│  Layer 1: Secure Boot                                               │
│  ├── UEFI Secure Boot                                               │
│  ├── Measured boot (TPM PCR)                                        │
│  ├── Unified Kernel Images (UKI)                                    │
│  └── Signed bootloader chain                                        │
│                                                                     │
│  Layer 0: Hardware Security                                         │
│  ├── TPM 2.0 support                                                │
│  ├── IOMMU/VT-d protection                                          │
│  ├── Hardware security key support                                  │
│  └── HSM integration (enterprise)                                   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 🖥️ Desktop Environment

### Base: KDE Plasma 6

```
┌─────────────────────────────────────────────────────────────────────┐
│  SANCHALA DESKTOP LAYOUT (macOS-style)                              │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ 🔵 │ File  Edit  View  Help │    Wed 10:30 │ 🔒 📶 🔊 🔋  │   │
│  └─────────────────────────────────────────────────────────────┘   │
│  ▲ Top Panel: Global menu bar                                       │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                                                             │   │
│  │                                                             │   │
│  │                      WALLPAPER                              │   │
│  │                                                             │   │
│  │                                                             │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │    📁   🦁   💻   📝   🎵   📷   ⚙️    │    📥   🗑️     │   │
│  │   Files Brave Term Kate Music Photo Set │   Down  Trash    │   │
│  └─────────────────────────────────────────────────────────────┘   │
│  ▲ Bottom Dock: Floating, magnification on hover                    │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### Window Decorations
- Traffic light buttons (left side): 🔴 Close, 🟡 Minimize, 🟢 Maximize
- Rounded corners (12px)
- Blur effects
- Drop shadows

### Keyboard Shortcuts (Standard)
| Action | Shortcut |
|--------|----------|
| Copy | Ctrl+C |
| Paste | Ctrl+V |
| Cut | Ctrl+X |
| Undo | Ctrl+Z |
| Save | Ctrl+S |
| Close Window | Ctrl+W |
| Close App | Ctrl+Q |
| Switch Apps | Alt+Tab |
| App Launcher | Super |
| Lock Screen | Super+L |
| Terminal | Ctrl+Alt+T |
| File Manager | Super+E |
| Screenshot | Print |

---

## 📦 Application Ecosystem

### Package Sources (Priority Order)

```
┌─────────────────────────────────────────────────────────────────────┐
│  APPLICATION SOURCES                                                │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  1. Flatpak (Flathub) ████████████ PRIMARY                         │
│     └── Desktop apps, sandboxed, portal-based                       │
│                                                                     │
│  2. Pacman (Arch)     ████████░░░░ SYSTEM                          │
│     └── System tools, CLI apps, libraries                           │
│                                                                     │
│  3. AUR               ████░░░░░░░░ COMMUNITY                        │
│     └── Community packages, build from source                       │
│     └── Warning displayed before install                            │
│                                                                     │
│  4. AppImage          ███░░░░░░░░░ PORTABLE                         │
│     └── Auto-sandboxed with Bubblewrap                              │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### Default Applications

| Category | Application | Reason |
|----------|-------------|--------|
| Browser | **Brave** | Privacy-focused, built-in ad blocker |
| File Manager | Dolphin | KDE native, feature-rich |
| Terminal | Konsole | KDE native, GPU accelerated |
| Text Editor | Kate | KDE native, developer-friendly |
| Office | LibreOffice | Full office suite |
| Media | VLC | Universal media player |
| Image Viewer | Gwenview | KDE native |
| PDF Reader | Okular | KDE native, secure |
| Archive | Ark | KDE native |

---

## 🔄 Update & Recovery System

### Btrfs Snapshot Strategy

```
┌─────────────────────────────────────────────────────────────────────┐
│  SNAPSHOT STRATEGY                                                  │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Automatic Snapshots:                                               │
│  ├── Before system updates     (always)                             │
│  ├── Daily snapshots           (keep 7)                             │
│  ├── Weekly snapshots          (keep 4)                             │
│  └── Monthly snapshots         (keep 3)                             │
│                                                                     │
│  Recovery Options:                                                  │
│  ├── GRUB menu: Boot to previous snapshot                           │
│  ├── GUI: Sanchala Backup app                                       │
│  ├── CLI: snapper rollback                                          │
│  └── Factory reset (keeps /home)                                    │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 🗂️ Filesystem Layout

```
/
├── boot/                    # Bootloader, kernel, initramfs
│   └── efi/                 # EFI System Partition
├── etc/                     # System configuration
│   ├── apparmor.d/          # AppArmor profiles
│   ├── sanchala/            # Sanchala-specific configs
│   └── sysctl.d/            # Kernel parameters
├── home/                    # User home directories (separate subvolume)
├── opt/                     # Third-party applications
├── root/                    # Root user home
├── tmp/                     # Temporary files (tmpfs)
├── usr/                     # User programs and data
│   ├── bin/                 # Binaries
│   ├── lib/                 # Libraries
│   └── share/               # Shared data
│       ├── sanchala/        # Sanchala resources
│       ├── themes/          # Themes
│       └── wallpapers/      # Wallpapers
├── var/                     # Variable data
│   ├── cache/               # Cache files
│   ├── log/                 # Log files
│   └── lib/flatpak/         # Flatpak installations
└── .snapshots/              # Btrfs snapshots (snapper)
```

### Btrfs Subvolumes

| Subvolume | Mount Point | Purpose |
|-----------|-------------|----------|
| @ | / | Root filesystem |
| @home | /home | User data (excluded from rollback) |
| @log | /var/log | Logs (excluded from rollback) |
| @cache | /var/cache | Cache (excluded from rollback) |
| @snapshots | /.snapshots | Snapshot storage |

---

## 🌐 NAWALA Ecosystem Integration

```
┌─────────────────────────────────────────────────────────────────────┐
│                    NAWALA ECOSYSTEM                                 │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌─────────────┐   ┌─────────────┐   ┌─────────────┐               │
│  │  SANCHALA   │   │   NAWALA    │   │   RAKSHA    │               │
│  │     OS      │   │   Gateway   │   │  Security   │               │
│  │   संञ्चल     │   │    नवल      │   │    रक्षा    │               │
│  └──────┬──────┘   └──────┬──────┘   └──────┬──────┘               │
│         │                 │                 │                       │
│         └─────────────────┼─────────────────┘                       │
│                           │                                         │
│                           ▼                                         │
│           ┌───────────────────────────────┐                         │
│           │    UNIFIED MANAGEMENT         │                         │
│           │    ───────────────────        │                         │
│           │    • Single sign-on           │                         │
│           │    • Centralized policy       │                         │
│           │    • Unified logging          │                         │
│           │    • Cross-platform alerts    │                         │
│           └───────────────────────────────┘                         │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 📋 Version History

| Version | Codename | Status | Release Date |
|---------|----------|--------|---------------|
| 1.0 | Gati | Current | 2026 |
| 2.0 | Vega | Planned | TBD |
| 3.0 | Dhruva | Planned | TBD |
| 4.0 | Ananta | Future | TBD |

---

**Document Version:** 1.0  
**Last Updated:** August 2026  
**Author:** Sanchala Team
