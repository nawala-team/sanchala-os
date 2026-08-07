# Frequently Asked Questions

Common questions about Sanchala OS.

---

## General

### What is Sanchala OS?

Sanchala OS is a secure, beautiful Linux distribution based on Arch Linux. It combines macOS-inspired design with enterprise-grade security, featuring an 8-layer security architecture and the KDE Plasma 6 desktop.

### What does "Sanchala" mean?

"Sanchala" (संञ्चल) is a Sanskrit word meaning "to set in motion" or "to activate." It reflects our goal of empowering users with a system that just works.

### Is Sanchala OS free?

Yes! Sanchala OS is 100% free and open source, licensed under GPL v3.

### Who is Sanchala OS for?

- Users wanting macOS aesthetics with Linux power
- Privacy-conscious users
- Developers who need a secure workstation
- Anyone frustrated with Windows or macOS limitations
- Linux enthusiasts who want a polished experience

---

## Installation

### What are the system requirements?

- **Minimum:** 4 GB RAM, 25 GB storage, 64-bit processor
- **Recommended:** 8 GB RAM, 50 GB SSD, quad-core processor
- UEFI firmware required (no Legacy BIOS support)

### Can I dual-boot with Windows/macOS?

Yes! The installer supports dual-boot configurations. Choose "Install Alongside" during installation.

### Does Sanchala OS support Secure Boot?

Yes. Sanchala OS works with Secure Boot enabled.

### How long does installation take?

Typically 10-30 minutes depending on your hardware and internet speed.

---

## Software

### What package formats are supported?

- **Flatpak** (primary, sandboxed) — via Sanchala Store
- **Pacman** — Arch Linux packages
- **AUR** — Arch User Repository
- **AppImage** — auto-sandboxed

### Can I run Windows applications?

Yes, through Wine or Bottles. Many Windows apps work well, though not all.

### Is Steam/gaming supported?

Yes! Install Steam via Flatpak or Pacman. Proton enables many Windows games.

```bash
flatpak install flathub com.valvesoftware.Steam
```

### What browser comes pre-installed?

Brave Browser, chosen for its privacy features. Firefox and others are available.

---

## Security

### What makes Sanchala OS more secure?

Our 8-layer security architecture includes:

1. Hardware security (TPM 2.0)
2. Secure Boot
3. Full disk encryption (LUKS2)
4. System integrity verification
5. Hardened kernel
6. Memory protection
7. Code integrity verification
8. Application sandboxing
9. Zero-trust networking

### Is telemetry enabled?

No. All telemetry is OFF by default. We respect your privacy.

### How do I manage app permissions?

Use Sanchala Guardian or the Permissions app to control what apps can access.

---

## Updates & Maintenance

### How do I update the system?

```bash
sudo pacman -Syu
```

Or use the graphical updater in System Settings.

### Can I roll back a bad update?

Yes! Sanchala OS creates Btrfs snapshots before updates. Boot into a previous snapshot from GRUB if needed.

### How often are updates released?

As an Arch-based distro, updates are rolling and continuous. Security updates are prioritized.

---

## Troubleshooting

### My system won\'t boot after an update

1. At GRUB menu, select "Sanchala OS Snapshots"
2. Choose a snapshot from before the update
3. Boot and investigate the issue
4. Report the bug if needed

### Wi-Fi is not working

```bash
# Check if device is detected
ip link show

# Restart NetworkManager
sudo systemctl restart NetworkManager

# For some Broadcom chips
sudo pacman -S broadcom-wl
```

### Graphics issues / black screen

Try booting with `nomodeset` kernel parameter, then install proper drivers:

```bash
# NVIDIA
sudo pacman -S nvidia nvidia-utils

# AMD (usually automatic)
sudo pacman -S mesa vulkan-radeon
```

---

## Getting Help

### Where can I get support?

- **Forum:** [forum.sanchala.id](https://forum.sanchala.id)
- **GitHub Issues:** For bugs and feature requests
- **GitHub Discussions:** For questions

### How do I report a bug?

1. Search existing issues first
2. Include system info: `sanchala-info` output
3. Provide steps to reproduce
4. Attach relevant logs

### How can I contribute?

See our [Contributing Guide](../CONTRIBUTING.md). We welcome:
- Code contributions
- Documentation improvements
- Translations
- Bug reports and testing
- Design and artwork

---

**Last Updated:** August 2026
