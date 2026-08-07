# Developer Setup Guide

This guide helps you set up a development environment for contributing to Sanchala OS.

---

## Table of Contents

- [Overview](#overview)
- [Development Machine Setup](#development-machine-setup)
- [Repository Setup](#repository-setup)
- [Building Packages](#building-packages)
- [Building the ISO](#building-the-iso)
- [Testing Changes](#testing-changes)
- [Development Tools](#development-tools)

---

## Overview

Sanchala OS development involves several components:

| Component | Technology | Location |
|-----------|------------|----------|
| ISO Build | archiso | `iso/` |
| Packages | PKGBUILD/makepkg | `packages/` |
| Desktop Config | KDE Plasma | `configs/kde/` |
| Security | AppArmor, sysctl | `configs/security/` |
| Custom Tools | Python, Qt/C++ | `tools/` |
| Documentation | Markdown | `docs/` |

---

## Development Machine Setup

### Recommended: Arch Linux or Sanchala OS

For the smoothest experience, develop on Arch Linux or Sanchala OS itself.

```bash
# Install base development tools
sudo pacman -S --needed \
    base-devel \
    git \
    archiso \
    devtools \
    namcap \
    shellcheck

# For KDE/Qt development
sudo pacman -S --needed \
    qt6-base \
    qt6-tools \
    qt6-declarative \
    extra-cmake-modules \
    plasma-framework \
    ki18n \
    kcoreaddons

# For Python development
sudo pacman -S --needed \
    python \
    python-pip \
    python-pytest \
    python-black \
    ruff

# For documentation
sudo pacman -S --needed \
    mdbook
```

### Alternative: Docker/Podman

Build in a container for isolation:

```bash
# Pull Arch Linux container
podman pull archlinux:latest

# Run with repository mounted
podman run -it -v $(pwd):/sanchala-os:Z archlinux:latest

# Inside container, install dependencies
pacman -Syu --noconfirm base-devel git archiso
```

### Alternative: Virtual Machine

Use a VM for testing ISOs:

```bash
# Install QEMU/KVM
sudo pacman -S qemu-full virt-manager libvirt

# Enable libvirt service
sudo systemctl enable --now libvirtd

# Add yourself to libvirt group
sudo usermod -aG libvirt $USER
```

---

## Repository Setup

### Clone the Repository

```bash
# Fork on GitHub first, then:
git clone https://github.com/YOUR_USERNAME/sanchala-os.git
cd sanchala-os

# Add upstream
git remote add upstream https://github.com/nicholaslourdes/sanchala-os.git

# Fetch all branches
git fetch --all
```

### Repository Structure

```
sanchala-os/
├── branding/              # Visual assets
│   ├── logos/
│   ├── wallpapers/
│   └── icons/
├── configs/               # System configurations
│   ├── kde/               # Plasma settings
│   ├── apparmor/          # Security profiles
│   ├── sysctl/            # Kernel parameters
│   └── etc/               # /etc overlays
├── docs/                  # Documentation
├── installer/             # Calamares customization
│   ├── branding/
│   └── modules/
├── iso/                   # archiso profile
│   ├── airootfs/          # Root filesystem overlay
│   ├── packages.x86_64    # Package list
│   └── profiledef.sh      # ISO profile definition
├── packages/              # Custom packages
│   ├── sanchala-guardian/
│   ├── sanchala-settings/
│   └── sanchala-branding/
├── scripts/               # Build and utility scripts
│   ├── build-iso.sh
│   ├── build-packages.sh
│   └── test.sh
└── tools/                 # Custom applications source
    ├── sanchala-guardian/
    ├── sanchala-store/
    └── sanchala-welcome/
```

### Set Up Git Hooks

```bash
# Install pre-commit hooks
./scripts/setup-dev.sh

# Or manually:
cp hooks/pre-commit .git/hooks/
chmod +x .git/hooks/pre-commit
```

---

## Building Packages

### Understanding PKGBUILD

Sanchala packages use Arch's PKGBUILD format:

```bash
# packages/sanchala-branding/PKGBUILD
pkgname=sanchala-branding
pkgver=1.0.0
pkgrel=1
pkgdesc="Sanchala OS branding and theming"
arch=('any')
url="https://sanchala.id"
license=('GPL3')
depends=('plasma-desktop')

package() {
    install -Dm644 wallpaper.png "$pkgdir/usr/share/wallpapers/sanchala/contents/images/3840x2160.png"
}
```

### Build a Single Package

```bash
cd packages/sanchala-branding

# Build package
makepkg -s

# Install for testing
sudo pacman -U sanchala-branding-1.0.0-1-any.pkg.tar.zst

# Check for issues
namcap PKGBUILD
namcap sanchala-branding-1.0.0-1-any.pkg.tar.zst
```

### Build All Packages

```bash
./scripts/build-packages.sh

# Build specific package
./scripts/build-packages.sh sanchala-guardian
```

### Using a Clean Chroot (Recommended)

Build in isolation to catch missing dependencies:

```bash
# Set up devtools chroot
sudo mkdir -p /var/lib/archbuild/sanchala/root
sudo mkarchroot /var/lib/archbuild/sanchala/root base-devel

# Build in chroot
cd packages/sanchala-guardian
makechrootpkg -c -r /var/lib/archbuild/sanchala
```

---

## Building the ISO

### Quick Build

```bash
# Build ISO (requires sudo)
./scripts/build-iso.sh

# Output: out/sanchala-os-<version>-x86_64.iso
```

### Manual Build Steps

```bash
# Create work directory
sudo mkdir -p /tmp/sanchala-build

# Run archiso
sudo mkarchiso -v -w /tmp/sanchala-build -o out/ iso/

# Clean up
sudo rm -rf /tmp/sanchala-build
```

### Build Options

```bash
# Verbose build with logs
./scripts/build-iso.sh --verbose 2>&1 | tee build.log

# Build minimal ISO (faster for testing)
./scripts/build-iso.sh --profile minimal

# Skip package cache (fresh download)
./scripts/build-iso.sh --no-cache
```

---

## Testing Changes

### Test ISO in VM

```bash
# Using QEMU (quick test)
qemu-system-x86_64 \
    -cdrom out/sanchala-os-1.0-x86_64.iso \
    -m 4G \
    -enable-kvm \
    -cpu host \
    -smp 4

# With UEFI (recommended)
qemu-system-x86_64 \
    -cdrom out/sanchala-os-1.0-x86_64.iso \
    -m 4G \
    -enable-kvm \
    -cpu host \
    -smp 4 \
    -bios /usr/share/ovmf/x64/OVMF.fd

# With virtual disk for installation testing
qemu-img create -f qcow2 test-disk.qcow2 50G
qemu-system-x86_64 \
    -cdrom out/sanchala-os-1.0-x86_64.iso \
    -drive file=test-disk.qcow2,format=qcow2 \
    -m 4G \
    -enable-kvm \
    -cpu host \
    -bios /usr/share/ovmf/x64/OVMF.fd
```

### Test Package Changes

```bash
# Build and install package
cd packages/sanchala-guardian
makepkg -si

# Test the application
sanchala-guardian --version
sanchala-guardian --self-test
```

### Run Test Suite

```bash
# Run all tests
./scripts/test.sh

# Run specific tests
./scripts/test.sh --suite security
./scripts/test.sh --suite packages

# Run with coverage
./scripts/test.sh --coverage
```

---

## Development Tools

### Code Linting

```bash
# Shell scripts
shellcheck scripts/*.sh
shellcheck iso/airootfs/usr/local/bin/*

# Python
ruff check tools/
black --check tools/

# PKGBUILD
namcap packages/*/PKGBUILD
```

### Useful Commands

```bash
# Check package dependencies
pactree -r sanchala-guardian

# Find which package owns a file
pacman -Qo /usr/bin/sanchala-guardian

# List files in a package
pacman -Ql sanchala-guardian

# Compare package versions
vercmp 1.0.0 1.0.1
```

### IDE Setup

**VS Code / VSCodium:**

```bash
# Install extensions
code --install-extension timonwong.shellcheck
code --install-extension ms-python.python
code --install-extension redhat.vscode-yaml
```

**Kate (KDE):**

Built-in support for shell, Python, and Markdown.

---

## Next Steps

- Read [CONTRIBUTING.md](../../CONTRIBUTING.md) for contribution guidelines
- Check [ARCHITECTURE.md](../ARCHITECTURE.md) for system design
- See [ISO-BUILD.md](../building/ISO-BUILD.md) for detailed ISO building
- Review [coding standards](../../CONTRIBUTING.md#coding-standards)

---

**Document Version:** 1.0  
**Last Updated:** August 2026
