# File Associations

Sanchala OS uses the freedesktop.org MIME system for file type detection and application associations. This provides sensible defaults with easy customization.

---

## Quick reference

| File Type | Default Application | Alternative |
|-----------|-------------------|-------------|
| Web pages | Brave Browser | Firefox |
| Images | Gwenview | GIMP |
| Documents | Okular | Brave (PDF) |
| Office | LibreOffice | Calligra |
| Video | VLC | Haruna |
| Audio | VLC | Elisa |
| Archives | Ark | Dolphin |
| Text/Code | Kate | KWrite |

---

## How it works

Sanchala OS uses three layers for file associations:

1. **MIME database** - Detects file types from extensions and content
2. **mimeapps.list** - Maps MIME types to applications
3. **Desktop entries** - Define application capabilities

When you open a file:
1. The system identifies the MIME type (e.g., `image/png`)
2. Looks up the default application in `mimeapps.list`
3. Launches the application with the file

---

## Changing defaults

### Using System Settings

1. Open **System Settings**
2. Navigate to **Applications** → **Default Applications**
3. Select the category (Web Browser, File Manager, etc.)
4. Choose your preferred application

### Using Dolphin

1. Right-click a file
2. Select **Properties**
3. Click the wrench icon next to "Type"
4. Choose default application

### Manual configuration

Edit `~/.config/mimeapps.list`:

```ini
[Default Applications]
image/png=gimp.desktop
application/pdf=brave-browser.desktop
```

---

## File locations

| Purpose | Location |
|---------|----------|
| System defaults | `/etc/skel/.config/mimeapps.list` |
| User overrides | `~/.config/mimeapps.list` |
| MIME definitions | `/usr/share/mime/packages/` |
| Desktop entries | `/usr/share/applications/` |
| Sanchala types | `/usr/share/mime/packages/sanchala-custom.xml` |

---

## Sanchala custom types

Sanchala OS defines custom MIME types for its applications:

| Extension | MIME Type | Application |
|-----------|-----------|-------------|
| `.sanchala` | `application/x-sanchala-config` | Kate |
| `.santheme` | `application/x-sanchala-theme` | Theme Installer |
| `.sanbackup` | `application/x-sanchala-backup` | Backup Manager |
| `.sanext` | `application/x-sanchala-extension` | Extension Installer |
| `.sanpolicy` | `application/x-sanchala-policy` | Guardian |

---

## See also

- [Customization guide](customization.md)
- [Troubleshooting](troubleshooting.md)
- [MIME type reference](mime-reference.md)
