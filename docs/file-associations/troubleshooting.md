# Troubleshooting file associations

Common issues and solutions for file association problems in Sanchala OS.

---

## File opens in wrong application

### Symptoms
- Double-clicking a file opens the wrong app
- "Open with" shows incorrect default

### Solutions

**1. Check user overrides**

```bash
cat ~/.config/mimeapps.list | grep -A5 "Default Applications"
```

Look for conflicting entries.

**2. Reset to Sanchala defaults**

```bash
cp /etc/skel/.config/mimeapps.list ~/.config/mimeapps.list
```

**3. Set correct default**

```bash
xdg-mime default org.kde.gwenview.desktop image/png
```

---

## "Open with" menu is empty

### Symptoms
- Right-click shows no applications
- "Open with other application" shows blank list

### Solutions

**1. Rebuild desktop database**

```bash
update-desktop-database ~/.local/share/applications
sudo update-desktop-database /usr/share/applications
```

**2. Check desktop files exist**

```bash
ls /usr/share/applications/*.desktop | head -20
```

**3. Verify desktop file syntax**

```bash
desktop-file-validate /usr/share/applications/brave-browser.desktop
```

---

## Custom file type not recognized

### Symptoms
- File shows as "Unknown" or generic type
- Custom extension not associated

### Solutions

**1. Update MIME database**

```bash
sudo update-mime-database /usr/share/mime
```

**2. Verify MIME XML syntax**

```bash
xmllint --noout /usr/share/mime/packages/sanchala-custom.xml
```

**3. Check glob pattern**

Ensure pattern matches your file:

```xml
<glob pattern="*.myext"/>
<glob pattern="*.MYEXT"/>  <!-- Add if case-sensitive -->
```

---

## Application doesn't appear in "Open with"

### Symptoms
- Installed app missing from context menu
- App works when launched directly

### Solutions

**1. Check MimeType in desktop file**

```bash
grep MimeType /usr/share/applications/myapp.desktop
```

Must include the MIME type:

```ini
MimeType=image/png;image/jpeg;
```

**2. Add to associations**

Edit `~/.config/mimeapps.list`:

```ini
[Added Associations]
image/png=myapp.desktop;org.kde.gwenview.desktop
```

**3. Rebuild caches**

```bash
update-desktop-database
kbuildsycoca5 --noincremental
```

---

## URL scheme not working

### Symptoms
- Clicking `mailto:` links does nothing
- Custom `myapp://` URLs fail

### Solutions

**1. Check scheme handler**

```bash
xdg-mime query default x-scheme-handler/mailto
```

**2. Set handler**

```bash
xdg-mime default org.kde.kmail2.desktop x-scheme-handler/mailto
```

**3. Verify in mimeapps.list**

```ini
[Default Applications]
x-scheme-handler/mailto=org.kde.kmail2.desktop
```

---

## File type detected incorrectly

### Symptoms
- `.txt` file opens as binary
- Wrong MIME type reported

### Solutions

**1. Check detected type**

```bash
xdg-mime query filetype myfile.txt
file --mime-type myfile.txt
```

**2. Force extension-based detection**

Create higher-priority glob in custom MIME:

```xml
<mime-type type="text/plain">
  <glob pattern="*.txt" weight="60"/>
</mime-type>
```

**3. Clear MIME cache**

```bash
rm -rf ~/.local/share/mime
update-mime-database ~/.local/share/mime
```

---

## Diagnostic commands

### Full system check

```bash
#!/bin/bash
echo "=== MIME System Diagnostic ==="

echo -e "\n[User mimeapps.list]"
head -20 ~/.config/mimeapps.list 2>/dev/null || echo "Not found"

echo -e "\n[MIME database status]"
ls -la /usr/share/mime/mime.cache

echo -e "\n[Desktop database status]"
ls -la /usr/share/applications/mimeinfo.cache

echo -e "\n[Sanchala MIME types]"
ls /usr/share/mime/packages/sanchala-*.xml 2>/dev/null || echo "Not installed"

echo -e "\n[Sample associations]"
for type in image/png application/pdf text/plain; do
    echo "$type -> $(xdg-mime query default $type)"
done
```

### Test specific file

```bash
FILE="test.png"
echo "File: $FILE"
echo "MIME type: $(xdg-mime query filetype "$FILE")"
echo "Default app: $(xdg-mime query default $(xdg-mime query filetype "$FILE"))"
```

---

## Getting help

If issues persist:

1. Check Sanchala OS documentation
2. Search Arch Wiki for MIME-related articles
3. Report bugs at the Sanchala OS issue tracker
