# 📅 SANCHALA OS - PIM Suite Documentation

## Overview

The SANCHALA OS Personal Information Management (PIM) suite provides seamless calendar, contacts, and email integration comparable to the Apple ecosystem. Built on KDE PIM (Kontact) with custom enhancements for a unified, privacy-respecting experience.

---

## 🎯 Design Goals

1. **Seamless Sync** - Apple iCloud-like sync across devices
2. **Privacy First** - Local-first with optional cloud sync
3. **Unified Experience** - Single interface for calendar, contacts, email
4. **Standards Compliant** - CalDAV/CardDAV/IMAP for interoperability
5. **Offline Capable** - Full functionality without network

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                    SANCHALA PIM ARCHITECTURE                        │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                    USER INTERFACE LAYER                      │   │
│  ├─────────────────────────────────────────────────────────────┤   │
│  │  Kontact    │  KOrganizer  │ KAddressBook │  KMail          │   │
│  │  (Hub)      │  (Calendar)  │ (Contacts)   │  (Email)        │   │
│  └──────┬──────┴──────┬───────┴──────┬───────┴──────┬──────────┘   │
│         │             │              │              │               │
│  ┌──────┴─────────────┴──────────────┴──────────────┴──────────┐   │
│  │                    PLASMA INTEGRATION                        │   │
│  │  • Calendar Widget    • Contact Search    • Mail Notifier   │   │
│  └──────────────────────────┬──────────────────────────────────┘   │
│                             │                                       │
│  ┌──────────────────────────┴──────────────────────────────────┐   │
│  │                    AKONADI (Data Layer)                      │   │
│  │  • SQLite Storage     • Full-text Search   • Change Notify  │   │
│  └──────────────────────────┬──────────────────────────────────┘   │
│                             │                                       │
│  ┌──────────────────────────┴──────────────────────────────────┐   │
│  │                    SYNC RESOURCES                            │   │
│  ├──────────┬──────────┬──────────┬──────────┬─────────────────┤   │
│  │  CalDAV  │ CardDAV  │   IMAP   │   EWS    │   KDE Connect   │   │
│  └──────────┴──────────┴──────────┴──────────┴─────────────────┘   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 📦 Components

### Core Applications

| Application | Purpose | Config Location |
|-------------|---------|-----------------|
| **Kontact** | Unified PIM hub | `~/.config/kontact/` |
| **KOrganizer** | Calendar & tasks | `~/.config/korganizer/` |
| **KAddressBook** | Contact management | `~/.config/kaddressbook/` |
| **KMail** | Email client | `~/.config/kmail2/` |
| **Akonadi** | Data backend | `~/.config/akonadi/` |



---

## 🔧 Default Configuration

### First Run Behavior

1. **Akonadi starts** on first PIM app launch
2. **Local storage** created automatically
3. **Setup wizard** prompts for account configuration
4. **Plasma widget** shows local calendar immediately

### Privacy Defaults

- ✅ Local storage only (no cloud sync required)
- ✅ HTML email rendering restricted
- ✅ Remote content blocked by default
- ✅ Credentials stored in KWallet
- ✅ TLS 1.2+ required for all connections

---

## 📁 File Locations

```
~/.config/
├── akonadi/
│   ├── akonadirc              # Client configuration
│   └── akonadiserverrc        # Server configuration
├── kontact/
│   └── kontactrc              # Kontact hub settings
├── korganizer/
│   └── korganizerrc           # Calendar settings
├── kaddressbook/
│   └── kaddressbookrc         # Address book settings
├── kmail2/
│   └── kmail2rc               # Email settings
└── sanchala/
    ├── pim-sync.conf          # Sync configuration
    ├── contact-sync.conf      # Contact sync rules
    └── calendar-widget.conf   # Widget integration

~/.local/share/
├── akonadi/                   # Akonadi data storage
├── korganizer/                # Calendar data
├── kaddressbook/              # Contact data
└── kmail/                     # Email storage
```

---

## 🔐 Security Features

### Credential Storage
All passwords and tokens stored in KWallet (encrypted with user's login password).

### Network Security
- TLS 1.2+ mandatory for all sync
- Certificate validation enforced
- OAuth2 for Google/Microsoft
- App-specific passwords for iCloud

---

## 📊 Supported Providers

| Provider | CalDAV | CardDAV | Email | Notes |
|----------|--------|---------|-------|-------|
| **Nextcloud** | ✅ | ✅ | ✅ | Full support, recommended |
| **Google** | ✅ | ✅ | ✅ | OAuth2 required |
| **Apple iCloud** | ✅ | ✅ | ✅ | App-specific password |
| **Fastmail** | ✅ | ✅ | ✅ | Full CalDAV/CardDAV |
| **mailbox.org** | ✅ | ✅ | ✅ | Privacy-focused |
| **Self-hosted** | ✅ | ✅ | ✅ | Manual configuration |

---

## 🔗 Related Documentation

- [CalDAV/CardDAV Setup](CALDAV-CARDDAV-SETUP.md)
- [Contact Sync Specification](CONTACT-SYNC.md)
- [Email Configuration](EMAIL-SETUP.md)
- [Calendar Widget Integration](CALENDAR-WIDGET.md)

