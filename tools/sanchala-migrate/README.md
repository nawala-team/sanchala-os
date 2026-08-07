# Sanchala Migrate

Universal migration tool for seamless transition from Windows, macOS, and other operating systems to Sanchala OS.

## Overview

**sanchala-migrate** provides a guided, secure migration experience that transfers your documents, browser data, settings, and application preferences from your previous operating system.

## Features

- **Cross-Platform Import**: Migrate from Windows 10/11, macOS, and other Linux distributions
- **Browser Data Import**: Chrome, Firefox, Safari, Edge, Brave bookmarks, passwords, extensions
- **Document Migration**: Automatic organization with smart folder mapping
- **Settings Transfer**: WiFi networks, keyboard shortcuts, display preferences
- **Application Mapping**: Suggests Linux alternatives for Windows/macOS apps
- **Secure Transfer**: Encrypted transfer with integrity verification
- **Incremental Sync**: Resume interrupted migrations

## Directory Structure

```
sanchala-migrate/
├── sanchala-migrate              # Main executable
├── lib/
│   ├── core.sh                   # Core migration functions
│   ├── detect.sh                 # Source OS detection
│   ├── browser.sh                # Browser import functions
│   ├── documents.sh              # Document transfer functions
│   ├── settings.sh               # Settings migration functions
│   └── security.sh               # Secure transfer & verification
├── plugins/
│   ├── windows.sh                # Windows-specific migration
│   ├── macos.sh                  # macOS-specific migration
│   ├── chrome.sh                 # Chrome/Chromium import
│   ├── firefox.sh                # Firefox import
│   ├── safari.sh                 # Safari import
│   ├── edge.sh                   # Microsoft Edge import
│   └── brave.sh                  # Brave browser import
├── profiles/
│   ├── windows-default.conf      # Default Windows migration profile
│   ├── macos-default.conf        # Default macOS migration profile
│   ├── linux-default.conf        # Default Linux migration profile
│   └── minimal.conf              # Quick minimal migration
├── templates/
│   └── folder-mapping.conf       # Folder mapping configuration
└── README.md
```

## Quick Start

```bash
# Launch migration wizard
sanchala-migrate

# Detect available sources
sanchala-migrate detect

# Full migration from Windows partition
sanchala-migrate --source /mnt/windows --type windows migrate

# Import browser data only
sanchala-migrate browser --all

# Dry run (preview only)
sanchala-migrate --source /mnt/macos --dry-run migrate
```

## Commands

| Command | Description |
|---------|-------------|
| `detect` | Detect available migration sources |
| `analyze` | Analyze source and show migration plan |
| `migrate` | Run full migration |
| `browser` | Import browser data only |
| `documents` | Import documents only |
| `settings` | Import settings only |
| `status` | Show migration status |
| `rollback` | Undo last migration |

## Browser Support

| Browser | Bookmarks | Passwords | History | Extensions |
|---------|-----------|-----------|---------|------------|
| Chrome | ✓ | ✓ | ✓ | ✓ |
| Firefox | ✓ | ✓ | ✓ | ✓ |
| Safari | ✓ | ✓* | ✓ | ✗ |
| Edge | ✓ | ✓ | ✓ | ✓ |
| Brave | ✓ | ✓ | ✓ | ✓ |

*Safari passwords require Keychain export on macOS

## Migration Profiles

| Profile | Use Case |
|---------|----------|
| `windows-default` | Full Windows 10/11 migration |
| `macos-default` | Full macOS migration |
| `linux-default` | Linux distribution migration |
| `minimal` | Quick migration (documents only) |

```bash
# Use specific profile
sanchala-migrate --profile minimal --source /mnt/windows migrate
```

## Documentation

- [Migration Overview](../../docs/migration/README.md)
- [Windows Migration Guide](../../docs/migration/WINDOWS-MIGRATION.md)
- [macOS Migration Guide](../../docs/migration/MACOS-MIGRATION.md)
- [Linux Migration Guide](../../docs/migration/LINUX-MIGRATION.md)
- [Browser Import Guide](../../docs/migration/BROWSER-IMPORT.md)
- [Document Migration](../../docs/migration/DOCUMENT-MIGRATION.md)
- [App Mapping Guide](../../docs/migration/APP-MAPPING.md)
- [FAQ](../../docs/migration/FAQ.md)
- [Troubleshooting](../../docs/migration/TROUBLESHOOTING.md)

## License

GPL-3.0 - See [LICENSE](../../LICENSE)
