# Linux Migration Guide

Migrating from another Linux distribution to Sanchala OS.

## Overview

Migrating from another Linux distribution is straightforward since most configurations are compatible. This guide covers transferring your data, settings, and customizations.

## Supported Source Distributions

- Ubuntu / Linux Mint / Pop!_OS
- Fedora / RHEL / CentOS
- Debian
- openSUSE
- Arch Linux / Manjaro
- Other distributions

## Step 1: Access Your Linux Data

### Dual Boot

```bash
# List partitions
lsblk

# Mount Linux partition
sudo mkdir -p /mnt/linux
sudo mount /dev/sdXY /mnt/linux
```

### External Drive

```bash
# Usually auto-mounts
ls /media/$USER/
```

## Step 2: Detect and Migrate

```bash
# Detect installation
sanchala-migrate detect

# Analyze
sanchala-migrate --source /mnt/linux analyze

# Migrate
sanchala-migrate --source /mnt/linux migrate
```

## Configuration Files

### Home Directory

Most configs transfer directly:

```bash
# Copy entire home (careful with conflicts)
rsync -av --progress /mnt/linux/home/user/ ~/

# Or selective configs
cp -r /mnt/linux/home/user/.config/specific-app ~/.config/
```

### Shell Configuration

```bash
# Bash
cp /mnt/linux/home/user/.bashrc ~/.bashrc.old
# Review and merge manually

# Zsh
cp /mnt/linux/home/user/.zshrc ~/.zshrc.old

# Fish
cp -r /mnt/linux/home/user/.config/fish ~/.config/
```

### Desktop Environments

**From KDE Plasma:**
```bash
cp -r /mnt/linux/home/user/.config/plasma* ~/.config/
cp -r /mnt/linux/home/user/.local/share/plasma* ~/.local/share/
```

**From GNOME:**
- Themes don't transfer directly
- Use similar KDE themes from store

**From XFCE:**
- Panel configs need recreation
- Themes may need KDE equivalents

## Package Lists

Export installed packages from source:

### Debian/Ubuntu
```bash
dpkg --get-selections > packages.txt
```

### Fedora
```bash
dnf list installed > packages.txt
```

### Arch (source was Arch-based)
```bash
pacman -Qqe > packages.txt
# Install on Sanchala OS
pacman -S --needed - < packages.txt
```

## Application Data

| Application | Config Location |
|-------------|-----------------|
| Firefox | `~/.mozilla/firefox/` |
| Chrome | `~/.config/google-chrome/` |
| VS Code | `~/.config/Code/` |
| Thunderbird | `~/.thunderbird/` |
| KeePassXC | `~/.config/keepassxc/` |
| SSH | `~/.ssh/` |
| GPG | `~/.gnupg/` |

## Troubleshooting

### Package name differences

Some packages have different names:
```bash
# Search for equivalent
pacman -Ss keyword
```

### Config file conflicts

```bash
# Backup existing configs first
mv ~/.config/app ~/.config/app.backup
cp -r /mnt/linux/home/user/.config/app ~/.config/
```

### Permission issues

```bash
# Fix ownership
sudo chown -R $USER:$USER ~/
```

---

**Next:** [Browser Import](BROWSER-IMPORT.md) | [App Mapping](APP-MAPPING.md)
