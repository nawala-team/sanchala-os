# Installing Sanchala OS

This guide walks you through installing Sanchala OS on your computer.

---

## Table of Contents

- [System Requirements](#system-requirements)
- [Pre-Installation](#pre-installation)
- [Creating Bootable Media](#creating-bootable-media)
- [Booting the Installer](#booting-the-installer)
- [Installation Process](#installation-process)
- [Post-Installation](#post-installation)
- [Troubleshooting](#troubleshooting)

---

## System Requirements

### Minimum Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| **Processor** | 64-bit dual-core | Quad-core or better |
| **RAM** | 4 GB | 8 GB or more |
| **Storage** | 25 GB | 50 GB or more (SSD preferred) |
| **Graphics** | OpenGL 3.3 capable | Vulkan-capable GPU |
| **Display** | 1024x768 | 1920x1080 or higher |
| **Internet** | Required for installation | Broadband recommended |

### Supported Hardware

- **UEFI** firmware (Secure Boot supported)
- **TPM 2.0** (optional, enhances security features)
- Most Intel/AMD processors from 2012 onwards
- NVIDIA, AMD, and Intel graphics

### Not Supported

- 32-bit (i686) processors
- Legacy BIOS-only systems
- ARM processors (planned for future release)

---

## Pre-Installation

### 1. Download Sanchala OS

Download the latest ISO from the official website:

**https://sanchala.id/download**

Choose the appropriate edition:

| Edition | Description |
|---------|-------------|
| **Standard** | Full desktop experience, recommended for most users |
| **Minimal** | Base system for advanced users |

### 2. Verify the Download

Always verify your download to ensure integrity:

```bash
# Download the checksum file
wget https://sanchala.id/releases/sanchala-os-1.0-x86_64.iso.sha256

# Verify
sha256sum -c sanchala-os-1.0-x86_64.iso.sha256
```

Expected output: `sanchala-os-1.0-x86_64.iso: OK`

### 3. Backup Your Data

> **Warning:** Installation may erase data on your drive. Back up important files before proceeding.

### 4. Check UEFI Settings

Access your UEFI/BIOS settings (usually F2, F12, Del, or Esc during boot) and:

- Enable UEFI mode (disable Legacy/CSM if present)
- Disable Secure Boot temporarily (can re-enable after installation)
- Set boot order to prioritize USB

---

## Creating Bootable Media

### Option A: Using Ventoy (Recommended)

[Ventoy](https://ventoy.net) allows you to boot ISOs directly:

1. Install Ventoy on a USB drive
2. Copy the Sanchala OS ISO to the Ventoy partition
3. Boot and select Sanchala OS

### Option B: Using dd (Linux/macOS)

```bash
# Identify your USB drive (be careful!)
lsblk

# Write the ISO (replace /dev/sdX with your USB device)
sudo dd if=sanchala-os-1.0-x86_64.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

> **Warning:** Double-check the target device. `dd` will overwrite without confirmation.

### Option C: Using Rufus (Windows)

1. Download [Rufus](https://rufus.ie)
2. Select your USB drive
3. Select the Sanchala OS ISO
4. Choose "GPT" partition scheme
5. Choose "UEFI (non-CSM)" target system
6. Click Start

### Option D: Using balenaEtcher (Cross-platform)

1. Download [balenaEtcher](https://etcher.io)
2. Select the ISO
3. Select your USB drive
4. Click Flash

---

## Booting the Installer

1. Insert the USB drive
2. Restart your computer
3. Enter boot menu (F12, F2, or Esc depending on manufacturer)
4. Select the USB drive (UEFI mode)
5. Select "Sanchala OS Install" from the boot menu

---

## Installation Process

Sanchala OS uses a customized Calamares installer for a smooth experience.

### Step 1: Welcome

- Select your language
- Click **Next**

### Step 2: Location

- Select your region and timezone
- Click on the map or use dropdowns
- Click **Next**

### Step 3: Keyboard

- Select your keyboard layout
- Test in the text field
- Click **Next**

### Step 4: Partitioning

Choose your installation type:

| Option | Description |
|--------|-------------|
| **Erase Disk** | Wipes entire disk, creates optimal layout |
| **Replace Partition** | Replaces an existing partition |
| **Install Alongside** | Dual-boot with existing OS |
| **Manual** | Full control over partitioning |

#### Recommended Partition Layout (Manual)

| Partition | Size | Type | Mount Point |
|-----------|------|------|-------------|
| EFI | 512 MB | FAT32 | /boot/efi |
| Root | 50+ GB | Btrfs | / |
| Swap | RAM size | swap | - |

> **Note:** Sanchala OS uses Btrfs with automatic subvolume layout for snapshots.

#### Encryption (Recommended)

Check "Encrypt system" to enable LUKS2 full-disk encryption:

- Choose a strong passphrase (12+ characters)
- Store your recovery key safely
- TPM auto-unlock available after installation

### Step 5: Users

- Enter your full name
- Choose a username (lowercase, no spaces)
- Set a strong password
- Optionally set a different root password
- Choose whether to log in automatically

### Step 6: Summary

- Review all settings
- Click **Install** to begin

### Step 7: Installation

- Wait for installation to complete (10-30 minutes)
- Do not remove USB or power off
- Progress bar shows current status

### Step 8: Finish

- Click **Restart Now**
- Remove USB when prompted
- Boot into your new Sanchala OS installation

---

## Post-Installation

### First Boot

On first boot, Sanchala Welcome will guide you through:

1. **Connect to Network** - Wi-Fi or Ethernet setup
2. **System Update** - Install latest updates
3. **Privacy Settings** - Configure telemetry (off by default)
4. **Additional Drivers** - Install proprietary drivers if needed
5. **App Recommendations** - Install popular applications

### Essential First Steps

```bash
# Update the system
sudo pacman -Syu

# Install additional software
sudo pacman -S firefox libreoffice

# Or use Flatpak (sandboxed)
flatpak install flathub org.mozilla.firefox
```

### Enable Security Features

Open **Sanchala Guardian** to:

- Review security status
- Enable firewall (enabled by default)
- Configure automatic updates
- Set up backup snapshots

### Configure TPM Auto-Unlock (Optional)

If you enabled disk encryption and have TPM 2.0:

```bash
# Enroll TPM for auto-unlock on verified boot
sudo sanchala-tpm-enroll
```

---

## Troubleshooting

### Boot Issues

**Problem:** System does not boot from USB

- Ensure UEFI mode is enabled
- Disable Secure Boot temporarily
- Try a different USB port (USB 2.0 ports are more compatible)

**Problem:** Black screen after boot

- Try adding `nomodeset` to kernel parameters
- At boot menu, press `e`, add `nomodeset` to the linux line
- Install proper graphics drivers after installation

### Installation Issues

**Problem:** Installer crashes

- Check ISO integrity (re-download if needed)
- Try with minimal graphics: add `nomodeset` at boot
- Check RAM with memtest86+

**Problem:** Disk not detected

- Check SATA mode in UEFI (try AHCI)
- For NVMe, ensure NVMe support is enabled
- Some RAID configurations need drivers

### Post-Installation Issues

**Problem:** No Wi-Fi

```bash
# Check wireless device
ip link

# For Broadcom chips
sudo pacman -S broadcom-wl

# Restart NetworkManager
sudo systemctl restart NetworkManager
```

**Problem:** Graphics issues

```bash
# NVIDIA users
sudo pacman -S nvidia nvidia-utils

# AMD users (usually works out of box)
sudo pacman -S mesa vulkan-radeon

# Intel users
sudo pacman -S mesa vulkan-intel
```

---

## Getting Help

If you encounter issues:

1. Check the [FAQ](../FAQ.md)
2. Search the [Forum](https://forum.sanchala.id)
3. Join our community chat
4. File an issue on [GitHub](https://github.com/nicholaslourdes/sanchala-os/issues)

---

## Next Steps

- [First Steps Guide](first-steps.md) - Getting started with your new system
- [Desktop Guide](desktop.md) - Learn the Sanchala desktop
- [Security Guide](../security/SECURITY.md) - Understanding security features

---

**Document Version:** 1.0  
**Last Updated:** August 2026
