# 🎛️ Sanchala OS - Settings Documentation

## Overview

This directory contains all documentation related to Sanchala OS system settings,
the Control Center application, and KDE configuration management.

---

## 📚 Documentation Index

| Document | Description |
|----------|-------------|
| [CONTROL-CENTER-SPEC.md](CONTROL-CENTER-SPEC.md) | Control Center application design specification |
| [SETTINGS-CATEGORIES.md](SETTINGS-CATEGORIES.md) | Complete settings hierarchy and categories |
| [DEFAULT-SETTINGS.md](DEFAULT-SETTINGS.md) | All default values for fresh installations |
| [CUSTOM-KCM-MODULES.md](CUSTOM-KCM-MODULES.md) | Sanchala custom KCM module specifications |

---

## 🗂️ Settings File Locations

### User Settings (per-user)
```
~/.config/
├── kdeglobals              # KDE global settings
├── kwinrc                  # Window manager
├── kglobalshortcutsrc      # Keyboard shortcuts
├── plasmanotifyrc          # Notifications
├── powermanagementprofilesrc  # Power management
├── krunnerrc               # Application launcher
├── dolphinrc               # File manager
├── konsolerc               # Terminal
├── baloofilerc             # File indexing
├── kscreenrc               # Display settings
└── sanchala/
    ├── privacy.conf        # Privacy settings
    └── guardian.conf       # Security settings
```

### System Settings (all users)
```
/etc/skel/.config/          # Default settings for new users
/usr/share/color-schemes/   # Color schemes
/usr/share/plasma/          # Plasma themes
/usr/share/icons/           # Icon themes
```

---

## 🔑 Key Design Principles

1. **Privacy by Default** - All telemetry OFF, minimal data collection
2. **Security First** - Firewall ON, AppArmor enforcing, encryption supported
3. **macOS-like UX** - Familiar layout, intuitive navigation
4. **Unified Settings** - One place for everything (Control Center)
5. **Searchable** - Global search across all settings
6. **Accessible** - Full keyboard navigation, screen reader support

---

## 🎨 Visual Identity

The Control Center follows Sanchala branding:

- **Primary Color:** Sanchala Indigo (#3949AB)
- **Accent Color:** Electric Blue (#536DFE)
- **Dark Theme:** Charcoal (#212121) background
- **Light Theme:** Light Gray (#F5F5F5) background
- **Font:** Inter (UI), JetBrains Mono (code)
- **Icons:** sanchala-icons theme
- **Border Radius:** 12px for panels, 8px for buttons

---

## ⌨️ Default Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| Meta | App Launcher (Overview) |
| Meta+Space | KRunner (Spotlight-like) |
| Meta+I | System Settings |
| Meta+E | File Manager |
| Meta+Return | Terminal |
| Meta+L | Lock Screen |
| Meta+D | Show Desktop |
| Meta+Tab | Overview |
| Meta+1-4 | Switch Desktop |
| Meta+Shift+S | Screenshot (region) |
| Print | Screenshot (full) |

---

## 🔧 Configuration Management

### KConfig System
Sanchala uses KDE's KConfig for settings storage:
- INI-style files in `~/.config/`
- Cascading defaults from `/etc/xdg/`
- D-Bus notifications for real-time updates

### Settings Sync (Future)
Planned for Sanchala 2.0 (Vega):
- Cloud sync via Nextcloud/WebDAV
- End-to-end encrypted
- Selective sync by category

---

## 📦 Related Packages

| Package | Description |
|---------|-------------|
| sanchala-settings | KDE settings defaults |
| sanchala-guardian | Security center |
| sanchala-icons | Icon theme |
| sanchala-wallpapers | Wallpaper collection |

---

## 🤝 Contributing

To modify default settings:
1. Edit files in `/settings/etc/skel/.config/`
2. Test on fresh user account
3. Document changes in this directory
4. Submit PR with rationale

---

**Document Version:** 1.0  
**Last Updated:** Phase 1 Sprint  
**Maintainer:** System Settings Engineer
