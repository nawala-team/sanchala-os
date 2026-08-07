# 🧩 SANCHALA OS - Extension Framework

## Overview

The SANCHALA OS Extension Framework provides a **safe, curated extension ecosystem** for customizing and enhancing the desktop experience. Built on KDE's proven extension architecture with additional security layers, it enables users to extend functionality while maintaining system integrity.

## Design Principles

1. **Security First** - All extensions run sandboxed with explicit permissions
2. **Curated Quality** - Official store with review process
3. **Native Performance** - QML/JavaScript for Plasma, native code where needed
4. **Consistent UX** - Extensions follow SANCHALA design guidelines
5. **Easy Discovery** - Integrated marketplace with KDE Store

## Extension Types

| Type | Description | Runtime | Sandbox Level |
|------|-------------|---------|---------------|
| **Plasmoid** | Desktop/panel widgets | QML/JavaScript | Medium |
| **KWin Script** | Window management | JavaScript | Medium |
| **KWin Effect** | Visual effects | C++/QML | Low (native) |
| **Plasma Theme** | Desktop appearance | SVG/CSS | High (static) |
| **Color Scheme** | System colors | INI | High (static) |
| **Look & Feel** | Complete theme pack | Package | High |
| **Dolphin Plugin** | File manager actions | C++/Script | Medium |
| **Aurorae Theme** | Window decorations | SVG/QML | High |

## Quick Start

```bash
# Search for extensions
sanchala-extensions search "system monitor"

# Install from Sanchala Store (recommended)
sanchala-extensions install org.sanchala.sysmonitor

# Install from KDE Store
sanchala-extensions install --kde store://plasma/plasmoid/name

# List installed / Update all
sanchala-extensions list
sanchala-extensions update

# Enable/disable extension
sanchala-extensions enable org.sanchala.sysmonitor
sanchala-extensions disable org.sanchala.sysmonitor
```

## Documentation Index

| Document | Description |
|----------|-------------|
| [FRAMEWORK-SPEC.md](FRAMEWORK-SPEC.md) | Technical framework specification |
| [PLASMOID-GUIDELINES.md](PLASMOID-GUIDELINES.md) | Widget development guide |
| [KWIN-SCRIPTS.md](KWIN-SCRIPTS.md) | Window script development |
| [MARKETPLACE.md](MARKETPLACE.md) | Store and distribution |
| [SANDBOX-RUNTIME.md](SANDBOX-RUNTIME.md) | Security sandboxing spec |
| [DEFAULT-EXTENSIONS.md](DEFAULT-EXTENSIONS.md) | Bundled extension pack |

## File Locations

```
System: /usr/share/plasma/plasmoids/, /usr/share/kwin/scripts/
User:   ~/.local/share/plasma/plasmoids/, ~/.local/share/kwin/scripts/
Config: ~/.config/sanchala/extensions.toml
```

## Default Extensions

- **Plasmoids**: Control Center, Now Playing, System Monitor
- **KWin Scripts**: Tiling, Stage Manager, Quick Tile
- **Themes**: sanchala/sanchala-dark, SanchalaLight/SanchalaDark

---

**Document Version:** 1.0 | **Last Updated:** August 2026
