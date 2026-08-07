# 📧 Email Client Configuration

## Overview

SANCHALA OS uses KMail as the default email client, integrated with Kontact for unified PIM experience. Privacy-focused defaults protect against tracking and phishing.

---

## 🔐 Privacy Defaults

| Setting | Default | Reason |
|---------|---------|--------|
| HTML Rendering | Restricted | Prevents tracking |
| Remote Content | Blocked | Stops tracking pixels |
| Read Receipts | Ask | Privacy protection |
| Default Format | Plain Text | Compatibility |

---

## 📬 Account Setup

### IMAP/SMTP (Most Providers)

1. Open **Kontact** → **Mail** → **Settings**
2. Click **Add Account** → **IMAP**
3. Enter email and password
4. Auto-configure detects settings
5. Verify outgoing (SMTP) settings

### Common Provider Settings

**Gmail:**
```
IMAP: imap.gmail.com:993 (SSL)
SMTP: smtp.gmail.com:587 (STARTTLS)
Auth: OAuth2
```

**Outlook/Microsoft 365:**
```
IMAP: outlook.office365.com:993 (SSL)
SMTP: smtp.office365.com:587 (STARTTLS)
Auth: OAuth2
```

**Fastmail:**
```
IMAP: imap.fastmail.com:993 (SSL)
SMTP: smtp.fastmail.com:587 (STARTTLS)
Auth: Password
```

---

## ⚙️ Configuration

Location: `~/.config/kmail2/kmail2rc`

### Key Settings

```ini
[Reader]
HtmlRendering=sameServer    # Restrict HTML to same server
LoadExternalReferences=false # Block tracking pixels

[Composer]
DefaultTextFormat=plain     # Plain text default
AutoSaveInterval=60         # Auto-save drafts

[Security]
EnableCrypto=true           # GPG/S-MIME support
WarnUnencryptedReply=true   # Warn on security downgrade

[Antiphishing]
ExternalSenderWarning=true  # Highlight external senders
SuspiciousLinkWarning=true  # Warn on suspicious links
```

---

## 🔒 Security Features

### GPG Integration
- Automatic key lookup
- Sign/encrypt by default (configurable)
- Key management via Kleopatra

### Anti-Phishing
- External sender warnings
- Suspicious link detection
- Domain verification

---

## 🔔 Notifications

- Desktop notifications for new mail
- Sound alerts (configurable)
- Unread count in system tray

---

## 🔗 Related Documentation

- [PIM Suite Overview](README.md)
- [CalDAV/CardDAV Setup](CALDAV-CARDDAV-SETUP.md)
