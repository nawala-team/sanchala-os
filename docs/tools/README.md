# Sanchala OS Tools Overview

## System Tools

Sanchala OS includes a suite of custom tools designed to provide a secure, beautiful, and user-friendly experience.

| Tool | Purpose | Status |
|------|---------|--------|
| [sanchala-guardian](sanchala-guardian.md) | Security Center | In Development |
| [sanchala-welcome](sanchala-welcome.md) | First-Boot Wizard | Planned |
| [sanchala-store](sanchala-store.md) | Application Center | Planned |
| [sanchala-backup](sanchala-backup.md) | Snapshot Manager | Planned |
| [sanchala-permissions](sanchala-permissions.md) | Permission Manager | Planned |
| [sanchala-cleaner](sanchala-cleaner.md) | System Maintenance | ✅ Complete |
| [sanchala-privacy](sanchala-privacy.md) | Privacy Center | In Development |

## Technology Stack

All tools follow consistent technology choices:

| Layer | Technology |
|-------|------------|
| Backend/Daemon | Rust |
| Frontend/GUI | Qt 6 / QML |
| IPC | D-Bus |
| Styling | KDE Breeze + Sanchala theme |
| Authorization | Polkit |

## Design Principles

1. **Security First**: All tools integrate with sanchala-guardian
2. **Privacy by Default**: Telemetry OFF, permissions explicit
3. **KDE HIG Compliance**: Consistent with Plasma desktop
4. **Accessibility**: WCAG 2.1 AA compliance target
5. **Offline Capable**: Core features work without internet

## Directory Structure

```
/tools/
├── sanchala-guardian/       # Security center daemon
│   ├── src/
│   │   ├── main.rs          # CLI and entry point
│   │   ├── security.rs      # Security checks and AppArmor
│   │   ├── permissions.rs   # TCC-like permissions
│   │   └── audit.rs         # Audit log integration
│   └── Cargo.toml
├── sanchala-welcome/        # First-boot wizard
├── sanchala-store/          # App store
├── sanchala-backup/         # Snapshot manager
└── sanchala-permission-manager/  # Permission UI
```

## Integration Points

```
┌─────────────────────────────────────────────────────────────┐
│                    USER INTERFACE                            │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐           │
│  │Settings │ │ Store   │ │ Backup  │ │ Welcome │           │
│  └────┬────┘ └────┬────┘ └────┬────┘ └────┬────┘           │
│       │           │           │           │                 │
│       └───────────┴─────┬─────┴───────────┘                 │
│                         │                                    │
│                  ┌──────┴──────┐                            │
│                  │  Guardian   │                            │
│                  │  (D-Bus)    │                            │
│                  └──────┬──────┘                            │
│                         │                                    │
│    ┌────────────────────┼────────────────────┐              │
│    ▼                    ▼                    ▼              │
│ AppArmor            Audit               Firewall            │
└─────────────────────────────────────────────────────────────┘
```

## Development Guidelines

- Use `cargo fmt` and `cargo clippy` before commits
- Follow Rust API Guidelines
- Write unit tests for all public functions
- Document public APIs with rustdoc
- Use `log` crate for logging, not println!
