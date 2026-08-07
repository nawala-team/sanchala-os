# 🔄 CalDAV/CardDAV Setup Guide

## Overview

CalDAV and CardDAV are open standards for calendar and contact synchronization. SANCHALA OS provides first-class support through the Akonadi framework, enabling seamless sync comparable to Apple iCloud.

---

## 🚀 Quick Start

### Method 1: System Settings (Recommended)

1. Open **System Settings** → **Online Accounts**
2. Click **Add Account**
3. Select your provider (Nextcloud, Google, etc.)
4. Enter credentials
5. Select what to sync (Calendar, Contacts, Email)
6. Click **Apply**

### Method 2: Kontact Setup Wizard

1. Open **Kontact**
2. Go to **Settings** → **Configure Kontact**
3. Select **Accounts**
4. Click **Add** → **CalDAV/CardDAV**
5. Enter server details
6. Test connection and save

---

## 📋 Provider-Specific Setup

### Nextcloud

```
Server URL: https://your-nextcloud.com
CalDAV:     https://your-nextcloud.com/remote.php/dav/calendars/USERNAME/
CardDAV:    https://your-nextcloud.com/remote.php/dav/addressbooks/users/USERNAME/
```

**Steps:**
1. In Online Accounts, select **Nextcloud**
2. Enter your Nextcloud server URL
3. Enter username and password
4. Enable Calendar and Contacts sync
5. Done! Auto-discovery handles the rest

### Google Calendar & Contacts

**Requirements:** OAuth2 authentication (no app password needed)

**Steps:**
1. In Online Accounts, select **Google**
2. Click **Sign in with Google**
3. Authorize SANCHALA OS access
4. Select services: Calendar, Contacts, (optionally) Gmail
5. Done!

### Apple iCloud

**Requirements:** App-Specific Password

**Generate App Password:**
1. Go to [appleid.apple.com](https://appleid.apple.com)
2. Sign in → Security → App-Specific Passwords
3. Generate new password for "SANCHALA"
4. Copy the password (shown once)

**Setup:**
```
CalDAV URL:  https://caldav.icloud.com/
CardDAV URL: https://contacts.icloud.com/
Username:    your-apple-id@icloud.com
Password:    xxxx-xxxx-xxxx-xxxx (app password)
```



---

## 🔧 Advanced Configuration

### Self-Hosted Servers

**Radicale:**
```
CalDAV:  https://your-server.com/radicale/USERNAME/calendar.ics/
CardDAV: https://your-server.com/radicale/USERNAME/contacts.vcf/
```

**Baïkal:**
```
CalDAV:  https://your-server.com/baikal/dav.php/calendars/USERNAME/default/
CardDAV: https://your-server.com/baikal/dav.php/addressbooks/USERNAME/default/
```

---

## ⚙️ Sync Settings

Edit `~/.config/sanchala/pim-sync.conf`:

```ini
[General]
GlobalSyncInterval=15       # Minutes between syncs
SyncOnNetworkChange=true    # Sync when network changes
BackgroundSync=true         # Sync even when apps closed

[CalDAV]
PastEventRetention=365      # Days of past events to keep
FutureEventRange=730        # Days ahead to sync

[CardDAV]
SyncPhotos=true             # Sync contact photos
PhotoQuality=85             # JPEG quality for uploads
```

---

## 🐛 Troubleshooting

### Connection Failed
1. Check URL format - Include full CalDAV/CardDAV path
2. Verify credentials via web interface
3. Test with: `curl -u "user:pass" -X PROPFIND "https://server/caldav/"`

### Sync Not Working
```bash
akonadictl status          # Check status
akonadictl restart         # Restart service
journalctl --user -u akonadi -f  # View logs
```

### Duplicate Events/Contacts
1. Check for multiple resources syncing same account
2. Use **KAddressBook** → **Tools** → **Merge Contacts**

---

## 🔗 Related Documentation

- [PIM Suite Overview](README.md)
- [Contact Sync Specification](CONTACT-SYNC.md)
- [Email Configuration](EMAIL-SETUP.md)

