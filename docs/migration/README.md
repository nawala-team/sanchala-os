# Migration Guide

Welcome to Sanchala OS! This guide helps you migrate your data from Windows, macOS, or other Linux distributions.

## Overview

Sanchala Migrate makes switching operating systems painless by automatically transferring:

- **Documents** — Documents, Downloads, Pictures, Music, Videos
- **Browser Data** — Bookmarks, passwords, history, extensions
- **Settings** — WiFi networks, fonts, SSH keys
- **Application Suggestions** — Linux alternatives for your apps

## Quick Start

```bash
# 1. Mount your old OS partition
sudo mount /dev/sdXY /mnt/old-os

# 2. Detect available sources
sanchala-migrate detect

# 3. Run migration
sanchala-migrate --source /mnt/old-os migrate
```

## Migration Guides

| Source OS | Guide |
|-----------|-------|
| Windows 10/11 | [Windows Migration Guide](WINDOWS-MIGRATION.md) |
| macOS | [macOS Migration Guide](MACOS-MIGRATION.md) |
| Other Linux | [Linux Migration Guide](LINUX-MIGRATION.md) |

## Data-Specific Guides

| Data Type | Guide |
|-----------|-------|
| Browser Data | [Browser Import Guide](BROWSER-IMPORT.md) |
| Documents | [Document Migration](DOCUMENT-MIGRATION.md) |
| Application Mapping | [App Alternatives](APP-MAPPING.md) |

## Help & Support

| Resource | Description |
|----------|-------------|
| [FAQ](FAQ.md) | Frequently asked questions |
| [Troubleshooting](TROUBLESHOOTING.md) | Common issues and solutions |
| [Forum](https://forum.sanchala.id) | Community support |

## Before You Begin

### Checklist

- [ ] Back up important data on source system
- [ ] Note your WiFi passwords
- [ ] Export browser passwords (if needed)
- [ ] Identify must-have applications

### Requirements

- Source partition mounted and readable
- Sufficient disk space on Sanchala OS
- `sanchala-migrate` tool (pre-installed)

## What Gets Migrated

| Data | Windows | macOS | Linux |
|------|---------|-------|-------|
| Documents folder | ✓ | ✓ | ✓ |
| Downloads | ✓ | ✓ | ✓ |
| Pictures | ✓ | ✓ | ✓ |
| Music | ✓ | ✓ | ✓ |
| Videos | ✓ | ✓ | ✓ |
| Desktop | ✓ | ✓ | ✓ |
| Chrome bookmarks | ✓ | ✓ | ✓ |
| Firefox bookmarks | ✓ | ✓ | ✓ |
| Safari bookmarks | — | ✓ | — |
| WiFi profiles | ✓ | ○ | ✓ |
| Fonts | ✓ | ✓ | ✓ |
| SSH keys | ○ | ○ | ○ |

✓ = Automatic  ○ = Manual/Guide provided  — = Not applicable

## Command Reference

```bash
sanchala-migrate detect              # Find migration sources
sanchala-migrate analyze             # Preview migration plan
sanchala-migrate migrate             # Run full migration
sanchala-migrate --dry-run migrate   # Preview without changes
sanchala-migrate browser --all       # Import browser data only
sanchala-migrate documents           # Import documents only
sanchala-migrate status              # Check migration progress
sanchala-migrate --resume            # Resume interrupted migration
```

---

**Next:** Choose your migration guide above based on your source OS.

