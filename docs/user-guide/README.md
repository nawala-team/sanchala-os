# User Guide

Welcome to the Sanchala OS User Guide. This section contains documentation for end users.

---

## Getting Started

1. **[Installation Guide](INSTALLATION.md)** — Install Sanchala OS on your computer
2. **First Steps** — Initial setup and configuration (coming soon)
3. **Desktop Tour** — Learn the Sanchala desktop (coming soon)

---

## Topics

### Desktop

- Using the dock
- Panel and global menu
- Virtual desktops
- Window management
- Keyboard shortcuts

### Applications

- Installing apps (Flatpak, Pacman, AUR)
- Sanchala Store
- Default applications
- Removing applications

### Security & Privacy

- Sanchala Guardian overview
- Managing permissions
- Firewall settings
- VPN setup
- Privacy settings

### System

- System updates
- Snapshots and rollback
- Backup and restore
- Storage management

### Troubleshooting

- Common issues
- Getting help
- Reporting bugs

---

## Quick Reference

### Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Super` | Open app launcher |
| `Super + E` | File manager |
| `Super + T` | Terminal |
| `Super + L` | Lock screen |
| `Super + D` | Show desktop |
| `Alt + Tab` | Switch windows |
| `Ctrl + Alt + T` | New terminal |

### Essential Commands

```bash
# Update system
sudo pacman -Syu

# Install package
sudo pacman -S <package>

# Search packages
pacman -Ss <keyword>

# Install Flatpak app
flatpak install flathub <app-id>

# Create snapshot
sudo snapper create -d "Before changes"

# Check security status
sanchala-guardian --status
```

---

## Getting Help

- **In-app help:** Press `F1` in most applications
- **Forum:** [forum.sanchala.id](https://forum.sanchala.id)
- **Wiki:** [wiki.sanchala.id](https://wiki.sanchala.id)

---

**Last Updated:** August 2026
