# Sanchala OS - Master System Architecture

**Version:** 6.0.0  
**Author:** Chief Architect, Sanchala OS Project  
**Classification:** Core Technical Documentation  

---

## 1. Executive Overview

Sanchala OS is a modern, security-focused Linux distribution built on Arch Linux foundations with deep KDE Plasma integration.

### 1.1 Design Philosophy

```
┌─────────────────────────────────────────────────────────────────┐
│                    SANCHALA OS PRINCIPLES                       │
├─────────────────────────────────────────────────────────────────┤
│  1. Security First    - Every component assumes hostile input   │
│  2. User Sovereignty  - Users control their data and system     │
│  3. Transparency      - Open source, auditable, documented      │
│  4. Performance       - Native speed, minimal abstraction       │
│  5. Consistency       - Unified UX across all tools             │
│  6. Reliability       - Zero tolerance for data loss            │
└─────────────────────────────────────────────────────────────────┘
```

### 1.2 Target Platforms

| Platform | Architecture | Support Level |
|----------|--------------|---------------|
| Desktop  | x86_64       | Primary       |
| Desktop  | aarch64      | Primary       |
| Laptop   | x86_64       | Primary       |
| Server   | x86_64       | Secondary     |

---

## 2. System Architecture Layers

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         USER SPACE - LAYER 4                            │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐       │
│  │ sanchala-  │ │ sanchala-  │ │ sanchala-  │ │ sanchala-  │       │
│  │ welcome    │ │ settings   │ │ store      │ │ backup     │       │
│  └─────────────┘ └─────────────┘ └─────────────┘ └─────────────┘       │
├─────────────────────────────────────────────────────────────────────────┤
│                      SYSTEM SERVICES - LAYER 3                          │
│  ┌───────────────────┐ ┌───────────────────┐ ┌───────────────────┐     │
│  │ sanchala-daemon   │ │ sanchala-polkit   │ │ sanchala-dbus     │     │
│  └───────────────────┘ └───────────────────┘ └───────────────────┘     │
├─────────────────────────────────────────────────────────────────────────┤
│                       CORE LIBRARIES - LAYER 2                          │
│  ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐           │
│  │ libsanchala-   │ │ libsanchala-   │ │ libsanchala-   │           │
│  │ core           │ │ ui             │ │ security       │           │
│  └─────────────────┘ └─────────────────┘ └─────────────────┘           │
├─────────────────────────────────────────────────────────────────────────┤
│                      SYSTEM FOUNDATION - LAYER 1                        │
│  ┌───────────┐ ┌───────────┐ ┌───────────┐ ┌───────────┐ ┌───────────┐│
│  │  systemd  │ │   D-Bus   │ │  PolicyKit│ │   udev    │ │  Kernel   ││
│  └───────────┘ └───────────┘ └───────────┘ └───────────┘ └───────────┘│
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 3. Component Registry

### 3.1 Core Tools (Phase 6)

| Tool Name | Type | Purpose | Priority |
|-----------|------|---------|----------|
| `sanchala-welcome` | GUI | First-run experience | P0 |
| `sanchala-settings` | GUI | System configuration | P0 |
| `sanchala-store` | GUI | Software management | P0 |
| `sanchala-update` | GUI/CLI | System updates | P0 |

---

## 4. Directory Structure

```
/
├── etc/sanchala/
│   ├── sanchala.conf           # Master configuration
│   ├── tools/                   # Per-tool configs
│   └── policies/                # PolicyKit policies
├── usr/
│   ├── bin/                     # sanchala-* executables
│   ├── lib/sanchala/
│   │   ├── python/sanchala/    # Python modules
│   │   └── plugins/            # Plugin directory
│   └── share/sanchala/
│       ├── icons/
│       ├── themes/
│       └── translations/
├── var/
│   ├── lib/sanchala/           # Persistent state
│   ├── log/sanchala/           # Log files
│   └── cache/sanchala/         # Runtime cache
└── run/sanchala/               # Runtime sockets/PIDs
```

---

## 5. D-Bus Architecture

```
Bus Name: org.sanchala.Daemon
├── /org/sanchala/Daemon
│   ├── org.sanchala.Daemon.System
│   ├── org.sanchala.Daemon.Package
│   └── org.sanchala.Daemon.Update

Bus Name: org.sanchala.Settings
└── /org/sanchala/Settings
    └── org.sanchala.Settings.Manager
```

---

## 6. Security Architecture

### 6.1 PolicyKit Actions

| Action | Description | Auth Level |
|--------|-------------|------------|
| `org.sanchala.package.install` | Install packages | `auth_admin` |
| `org.sanchala.package.remove` | Remove packages | `auth_admin` |
| `org.sanchala.system.update` | System update | `auth_admin` |
| `org.sanchala.settings.system` | System settings | `auth_admin` |
| `org.sanchala.settings.user` | User settings | `auth_self` |

### 6.2 Input Validation

All external input MUST be validated using `sanchala.core.validation` module.

---

## 7. Configuration Hierarchy

```
Priority (Highest to Lowest):
1. Command-line arguments      --config-key=value
2. Environment variables       SANCHALA_CONFIG_KEY
3. User config                 ~/.config/sanchala/
4. System config               /etc/sanchala/
5. Built-in defaults           Compiled into tools
```

---

## 8. Error Codes

| Code Range | Category |
|------------|----------|
| 1-9 | General errors |
| 10-19 | Configuration errors |
| 20-29 | Network errors |
| 30-39 | Package errors |
| 40-49 | Security errors |
| 50-59 | I/O errors |

---

## 9. Quality Gates

Before any component is marked COMPLETE:

- [ ] All code follows CODING-STANDARDS.md
- [ ] All APIs follow API-CONVENTIONS.md
- [ ] Unit test coverage ≥80%
- [ ] Security review completed
- [ ] Documentation complete
- [ ] PKGBUILD validated
- [ ] No compiler/linter warnings

---

*This document is the authoritative source for Sanchala OS architecture.*

| `sanchala-backup` | GUI/CLI | Backup/restore | P1 |
| `sanchala-privacy` | GUI | Privacy controls | P1 |
| `sanchala-firewall` | GUI | Firewall management | P1 |
| `sanchala-monitor` | GUI | System monitoring | P1 |
| `sanchala-recovery` | CLI | System recovery | P1 |
| `sanchala-theme` | GUI | Theme management | P2 |
| `sanchala-driver` | GUI | Driver management | P2 |
| `sanchala-hardware` | GUI | Hardware info | P2 |
| `sanchala-log` | GUI | Log viewer | P2 |

