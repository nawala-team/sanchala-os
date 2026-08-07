# 🔍 SANCHALA OS - Search & Indexing System

## Overview

Sanchala OS provides a **Spotlight-quality unified search** experience powered by Baloo indexing and KRunner. Press `Meta+Space` for instant access to applications, files, documents, calculations, and system commands.

---

## ✨ Key Features

### Instant Search
- **Sub-100ms** response for cached queries
- Search-as-you-type with 150ms delay
- Fuzzy matching for typo tolerance
- Smart ranking based on usage patterns

### Content Search
- Full-text search inside documents
- PDF, Office, eBook content indexing
- Source code search with syntax awareness
- Media metadata (EXIF, ID3 tags)

### Privacy-First Design
- No cloud/network searches by default
- Encrypted search history option
- Sensitive directories excluded
- Respects `.noindex` markers

---

## 🚀 Quick Start

### Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Meta+Space` | Open unified search |
| `Alt+Space` | Alternative trigger |
| `Escape` | Close search |
| `Enter` | Execute selected result |
| `Ctrl+Enter` | Secondary action |
| `Ctrl+C` | Copy result (calculator) |
| `↑/↓` | Navigate results |
| `Tab` | Cycle categories |

### Search Examples

```
firefox              → Launch Firefox
settings             → Open System Settings
~/Documents/report   → Find files by path
content:budget 2024  → Search inside documents
=sqrt(144)*2         → Calculator: 24
5km in miles         → Unit conversion: 3.107 mi
define:ephemeral     → Dictionary lookup
gg:kde plasma        → Google search
kill chrome          → Terminate process
lock                 → Lock screen
```

---

## 📁 File Indexing (Baloo)

### What Gets Indexed

| Category | Content Indexed | Metadata |
|----------|-----------------|----------|
| Documents | ✅ Full text | ✅ |
| PDFs | ✅ Full text | ✅ |
| Source Code | ✅ Full text | ✅ |
| Images | ❌ | ✅ EXIF |
| Audio | ❌ | ✅ ID3/tags |
| Video | ❌ | ✅ Metadata |
| Archives | ❌ | ✅ File list |

### Excluded by Default

- Cache directories (`~/.cache`)
- Browser data (`~/.mozilla`, `~/.config/BraveSoftware`)
- Security files (`~/.gnupg`, `~/.ssh`, `~/.password-store`)
- Development caches (`node_modules`, `__pycache__`, `.venv`)
- System directories (`/proc`, `/sys`, `/tmp`)
- Trash (`~/.local/share/Trash`)

### Configuration

```ini
# ~/.config/baloofilerc

[General]
only basic indexing=false    # Enable content indexing
index hidden folders=false   # Skip hidden dirs

[ContentIndexing]
enabled=true
indexText=true
maxFileSize=15728640        # 15MB limit

[Performance]
indexOnBattery=false        # Save battery
lowPriority=true            # Don't slow system
```

### Baloo Commands

```bash
# Check indexing status
balooctl6 status

# Monitor indexing progress
balooctl6 monitor

# Search from terminal
baloosearch6 "budget report"

# Rebuild index (if corrupted)
balooctl6 disable
rm -rf ~/.local/share/baloo
balooctl6 enable

# Exclude a folder
balooctl6 config add excludeFolders /path/to/folder
```

---

## 🧮 Calculator

Prefix with `=` or just type mathematical expressions.

### Basic Math
```
=2+2              → 4
=15% of 200       → 30
=(5+3)*2^3        → 64
=sqrt(144)        → 12
=sin(45 deg)      → 0.707...
```

### Functions Available
- **Trigonometry**: sin, cos, tan, asin, acos, atan
- **Logarithms**: log, log10, log2, ln
- **Roots**: sqrt, cbrt, root(n,x)
- **Rounding**: ceil, floor, round, abs
- **Statistics**: min, max, avg, sum
- **Other**: factorial (!), gcd, lcm, exp, pow

### Constants
- `pi` = 3.14159...
- `e` = 2.71828...
- `phi` = 1.61803... (golden ratio)

### Base Conversion
```
=0xFF             → 255 (hex to decimal)
=0b1010           → 10 (binary to decimal)
=toHex(255)       → 0xFF
=toBin(10)        → 0b1010
```

---

## 📐 Unit Converter

Type natural conversion queries:

### Examples
```
5 km in miles         → 3.107 mi
100 F to C            → 37.78 °C
2.5 hours in minutes  → 150 min
500 MB to GB          → 0.5 GB
1 cup in mL           → 236.588 mL
```

### Supported Categories
- **Length**: km, m, cm, mm, mi, yd, ft, in
- **Weight**: kg, g, lb, oz, ton
- **Temperature**: C, F, K
- **Volume**: L, mL, gal, cup, tbsp
- **Speed**: km/h, mph, m/s, knots
- **Data**: B, KB, MB, GB, TB, KiB, MiB, GiB
- **Time**: s, min, h, day, week, year
- **Area**: m², ft², acres, hectares
- **Pressure**: bar, psi, atm, mmHg
- **Energy**: J, kWh, cal, BTU

---

## 🌐 Web Search Shortcuts

Use prefix + colon + query:

| Prefix | Service | Example |
|--------|---------|--------|
| `ddg:` | DuckDuckGo | `ddg:privacy browser` |
| `gg:` | Google | `gg:kde plasma 6` |
| `wp:` | Wikipedia | `wp:Linux kernel` |
| `gh:` | GitHub | `gh:baloo indexer` |
| `so:` | Stack Overflow | `so:bash loop` |
| `yt:` | YouTube | `yt:arch install` |
| `aw:` | Arch Wiki | `aw:pacman` |
| `maps:` | OpenStreetMap | `maps:Tokyo` |
| `pkg:` | Arch Packages | `pkg:firefox` |
| `aur:` | AUR | `aur:spotify` |

---

## ⚡ System Commands

Quick access to system actions:

| Command | Action |
|---------|--------|
| `lock` | Lock screen |
| `logout` | Log out |
| `shutdown` | Power off |
| `restart` | Reboot |
| `suspend` | Sleep |
| `hibernate` | Hibernate |
| `settings` | System Settings |
| `kill <app>` | Terminate application |

---

## 🔧 Configuration Files

| File | Purpose |
|------|--------|
| `~/.config/baloofilerc` | File indexing settings |
| `~/.config/krunnerrc` | Search runner configuration |
| `~/.config/sanchala/search.conf` | Unified search settings |
| `~/.config/sanchala/content-search.conf` | Document content indexing |
| `~/.config/sanchala/calculator.conf` | Calculator & unit converter |

---

## 🔒 Privacy Controls

### Disable Search History
```ini
# ~/.config/krunnerrc
[History]
EnableHistory=false
```

### Clear Search History
```bash
rm ~/.local/share/krunner/history
```

### Exclude Sensitive Directories
```ini
# ~/.config/baloofilerc
[General]
exclude folders[$e]=$HOME/Private,$HOME/Secrets
```

### Disable Content Indexing
```ini
# ~/.config/baloofilerc
[ContentIndexing]
enabled=false
```

### Create .noindex Marker
```bash
# Prevent indexing of a specific folder
touch ~/SensitiveFolder/.noindex
```

---

## 🐛 Troubleshooting

### Search Not Finding Files

1. Check Baloo status:
   ```bash
   balooctl6 status
   ```

2. Verify indexing is enabled:
   ```bash
   balooctl6 config
   ```

3. Check if folder is excluded:
   ```bash
   cat ~/.config/baloofilerc
   ```

### Indexing Stuck or Slow

1. Check what is being indexed:
   ```bash
   balooctl6 monitor
   ```

2. Restart Baloo:
   ```bash
   balooctl6 stop
   balooctl6 start
   ```

3. Reset index completely:
   ```bash
   balooctl6 disable
   rm -rf ~/.local/share/baloo
   balooctl6 enable
   ```

### KRunner Not Appearing

1. Restart KRunner:
   ```bash
   kquitapp6 krunner
   kstart6 krunner
   ```

2. Check shortcut binding:
   - System Settings → Shortcuts → KRunner

### High Memory Usage

1. Limit index size in `baloofilerc`:
   ```ini
   [Database]
   maxSize=1
   ```

2. Reduce memory limit:
   ```ini
   [Performance]
   memoryLimit=128
   ```

---

## 📊 Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    UNIFIED SEARCH                        │
│                     (Meta+Space)                         │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │
│  │   KRunner   │  │   Baloo     │  │  Sanchala   │     │
│  │   (UI)      │──│  (Index)    │──│  (Config)   │     │
│  └─────────────┘  └─────────────┘  └─────────────┘     │
│         │                │                │             │
│         ▼                ▼                ▼             │
│  ┌─────────────────────────────────────────────────┐   │
│  │              SEARCH PROVIDERS                    │   │
│  ├─────────────────────────────────────────────────┤   │
│  │ Applications │ Files │ Settings │ Calculator   │   │
│  │ Documents    │ Web   │ Windows  │ Commands     │   │
│  └─────────────────────────────────────────────────┘   │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## 🎯 Performance Targets

| Metric | Target | Achieved |
|--------|--------|----------|
| App search | <50ms | ✅ |
| File name search | <100ms | ✅ |
| Content search | <500ms | ✅ |
| Calculator | <20ms | ✅ |
| Initial index | <30min | ✅ |
| Index size | <2GB | ✅ |
| Memory (idle) | <50MB | ✅ |

---

*Search System v1.0 - Sanchala OS Phase 3*
