# Sanchala OS - PKGBUILD Development Guide

## Overview

This guide covers creating and maintaining PKGBUILDs for Sanchala OS custom packages.

## Package Structure

```
pkgbuilds/
├── sanchala-filesystem/     # OS identity files
├── sanchala-keyring/        # Package signing keys
├── sanchala-mirrorlist/     # Repository mirrors
├── sanchala-settings/       # Default KDE/system settings
├── sanchala-wallpapers/     # Wallpaper collection
├── sanchala-icons/          # Icon theme
├── sanchala-grub-theme/     # GRUB bootloader theme
├── sanchala-plymouth/       # Boot splash theme
├── sanchala-welcome/        # Welcome application
├── sanchala-guardian/       # Security center
├── sanchala-store/          # Software store
└── sanchala-dock/           # Dock configuration
```

## PKGBUILD Template

```bash
# Maintainer: Sanchala Team <dev@sanchala.id>

pkgname=sanchala-example
pkgver=1.0.0
pkgrel=1
pkgdesc='Sanchala OS Example Package'
arch=('any')  # or ('x86_64' 'aarch64')
url='https://sanchala.id'
license=('GPL3')
groups=('sanchala')
depends=('dependency1' 'dependency2')
makedepends=('build-tool')
optdepends=('optional-pkg: feature description')
backup=('etc/sanchala/config.conf')  # Config files to preserve
install=sanchala-example.install     # Post-install hooks

# For source packages:
source=("${pkgname}-${pkgver}.tar.gz::https://github.com/sanchala/${pkgname}/archive/v${pkgver}.tar.gz")
sha256sums=('SKIP')  # Replace with actual checksum

build() {
    cd "$srcdir/${pkgname}-${pkgver}"
    # Build commands
}

package() {
    cd "$srcdir/${pkgname}-${pkgver}"
    # Install commands
    install -Dm644 "file" "$pkgdir/usr/share/sanchala/file"
}
```

## Building Packages

### Local Build

```bash
cd pkgbuilds/sanchala-example

# Build package
makepkg -s

# Build and install
makepkg -si

# Clean build
makepkg -C
```

### Build All Packages

```bash
#!/bin/bash
# build-all-packages.sh

for pkg in pkgbuilds/sanchala-*/; do
    echo "Building ${pkg}..."
    (cd "$pkg" && makepkg -sf --noconfirm)
done
```

## Adding to Repository

```bash
# Create/update repository database
repo-add --sign sanchala.db.tar.gz pkgbuilds/*/sanchala-*.pkg.tar.zst

# Upload to server
rsync -avz --progress \
    sanchala.db.tar.gz* \
    sanchala.files.tar.gz* \
    sanchala-*.pkg.tar.zst* \
    user@repo.sanchala.id:/srv/repo/packages/x86_64/
```

## Package Categories

### Core Identity (`sanchala-filesystem`)
- `/etc/os-release`
- `/etc/lsb-release`
- `/etc/sanchala-release`
- `/etc/issue`
- `/etc/motd`
- Logo files

### Security (`sanchala-keyring`)
- GPG keys for package signing
- Keyring installation hooks

### Configuration (`sanchala-settings`)
- Default KDE Plasma settings
- Color schemes
- Global XDG configs

### Theming
- `sanchala-wallpapers` — Wallpaper images
- `sanchala-icons` — Icon theme
- `sanchala-grub-theme` — GRUB theme
- `sanchala-plymouth` — Boot splash

### Applications
- `sanchala-welcome` — First-run wizard
- `sanchala-guardian` — Security center
- `sanchala-store` — Software center

## Testing Packages

```bash
# Check PKGBUILD
namcap PKGBUILD

# Check built package
namcap sanchala-example-1.0.0-1-any.pkg.tar.zst

# Test install in container
sudo pacman -U sanchala-example-*.pkg.tar.zst

# Verify files
pacman -Ql sanchala-example
```

## Version Numbering

| Component | Format | Example |
|-----------|--------|---------|
| Major release | X.0.0 | 1.0.0 |
| Feature update | X.Y.0 | 1.1.0 |
| Bug fix | X.Y.Z | 1.1.1 |
| Package revision | pkgrel | -2 |

## Best Practices

1. **Use arch=('any')** for non-compiled packages
2. **Include backup=()** for user-editable config files
3. **Set proper permissions** (644 for files, 755 for executables)
4. **Validate with namcap** before committing
5. **Sign packages** before uploading to repository
6. **Test installation** on clean system

---

*Sanchala OS Package Maintainers*
