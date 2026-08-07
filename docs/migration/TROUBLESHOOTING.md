# Migration Troubleshooting

Solutions for common migration issues.

## Partition Mounting

### "NTFS partition not mounting"

```bash
# Install NTFS support
sudo pacman -S ntfs-3g

# Try ntfs-3g driver
sudo mount -t ntfs-3g /dev/sdXY /mnt/windows

# Or use kernel ntfs3 driver
sudo mount -t ntfs3 /dev/sdXY /mnt/windows
```

### "Windows is hibernated" / "Metadata kept in Windows cache"

Windows Fast Startup locks the partition.

**Solution on Windows:**
1. Control Panel → Power Options
2. Choose what power buttons do → Change unavailable settings
3. Uncheck "Turn on fast startup"
4. Shut down (not restart)

**Force read-only mount:**
```bash
sudo mount -t ntfs3 -o ro /dev/sdXY /mnt/windows
```

### "APFS partition won't mount"

```bash
# Install APFS support
yay -S apfs-fuse

# List volumes
sudo apfs-fuse --list /dev/sdX

# Mount specific volume
sudo apfs-fuse -o allow_other -v 1 /dev/sdXY /mnt/macos
```

### "HFS+ partition is journaled"

```bash
# Mount read-only
sudo mount -t hfsplus -o ro,force /dev/sdXY /mnt/macos
```

### "Permission denied on files"

```bash
# Mount with user permissions
sudo mount -o uid=$(id -u),gid=$(id -g) /dev/sdXY /mnt/source
```

## File Transfer Issues

### "File name too long"

Linux filename limit is 255 characters.

```bash
# Find problematic files
find /mnt/source -name '*' | awk 'length > 255'
```

Rename files on source system or during copy.

### "Invalid characters in filename"

Windows allows `< > : " | ? *` which Linux doesn't.

```bash
# Find files with problematic characters
find /mnt/source -name '*[:<>|?*]*' 2>/dev/null
```

### "Not enough disk space"

```bash
# Check available space
df -h ~

# Check source size
du -sh /mnt/source/Users/*/Documents/
```

Solutions:
- Free up space on Sanchala OS
- Migrate selectively
- Use external drive as intermediate

### "Transfer interrupted"

```bash
# Resume with rsync
rsync -av --progress --partial /source/ /dest/

# Or use sanchala-migrate resume
sanchala-migrate --resume
```

## Browser Data Issues

### "Bookmarks file not found"

Check profile locations:

```bash
# Chrome
find /mnt/source -name "Bookmarks" -path "*Chrome*" 2>/dev/null

# Firefox
find /mnt/source -name "places.sqlite" 2>/dev/null
```

### "Password import failed"

- Check CSV format matches expected columns
- Remove special characters or quotes in passwords
- Try importing smaller batches

### "Firefox profile won't load"

```bash
# Check profile permissions
chmod -R u+rw ~/.mozilla/firefox/

# Create fresh profile, import bookmarks only
firefox -P  # Profile manager
```

## Performance Issues

### "Migration is very slow"

For USB 2.0 or network drives:
```bash
# Use compression
rsync -avz --progress /source/ /dest/
```

For large files:
```bash
# Disable checksums for speed
rsync -av --progress --no-checksum /source/ /dest/
```

### "System unresponsive during migration"

Limit bandwidth:
```bash
rsync -av --progress --bwlimit=50000 /source/ /dest/  # 50 MB/s limit
```

Or use ionice:
```bash
ionice -c 3 rsync -av /source/ /dest/
```

## Post-Migration Issues

### "Can't find my files"

Default locations:
- Documents: `~/Documents`
- Pictures: `~/Pictures`
- Downloads: `~/Downloads`
- Migrated (other): `~/Migrated/`

Search:
```bash
find ~ -name "filename*" 2>/dev/null
```

### "Application says file format unsupported"

Install additional codecs:
```bash
sudo pacman -S ffmpeg gst-plugins-good gst-plugins-bad gst-plugins-ugly
```

### "Fonts look different"

Install Microsoft fonts (if legally obtained):
```bash
yay -S ttf-ms-win11-auto
```

Or use alternatives:
- Calibri → Carlito
- Cambria → Caladea
- Arial → Liberation Sans

## Getting More Help

1. Check migration log: `~/.local/share/sanchala-migrate/migrate.log`
2. Run with verbose: `sanchala-migrate -v --source /mnt/source migrate`
3. Visit [forum.sanchala.id](https://forum.sanchala.id)

---

**Back to:** [Migration Guide](README.md)
