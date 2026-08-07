# 📦 SANCHALA OS - Delta Update Specification

## Overview

Delta updates reduce bandwidth by downloading only the binary differences between package versions instead of full packages.

---

## 🎯 Benefits

| Metric | Full Download | Delta Update | Savings |
|--------|---------------|--------------|---------|
| Typical package | 50 MB | 5-15 MB | 70-90% |
| Kernel update | 120 MB | 20-40 MB | 67-83% |
| Browser update | 80 MB | 10-25 MB | 69-88% |

---

## 🏗️ Delta Format

### File Naming Convention
```
<package>-<old_version>_to_<new_version>.delta
```

Example: `firefox-126.0-1_to_127.0-1.delta`

### Delta File Structure
```
┌─────────────────────────────────────┐
│ Delta Header (64 bytes)             │
├─────────────────────────────────────┤
│ - Magic: "SDELTA01"                 │
│ - Source hash (SHA256)              │
│ - Target hash (SHA256)              │
│ - Compression: zstd                 │
│ - Algorithm: xdelta3 / bsdiff       │
├─────────────────────────────────────┤
│ Delta Payload (compressed)          │
│ - Binary diff data                  │
└─────────────────────────────────────┘
```

---

## 🔄 Delta Generation Process

```bash
# Server-side delta generation
xdelta3 -e -s old_package.pkg.tar.zst new_package.pkg.tar.zst delta.xd3
zstd delta.xd3 -o package-old_to_new.delta
```

### Generation Rules

1. **Version proximity** - Only generate deltas for sequential versions
2. **Size threshold** - Skip if delta > 50% of full package
3. **Age limit** - Remove deltas older than 30 days
4. **Architecture match** - Separate deltas per architecture

---

## 📥 Client-Side Application

### Delta Download Flow

```
1. Check for updates (pacman -Qu)
        │
        ▼
2. For each update, check delta availability
        │
        ▼
3. If delta exists AND old package cached:
   ├── Download delta file
   ├── Verify delta hash
   ├── Apply: old_pkg + delta → new_pkg
   └── Verify new package hash
        │
        ▼
4. If no delta OR old package missing:
   └── Download full package
```

### Application Command

```bash
# Using xdelta3
xdelta3 -d -s /var/cache/pacman/pkg/firefox-126.0-1.pkg.tar.zst \
           firefox-126.0-1_to_127.0-1.delta \
           /var/cache/pacman/pkg/firefox-127.0-1.pkg.tar.zst

# Verify result
sha256sum /var/cache/pacman/pkg/firefox-127.0-1.pkg.tar.zst
```

---

## ⚙️ Configuration

```bash
# /etc/sanchala-updater/updater.conf

# Enable delta updates
DELTA_ENABLED=true

# Delta server URL
DELTA_SERVER="https://updates.sanchala.os/deltas"

# Maximum delta age (days)
DELTA_MAX_AGE=30

# Fallback to full download if delta fails
DELTA_FALLBACK=true
```

---

## 🔒 Security

1. **Hash verification** - Both source and target packages verified
2. **Signed deltas** - GPG signatures on delta metadata
3. **HTTPS only** - All delta downloads over TLS
4. **Fallback** - Full package download if verification fails

---

## 📊 Delta Server API

```
GET /deltas/<package>/<delta_file>
    Returns: Delta file binary

GET /deltas/<package>/manifest.json
    Returns: Available deltas for package
    {
      "package": "firefox",
      "deltas": [
        {
          "from": "126.0-1",
          "to": "127.0-1",
          "size": 12453678,
          "hash": "sha256:abc123...",
          "algorithm": "xdelta3"
        }
      ]
    }
```

---

**Document Version:** 1.0  
**Last Updated:** August 2026
