# Welcome Experience Documentation

The Sanchala Welcome system provides a macOS-quality first-run experience (OOBE) for Sanchala OS.

## Components

| Component | Description |
|-----------|-------------|
| **Setup Wizard** | 12-page first-boot configuration |
| **Feature Tours** | Interactive guided tours of the desktop |
| **Tips System** | Contextual tips and tricks |
| **Headless Setup** | Automated/scripted installation |

## Documentation

- [First-Run Wizard](guides/FIRST-RUN-WIZARD.md) - Complete wizard flow specification
- [Feature Tours](guides/FEATURE-TOURS.md) - Tour system and authoring
- [Tips System](guides/TIPS-SYSTEM.md) - Contextual tips and scheduling
- [Headless Setup](guides/HEADLESS-SETUP.md) - Automated configuration
- [API Reference](api/DBUS-API.md) - D-Bus interface documentation

## Quick Start

```bash
# Launch wizard (only runs on first boot)
sanchala-welcome

# Force re-run
sanchala-welcome --force

# Launch feature tour
sanchala-welcome --tour

# Show tips
sanchala-welcome --tips
```

## Design Principles

1. **Beautiful** - Smooth animations, polished UI
2. **Fast** - Complete setup in under 5 minutes
3. **Privacy-First** - All telemetry OFF by default
4. **Accessible** - Full keyboard/screen reader support
5. **Smart** - Auto-detect hardware, locale, timezone

## File Locations

| Path | Purpose |
|------|---------|
| `/usr/share/sanchala/welcome/` | Assets, tours, tips |
| `/etc/sanchala/welcome.toml` | System configuration |
| `/var/lib/sanchala/welcome/` | Runtime state |
| `~/.config/sanchala/welcome/` | User preferences |

---

**Part of SANCHALA OS** - Beautiful from the First Moment
