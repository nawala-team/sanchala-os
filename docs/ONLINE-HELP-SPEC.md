# Sanchala OS Online Help Integration Specification

**Version:** 1.0  
**Status:** Draft

---

## 1. Architecture Overview

```
┌─────────────────────────────────────────────────────────┐
│                  HELP SYSTEM                             │
├─────────────────────────────────────────────────────────┤
│  Triggers:  F1 Key  |  ? Buttons  |  --help flag        │
│                      ▼                                   │
│              ┌──────────────┐                            │
│              │ sanchala-help│ (D-Bus service)            │
│              └──────┬───────┘                            │
│       ┌─────────────┼─────────────┐                      │
│       ▼             ▼             ▼                      │
│  Local Docs    Man Pages    Online Docs                  │
│  /usr/share/   /usr/share/  docs.sanchala.id            │
│  doc/sanchala  man/                                      │
└─────────────────────────────────────────────────────────┘
```

---

## 2. Help Triggers

| Trigger | Context | Action |
|---------|---------|--------|
| `F1` | Any app | Context-sensitive help |
| `Shift+F1` | Any app | "What's This?" mode |
| `Ctrl+F1` | Global | Open help center |
| `--help` | CLI | Show command help |
| `?` button | GUI dialogs | Topic help |

---

## 3. D-Bus Interface

**Service:** `org.sanchala.Help`

```xml
<interface name="org.sanchala.Help">
  <method name="ShowHelp">
    <arg name="context" type="s" direction="in"/>
    <arg name="topic" type="s" direction="in"/>
  </method>
  <method name="Search">
    <arg name="query" type="s" direction="in"/>
    <arg name="results" type="a(sss)" direction="out"/>
  </method>
</interface>
```

---

## 4. Content Sources

### Local Documentation
- Location: `/usr/share/doc/sanchala/`
- Format: HTML (converted from Markdown)
- Search index: `search-index.json`

### Man Pages
- Section 1: User commands
- Section 5: Config files  
- Section 8: Admin commands

### Online Fallback
- URL: `https://docs.sanchala.id/`
- Version-matched content
- Offline detection with graceful fallback

---

## 5. Context Mapping

| Application | Context ID | Help Topic |
|-------------|------------|------------|
| System Settings | `settings.*` | Relevant settings topic |
| Sanchala Guardian | `guardian.*` | Security help |
| Sanchala Store | `store.*` | App management |
| File Manager | `dolphin.*` | File operations |

---

## 6. Help Viewer Features

**Application:** `sanchala-help`

- Table of contents navigation
- Full-text search
- Bookmarks and history
- Print support
- Offline mode indicator
- Localization support (fallback: en)

---

## 7. CLI Integration

```bash
# Open help viewer
sanchala-help

# Show specific topic
sanchala-help --topic user-guide/installation

# Search
sanchala-help --search "firewall"

# Context-sensitive
sanchala-help --context guardian.scan
```

---

## 8. Files

| Path | Description |
|------|-------------|
| `/usr/share/doc/sanchala/` | Local docs |
| `/usr/share/man/` | Man pages |
| `/usr/share/sanchala/help/` | Help data |
| `~/.config/sanchala/help.conf` | User prefs |

---

**Last Updated:** August 2026
