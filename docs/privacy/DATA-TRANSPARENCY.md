# 📋 Sanchala Data Transparency

## Overview

Sanchala OS provides complete transparency about what data exists on your system and how it's used.

## Data Inventory

### View Your Data
```bash
sanchala-privacy data --inventory
```

Output:
```
  Data Inventory

  📁 Recent Files: stored for 7 days
  🔍 Search History: stored for 7 days
  📋 Clipboard: not stored
  🖼️  Thumbnails: cached locally
  🔐 Credentials: encrypted in keyring
  📊 App Settings: local only
```

## Data Categories

### 1. System Data
| Data Type | Location | Retention | Encrypted |
|-----------|----------|-----------|-----------|
| System logs | /var/log | 30 days | No |
| Audit logs | /var/log/audit | 90 days | No |
| Boot logs | journald | 7 days | No |

### 2. User Data
| Data Type | Location | Retention | Encrypted |
|-----------|----------|-----------|-----------|
| Recent files | XDG cache | 7 days | No |
| Search history | local db | 7 days | No |
| Thumbnails | ~/.cache | Unlimited | No |
| Credentials | keyring | Permanent | ✅ Yes |

### 3. Application Data
| Data Type | Location | Retention | Control |
|-----------|----------|-----------|---------|
| Flatpak data | ~/.var/app | Per app | Sandboxed |
| Browser data | Profile dir | Per app | User |
| Config files | ~/.config | Permanent | User |

## Data Controls

### Clear Recent Files
```bash
# Clear recent files list
sanchala-privacy data --clear recent-files
```

### Clear Search History
```bash
# Clear search history
sanchala-privacy data --clear search-history
```

### Clear All Caches
```bash
# Clear all cached data
sanchala-privacy data --clear-cache
```

### Export Your Data (GDPR-style)
```bash
# Export all your data
sanchala-privacy data --export ~/my-data-export/
```

This exports:
- Permission grants and history
- Privacy settings
- Audit logs related to your account
- List of installed applications

## Data Retention Defaults

| Setting | Default | Recommended |
|---------|---------|-------------|
| Recent files | 7 days | 7 days or less |
| Search history | 7 days | 7 days or less |
| Browser history | 30 days | User choice |
| Clipboard | Disabled | Keep disabled |
| Audit logs | 30 days | 30 days |

### Configure Retention
```bash
# Set recent files retention
sanchala-privacy config --set data_retention.recent_files_days=3

# Disable clipboard history
sanchala-privacy config --set data_retention.clipboard_history_enabled=false
```

## Privacy Indicators

### Camera/Microphone Indicator
When camera or microphone is in use:
```
┌──────────────────────────┐
│ 🔴 Camera in use         │
│    by: Brave Browser     │
└──────────────────────────┘
```

### Location Indicator
When location is accessed:
```
┌──────────────────────────┐
│ 📍 Location accessed     │
│    by: Maps              │
└──────────────────────────┘
```

## What Sanchala NEVER Stores

- ❌ Passwords in plain text
- ❌ Telemetry data (unless opted in)
- ❌ Tracking identifiers
- ❌ Advertising profiles
- ❌ Biometric templates (local only)

---

**Document Version:** 1.0
