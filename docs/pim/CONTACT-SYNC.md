# 👥 Contact Sync Specification

## Overview

SANCHALA OS provides unified contact synchronization across local storage, cloud services, and connected devices (via KDE Connect). This enables an Apple-like experience where contacts are always up-to-date everywhere.

---

## 🔄 Sync Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    CONTACT SYNC FLOW                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   ┌──────────┐    ┌──────────┐    ┌──────────┐                 │
│   │  Phone   │    │  Cloud   │    │  LDAP    │                 │
│   │(KDE Con.)│    │ CardDAV  │    │(Enterprise)│               │
│   └────┬─────┘    └────┬─────┘    └────┬─────┘                 │
│        │               │               │                        │
│        └───────────────┼───────────────┘                        │
│                        ▼                                        │
│              ┌─────────────────┐                                │
│              │  Akonadi Merge  │                                │
│              │     Engine      │                                │
│              └────────┬────────┘                                │
│                       ▼                                         │
│              ┌─────────────────┐                                │
│              │  Local Storage  │                                │
│              │   (SQLite)      │                                │
│              └────────┬────────┘                                │
│                       ▼                                         │
│   ┌──────────────────────────────────────────────┐             │
│   │              Applications                     │             │
│   │  KAddressBook │ Kontact │ KMail │ KRunner    │             │
│   └──────────────────────────────────────────────┘             │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📋 Sync Sources

| Source | Direction | Protocol | Use Case |
|--------|-----------|----------|----------|
| **Local** | N/A | SQLite | Primary storage |
| **CardDAV** | Bidirectional | CardDAV/vCard | Cloud sync |
| **KDE Connect** | Bidirectional | Custom | Phone contacts |
| **LDAP** | Read-only | LDAP | Enterprise directory |
| **Import** | One-way | vCard/CSV | Migration |

---

## ⚙️ Configuration

### Contact Sync Settings

Location: `~/.config/sanchala/contact-sync.conf`

```ini
[General]
Enabled=true
PrimarySource=local
MergeFromMultipleSources=true

[Sync]
SyncInterval=15
BidirectionalSync=true
ConflictPreference=ask

[Fields]
SyncPhoto=true
SyncBirthday=true
SyncNotes=true
```

---

## 🔀 Merge & Deduplication

### Duplicate Detection
- Matches by: email, phone number, full name
- Confidence threshold: 70% for review, 95% for auto-merge
- Preserves all data during merge (union of fields)

### Conflict Resolution
| Strategy | Description |
|----------|-------------|
| `ask` | Prompt user (default) |
| `local` | Local changes win |
| `remote` | Server changes win |
| `newest` | Most recent edit wins |

---

## 📱 KDE Connect Integration

Sync phone contacts wirelessly:

1. Pair phone with KDE Connect
2. Enable "Contacts" plugin on phone
3. Contacts sync automatically
4. Changes sync bidirectionally

---

## 🔗 Related Documentation

- [PIM Suite Overview](README.md)
- [CalDAV/CardDAV Setup](CALDAV-CARDDAV-SETUP.md)
