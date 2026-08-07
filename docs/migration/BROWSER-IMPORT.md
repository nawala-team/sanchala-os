# Browser Data Import Guide

Complete guide for importing bookmarks, passwords, history, and extensions from your previous browser.

## Overview

Sanchala OS supports importing data from all major browsers. This guide covers Chrome, Firefox, Safari, Edge, and Brave.

## Quick Import Methods

### Method 1: Browser Sync (Easiest)

Sign into your browser account on Sanchala OS:

- **Chrome/Brave**: Sign in with Google account
- **Firefox**: Sign in with Firefox account
- **Edge**: Sign in with Microsoft account

### Method 2: sanchala-migrate Tool

```bash
# Import all browser data
sanchala-migrate browser --all

# Import specific browser
sanchala-migrate browser --chrome
sanchala-migrate browser --firefox
sanchala-migrate browser --safari
```

### Method 3: Manual Import

Export from source browser, import to target browser.

---

## Chrome / Chromium

### Bookmarks

**Automatic Export:**
```bash
sanchala-migrate browser --chrome
# Creates ~/chrome-bookmarks.html
```

**Manual Export (on source system):**
1. Chrome → Bookmarks → Bookmark Manager (Ctrl+Shift+O)
2. Click ⋮ → Export bookmarks
3. Save HTML file

**Import to Firefox:**
1. Bookmarks → Manage Bookmarks (Ctrl+Shift+O)
2. Import and Backup → Import from HTML
3. Select exported file

**Import to Chrome on Sanchala OS:**
1. chrome://bookmarks
2. Click ⋮ → Import bookmarks

### Passwords

**Export (on source system):**
1. chrome://settings/passwords
2. Click ⋮ next to "Saved Passwords"
3. Export passwords → Save CSV

**Import to Firefox:**
1. about:logins
2. Click ⋮ → Import from File
3. Select CSV file

**Import to KeePassXC (Recommended):**
1. Database → Import → CSV
2. Map columns appropriately

### History

```bash
# Export history
sanchala-migrate browser --chrome --history
# Creates ~/chrome-history.txt
```

### Extensions

Chrome extensions work in Chromium-based browsers on Linux. To reinstall:
1. Visit chrome://extensions on source
2. Note extension names
3. Install from Chrome Web Store on Sanchala OS

---

## Firefox

### Bookmarks

**Automatic Export:**
```bash
sanchala-migrate browser --firefox
# Creates ~/firefox-bookmarks.html
```

**Manual Export:**
1. Bookmarks → Manage Bookmarks (Ctrl+Shift+O)
2. Import and Backup → Export Bookmarks to HTML

**Import:**
Same browser: Use Firefox Sync
Other browser: Import HTML file

### Passwords

**Export:**
1. about:logins
2. Click ⋮ → Export Logins
3. Save CSV file

**Import to new Firefox:**
Use Firefox Sync, or import CSV via about:logins

### Full Profile Copy

Copy entire Firefox profile for complete migration:

```bash
# Find profile on source
ls /path/to/source/.mozilla/firefox/

# Copy to Sanchala OS
cp -r /source/*.default-release ~/.mozilla/firefox/

# Update profiles.ini
nano ~/.mozilla/firefox/profiles.ini
```

---

## Safari (macOS source only)

### Bookmarks

**Export on macOS:**
1. Safari → File → Export Bookmarks
2. Save as HTML file
3. Transfer to Sanchala OS

**Using sanchala-migrate:**
```bash
sanchala-migrate --source /mnt/macos browser --safari
```

Note: Safari bookmarks are in plist format. Install `plistutil` for conversion:
```bash
sudo pacman -S libplist
plistutil -i Bookmarks.plist -o bookmarks.xml
```

### Passwords

Safari passwords are stored in macOS Keychain:

1. On macOS: System Settings → Passwords
2. Select all → Export (requires macOS 12+)
3. Import CSV to KeePassXC or Firefox

### Reading List

Export manually or use third-party tools. Reading List is stored in `~/Library/Safari/Bookmarks.plist`.

---

## Microsoft Edge

Edge uses Chromium format (same as Chrome).

### Bookmarks

**Export:**
1. Edge → Favorites (Ctrl+Shift+O)
2. Click ⋮ → Export favorites

**Import:**
Same as Chrome bookmarks import.

### Passwords

**Export:**
1. edge://settings/passwords
2. Click ⋮ → Export passwords

**Import:**
Same as Chrome passwords import.

---

## Brave

Brave is Chromium-based, uses same format as Chrome.

### Bookmarks

```bash
sanchala-migrate browser --brave
```

Or export manually via Bookmark Manager.

### Passwords

Export from brave://settings/passwords, import to target browser.

---

## Supported Data Types

| Data | Chrome | Firefox | Safari | Edge | Brave |
|------|--------|---------|--------|------|-------|
| Bookmarks | ✓ | ✓ | ✓ | ✓ | ✓ |
| Passwords | ✓ | ✓ | ✓* | ✓ | ✓ |
| History | ✓ | ✓ | ✓ | ✓ | ✓ |
| Extensions | ✓ | ✓ | ✗ | ✓ | ✓ |
| Cookies | ✗ | ✗ | ✗ | ✗ | ✗ |

✓ = Supported  ✓* = Requires macOS export  ✗ = Not supported

## Password Manager Recommendations

For better security, consider migrating to a dedicated password manager:

| Manager | Type | Notes |
|---------|------|-------|
| KeePassXC | Local | Open source, offline |
| Bitwarden | Cloud | Open source, self-hostable |
| 1Password | Cloud | Paid, polished |

### Import to KeePassXC

1. Export passwords as CSV from browser
2. KeePassXC → Database → Import → CSV
3. Map columns: URL, Username, Password
4. Delete CSV file securely after import

## Troubleshooting

### "Bookmarks file not found"

Check browser profile location:
```bash
# Chrome
ls ~/.config/google-chrome/Default/Bookmarks

# Firefox
ls ~/.mozilla/firefox/*.default*/places.sqlite

# Brave
ls ~/.config/BraveSoftware/Brave-Browser/Default/Bookmarks
```

### "Password import failed"

- Ensure CSV format matches expected columns
- Check for special characters in passwords
- Try importing smaller batches

### "Extensions not working"

- Some extensions are Windows/macOS only
- Check for Linux alternatives
- Firefox extensions differ from Chrome

## Security Notes

- Delete exported password CSV files after import
- Use `shred` for secure deletion: `shred -u passwords.csv`
- Consider enabling 2FA on browser accounts
- Review imported passwords for weak/reused ones

---

**Next:** [Document Migration](DOCUMENT-MIGRATION.md) | [App Mapping](APP-MAPPING.md)
