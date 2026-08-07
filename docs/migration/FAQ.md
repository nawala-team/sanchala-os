# Migration FAQ

Frequently asked questions about migrating to Sanchala OS.

## General

### How long does migration take?

Depends on data size:
- Documents only: 5-30 minutes
- Full migration: 30 minutes - 2 hours
- Large media libraries: Several hours

### Can I migrate while keeping my old OS?

Yes! Migration copies data, it doesn't modify the source. Your old OS remains untouched.

### Do I need both systems running?

No. You only need the source partition mounted and readable from Sanchala OS.

### What if migration fails halfway?

Use `sanchala-migrate status` to check progress. Resume with `sanchala-migrate --resume`.

## Data Questions

### Will my Office documents work?

Yes. LibreOffice has excellent compatibility with Microsoft Office formats (.docx, .xlsx, .pptx).

### Can I import my browser passwords?

Yes, but requires manual export from source browser. See [Browser Import Guide](BROWSER-IMPORT.md).

### What about my email?

Thunderbird can import from Outlook (via export) and directly from other Thunderbird profiles.

### Are my photos and videos compatible?

Almost all formats work. HEIC (iPhone photos) requires `heif-pixbuf-loader` package.

## Technical

### How do I mount my Windows partition?

```bash
sudo mount -t ntfs3 /dev/sdXY /mnt/windows
```

### How do I mount my macOS partition?

```bash
# HFS+
sudo mount -t hfsplus -o ro /dev/sdXY /mnt/macos

# APFS (requires apfs-fuse)
sudo apfs-fuse -o allow_other /dev/sdXY /mnt/macos
```

### Windows partition says "hibernated"

Disable Fast Startup in Windows, then shut down (not restart).

### Not enough disk space

Check space with `df -h`. Delete or move files, or migrate selectively.

## Security

### Are my passwords safe during migration?

Password files are never stored in plain text by sanchala-migrate. Exported CSV files should be securely deleted after import.

### Should I migrate SSH keys?

Consider generating new keys instead. If you must migrate:
```bash
cp -r /source/.ssh ~/.ssh
chmod 700 ~/.ssh && chmod 600 ~/.ssh/id_*
```

## After Migration

### My keyboard shortcuts are different

See the shortcuts section in [Windows](WINDOWS-MIGRATION.md) or [macOS](MACOS-MIGRATION.md) guides.

### Where are my files?

Standard folders: `~/Documents`, `~/Downloads`, `~/Pictures`, `~/Music`, `~/Videos`

### How do I find Linux alternatives for my apps?

See [App Mapping Guide](APP-MAPPING.md).

---

**More questions?** Visit [forum.sanchala.id](https://forum.sanchala.id)
