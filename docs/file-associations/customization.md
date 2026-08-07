# File association customization

This guide covers advanced customization of file associations in Sanchala OS.

---

## Understanding mimeapps.list

The `mimeapps.list` file has three sections:

```ini
[Default Applications]
# Primary application for each MIME type
image/png=org.kde.gwenview.desktop

[Added Associations]
# Additional applications shown in "Open With"
image/png=gimp.desktop;org.kde.gwenview.desktop

[Removed Associations]
# Applications to hide from "Open With"
image/png=eog.desktop
```

### Precedence

1. `~/.config/mimeapps.list` (user)
2. `~/.local/share/applications/mimeapps.list` (user legacy)
3. `/etc/xdg/mimeapps.list` (system)
4. `/usr/share/applications/mimeapps.list` (distribution)

User settings always override system defaults.

---

## Creating custom MIME types

### 1. Create MIME definition

Create `/usr/share/mime/packages/myapp.xml`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
  <mime-type type="application/x-myapp">
    <comment>MyApp Document</comment>
    <glob pattern="*.myapp"/>
    <magic priority="50">
      <match type="string" value="MYAPP" offset="0"/>
    </magic>
  </mime-type>
</mime-info>
```

### 2. Create desktop entry

Create `/usr/share/applications/myapp.desktop`:

```ini
[Desktop Entry]
Name=MyApp
Exec=/usr/bin/myapp %f
Type=Application
MimeType=application/x-myapp;
```

### 3. Update databases

```bash
sudo update-mime-database /usr/share/mime
sudo update-desktop-database /usr/share/applications
```

---

## MIME type detection

### By extension (glob)

Most reliable method:

```xml
<glob pattern="*.png"/>
<glob pattern="*.PNG"/>  <!-- Case variations -->
```

### By magic bytes

Detects files by content:

```xml
<magic priority="50">
  <match type="string" value="\x89PNG" offset="0"/>
</magic>
```

### Priority

Higher priority wins when multiple types match:
- 50: Normal priority
- 60: High priority (override defaults)
- 40: Low priority (fallback)

---

## Scheme handlers

Handle custom URL schemes like `myapp://`:

### 1. Create desktop entry

```ini
[Desktop Entry]
Name=MyApp Handler
Exec=/usr/bin/myapp %u
Type=Application
MimeType=x-scheme-handler/myapp;
```

### 2. Set as default

```bash
xdg-mime default myapp.desktop x-scheme-handler/myapp
```

Or add to `mimeapps.list`:

```ini
[Default Applications]
x-scheme-handler/myapp=myapp.desktop
```

---

## Bulk changes

### Set multiple associations

```bash
#!/bin/bash
# Set GIMP as default for all image types
for type in jpeg png gif webp tiff bmp; do
    xdg-mime default gimp.desktop "image/$type"
done
```

### Reset to defaults

```bash
# Remove user overrides
rm ~/.config/mimeapps.list
rm ~/.local/share/applications/mimeapps.list

# Reinstall Sanchala defaults
cp /etc/skel/.config/mimeapps.list ~/.config/
```

---

## Application categories

Group applications in "Open With" by category:

| Category | MIME patterns |
|----------|---------------|
| Graphics | `image/*` |
| Documents | `application/pdf`, `application/epub*` |
| Office | `application/vnd.oasis.opendocument.*` |
| Video | `video/*` |
| Audio | `audio/*` |
| Archives | `application/zip`, `application/x-*-compressed*` |
| Code | `text/x-*`, `application/json` |

---

## Debugging

### Check current association

```bash
xdg-mime query default image/png
# Output: org.kde.gwenview.desktop
```

### Find MIME type of file

```bash
xdg-mime query filetype photo.png
# Output: image/png

# Or with more detail
file --mime-type photo.png
```

### Verbose database update

```bash
update-mime-database -V /usr/share/mime
```

### Check desktop entry

```bash
desktop-file-validate /usr/share/applications/myapp.desktop
```

---

## Common issues

### Association not working

1. Check file exists: `ls -la ~/.config/mimeapps.list`
2. Verify syntax: no spaces around `=`
3. Desktop file must exist in applications directory
4. Run `update-desktop-database`

### Wrong application opens

1. Check user overrides: `~/.config/mimeapps.list`
2. Look for conflicting entries in `[Added Associations]`
3. Check desktop file `MimeType=` includes the MIME type

### Custom type not detected

1. Verify XML syntax in MIME definition
2. Run `update-mime-database /usr/share/mime`
3. Check glob pattern matches filename

---

## See also

- [freedesktop.org MIME spec](https://specifications.freedesktop.org/mime-apps-spec/latest/)
- [Desktop Entry spec](https://specifications.freedesktop.org/desktop-entry-spec/latest/)
