# Extension Marketplace Design

## Overview

SANCHALA OS integrates with the KDE Store while maintaining a curated **Sanchala Extensions Store** for verified, security-reviewed extensions.

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                   EXTENSION MARKETPLACE                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌─────────────────┐      ┌─────────────────┐              │
│  │  Sanchala Store │      │   KDE Store     │              │
│  │  (Primary)      │      │   (Secondary)   │              │
│  │  ─────────────  │      │  ─────────────  │              │
│  │  • Curated      │      │  • Community    │              │
│  │  • Reviewed     │      │  • ocs:// URLs  │              │
│  │  • Signed       │      │  • Warning UI   │              │
│  └────────┬────────┘      └────────┬────────┘              │
│           └──────────┬─────────────┘                        │
│                      ▼                                       │
│           ┌─────────────────────┐                           │
│           │ sanchala-extensions │                           │
│           │    CLI / GUI        │                           │
│           └─────────────────────┘                           │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## Store Sources

### 1. Sanchala Store (Primary)

- **URL**: `https://extensions.sanchala.id`
- **Content**: Curated, security-reviewed extensions
- **Trust Level**: High (signed by Sanchala)
- **Review Process**: Manual security audit

### 2. KDE Store (Secondary)

- **URL**: `https://store.kde.org` (ocs:// protocol)
- **Content**: Community-contributed extensions
- **Trust Level**: Medium (community reviewed)
- **Warning**: Shown before install

## Review Process

```
┌──────────┐    submit    ┌──────────┐    review    ┌──────────┐
│Developer │─────────────▶│ Pending  │─────────────▶│ Approved │
└──────────┘              └──────────┘              └──────────┘
                               │                         │
                               │ reject                  │ sign
                               ▼                         ▼
                          ┌──────────┐            ┌──────────┐
                          │ Rejected │            │ Published│
                          └──────────┘            └──────────┘
```

### Review Criteria

| Category | Requirements |
|----------|--------------|
| **Security** | No dangerous APIs, minimal permissions |
| **Quality** | No crashes, reasonable performance |
| **Design** | Follows SANCHALA UI guidelines |
| **License** | OSI-approved open source license |
| **Metadata** | Complete, accurate description |

## API Endpoints

```
GET  /api/v1/extensions              # List all
GET  /api/v1/extensions/{id}         # Get details
GET  /api/v1/extensions/{id}/download # Download package
GET  /api/v1/categories              # List categories
GET  /api/v1/search?q={query}        # Search
POST /api/v1/extensions              # Submit (authenticated)
```

## CLI Integration

```bash
# Browse store
sanchala-extensions browse

# Search
sanchala-extensions search "system monitor"

# Install from Sanchala Store
sanchala-extensions install org.sanchala.sysmonitor

# Install from KDE Store (shows warning)
sanchala-extensions install --kde plasma/plasmoid/example

# View extension info
sanchala-extensions info org.sanchala.sysmonitor

# Rate extension (requires account)
sanchala-extensions rate org.sanchala.sysmonitor 5
```

## GUI Integration

The store is accessible via:
- **System Settings** → Extensions
- **sanchala-store** application
- Right-click desktop → "Get New Widgets"

## Metadata Format

```json
{
    "id": "org.sanchala.sysmonitor",
    "name": "System Monitor",
    "description": "Real-time CPU, memory, and network stats",
    "version": "1.2.0",
    "author": "Sanchala Team",
    "license": "GPL-3.0",
    "category": "System",
    "type": "plasmoid",
    "permissions": ["system-info"],
    "screenshots": ["url1", "url2"],
    "downloads": 15420,
    "rating": 4.8,
    "verified": true,
    "signature": "base64...",
    "minSanchalaVersion": "1.0"
}
```

## Security Indicators

| Badge | Meaning |
|-------|---------|
| ✓ Verified | Reviewed by Sanchala team |
| 🔒 Signed | Cryptographically signed package |
| ⚠️ Community | From KDE Store, not reviewed |
| 🔴 Dangerous | Requests sensitive permissions |

---
**Version:** 1.0 | **Last Updated:** August 2026
