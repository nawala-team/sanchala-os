# Sanchala OS - ISO Build Guide

> "Set Your System in Motion" — संञ्चल

This document explains how to build the Sanchala OS ISO image from source.

## Prerequisites

### System Requirements

- **Operating System**: Arch Linux or Arch-based distribution (EndeavourOS, Manjaro, etc.)
- **Disk Space**: At least 15GB free space
- **RAM**: Minimum 4GB (8GB recommended)
- **Network**: Stable internet connection for package downloads

### Required Packages

Install the build dependencies:

```bash
sudo pacman -S --needed \
    arch-install-scripts \
    squashfs-tools \
    xorriso \
    dosfstools \
    mtools \
    grub \
    libisoburn \
    git \
    pv
```

## Quick Start

```bash
# Clone the repository
git clone https://github.com/dansiapa/sanchala-os.git
cd sanchala-os

# Build the ISO
sudo ./iso/build-binary

# ISO will be in out/ directory
ls -la out/
```

## Build Options

| Option | Description | Default |
|--------|-------------|---------|
| `-v, --version` | ISO version string | Current date (YYYY.MM.DD) |
| `-o, --output` | Output directory | `./out` |
| `-c, --clean` | Clean work directory before building | false |
| `-s, --skip-aur` | Skip AUR packages | true (always) |
| `-h, --help` | Show help message | - |

### Examples

```bash
# Basic build with defaults
sudo ./iso/build-binary

# Build specific version
sudo ./iso/build-binary -v 1.0

# Clean build to new directory
sudo ./iso/build-binary --clean --version 1.0-beta -o /mnt/builds

# Use custom repo
SANCHALA_REPO_URL=https://repo.sanchala.id/packages sudo ./iso/build-binary
```

## Build Process Overview

The build script performs these steps:

1. **Dependency Check** — Verifies all required tools are installed
2. **Prepare Work Directory** — Creates `/tmp/sanchala-build/`
3. **Install Base System** — Uses `pacstrap` to install packages from lists
4. **Configure System** — Sets up locale, hostname, users, services
5. **Apply Security Hardening** — Copies sysctl configs, AppArmor profiles
6. **Create SquashFS** — Compresses the rootfs with zstd
7. **Setup Bootloader** — Configures GRUB for BIOS and UEFI
8. **Create ISO** — Builds final ISO with xorriso
9. **Cleanup** — Removes work directory

## Package Lists

Package lists are located in `iso/packages/`:

| File | Purpose |
|------|---------|
| `base.list` | Core system packages |
| `desktop.list` | KDE Plasma and desktop components |
| `apps.list` | Default applications |
| `security.list` | Security tools and frameworks |
| `sanchala.list` | Sanchala OS custom packages |

### Adding Packages

Edit the appropriate `.list` file:

```bash
# Comments start with #
package-name

# Packages are installed via pacstrap
```

**Note**: AUR packages (like `brave-bin`) are automatically skipped. These must be:
- Added to the Sanchala custom repository, or
- Installed post-build via a hook script

## Environment Variables

| Variable | Description |
|----------|-------------|
| `SANCHALA_REPO_URL` | URL to Sanchala package repository |
| `WORK_DIR` | Build work directory (default: `/tmp/sanchala-build`) |
| `ISO_VERSION` | Override ISO version string |

## Customization

### Custom Branding

Files in `filesystem/` are copied to the ISO:
- `os-release` — OS identification
- `lsb-release` — LSB compliance info  
- `issue` — Login prompt banner
- `motd` — Message of the day

### Security Hardening

Files in `security/` are applied during build:
- `kernel/*.conf` — Sysctl kernel hardening
- `apparmor/profiles/` — AppArmor profiles
- `firewall/*.conf` — Firewall rules

### Airootfs Overlay

Files in `iso/airootfs/` are copied directly to the root filesystem.

## Troubleshooting

### Build Fails at Pacstrap

```
error: failed to commit transaction (conflicting files)
```

**Solution**: Clean the work directory:
```bash
sudo rm -rf /tmp/sanchala-build
sudo ./iso/build-binary --clean
```

### Missing Kernel

```
[ERROR] No kernel found in /tmp/sanchala-build/airootfs/boot/
```

**Solution**: Ensure `linux-hardened` is in `base.list` and the Arch mirrors are working.

### GRUB Module Not Found

```
grub-mkimage: error: cannot find module 'part_gpt'
```

**Solution**: Install the full grub package:
```bash
sudo pacman -S grub
```

### Insufficient Disk Space

```
mksquashfs: Failed to write to output filesystem
```

**Solution**: Ensure at least 15GB free in `/tmp` or set `WORK_DIR` to a larger partition.

## CI/CD Integration

For automated builds:

```bash
#!/bin/bash
# ci-build.sh

export ISO_VERSION="${CI_COMMIT_TAG:-$(date +%Y.%m.%d)}"
export WORK_DIR="/builds/sanchala-work"
export SANCHALA_REPO_URL="https://repo.sanchala.id/packages"

sudo ./iso/build-binary --clean --output /builds/artifacts
```

## Output Files

After a successful build:

```
out/
├── sanchala-2024.01.15-gati-x86_64.iso      # Bootable ISO
├── sanchala-2024.01.15-gati-x86_64.iso.sha256
└── sanchala-2024.01.15-gati-x86_64.iso.sha512
```

## Testing the ISO

### QEMU (Quick Test)

```bash
qemu-system-x86_64 \
    -enable-kvm \
    -m 4G \
    -cdrom out/sanchala-*.iso \
    -boot d
```

### VirtualBox

1. Create new VM (Type: Linux, Version: Arch Linux 64-bit)
2. Allocate 4GB RAM, 30GB disk
3. Mount ISO as optical drive
4. Enable EFI if testing UEFI boot

### Physical Hardware

```bash
# Write to USB drive (replace /dev/sdX)
sudo dd if=out/sanchala-*.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

## Further Reading

- [ARCHITECTURE.md](../ARCHITECTURE.md) — System design overview
- [Repository Signing](REPO-SIGNING.md) — Package signing setup
- [Calamares Config](../installer/) — Installer customization

---

*Sanchala OS Build System v1.0*
