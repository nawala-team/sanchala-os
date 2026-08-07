# 🚀 Beta Tester Onboarding Guide

> Welcome to the Sanchala OS Beta Program!

---

## Welcome, Beta Tester!

Thank you for joining the Sanchala OS beta program. Your feedback is essential to making Sanchala OS the best it can be. This guide will help you get started.

---

## Quick Start Checklist

- [ ] Download the latest beta ISO
- [ ] Verify the checksum
- [ ] Install Sanchala OS (VM or hardware)
- [ ] Complete initial setup
- [ ] Join communication channels
- [ ] Run first test checklist
- [ ] Submit onboarding feedback

---

## Step 1: Get the Beta ISO

### Download
```
URL: https://beta.sanchala.id/download
File: sanchala-os-1.0-beta.2-x86_64.iso
Size: ~3.2 GB
```

### Verify Checksum
```bash
# Download checksum file
wget https://beta.sanchala.id/download/SHA256SUMS
wget https://beta.sanchala.id/download/SHA256SUMS.sig

# Verify GPG signature (optional but recommended)
gpg --verify SHA256SUMS.sig SHA256SUMS

# Verify ISO checksum
sha256sum -c SHA256SUMS
```

### Create Bootable USB
```bash
# Linux (replace /dev/sdX with your USB device)
sudo dd if=sanchala-os-1.0-beta.2-x86_64.iso of=/dev/sdX bs=4M status=progress

# Or use a GUI tool like:
# - Ventoy (recommended)
# - balenaEtcher
# - GNOME Disks
```

---

## Step 2: Install Sanchala OS

### Recommended Test Environments

| Method | Pros | Cons |
|--------|------|------|
| **Virtual Machine** | Safe, easy snapshots | Limited hardware testing |
| **Spare Hardware** | Real-world testing | Need dedicated machine |
| **Dual Boot** | Real hardware + safety | More complex setup |

### VM Settings (Recommended)
- **RAM:** 4GB minimum, 8GB recommended
- **Storage:** 40GB minimum
- **CPU:** 2+ cores
- **Graphics:** Enable 3D acceleration
- **EFI:** Enable UEFI boot mode

### Installation Tips
1. Boot from ISO
2. Select "Install Sanchala OS"
3. Follow Calamares installer
4. **Recommended:** Enable full disk encryption
5. Wait for installation (~10-20 minutes)
6. Reboot and remove USB

---

## Step 3: Initial Setup

After first boot:

1. **Welcome App** launches automatically
2. Complete these setup steps:
   - Connect to WiFi/Network
   - Set timezone
   - Configure privacy settings
   - Create user account (if not done in installer)
   - Optional: Connect online accounts

3. **Run system update:**
```bash
sudo pacman -Syu
```

---

## Step 4: Join Communication Channels

| Channel | Link | Purpose |
|---------|------|---------|
| GitHub Issues | [Link](https://github.com/sanchala-os/sanchala-os/issues) | Bug reports |
| GitHub Discussions | [Link](https://github.com/sanchala-os/sanchala-os/discussions) | Q&A, ideas |
| Beta Forum | [Link](https://forum.sanchala.id/c/beta) | Discussion |
| Matrix Chat | #sanchala-beta:matrix.org | Real-time chat |

---

## Step 5: First Week Testing

### Day 1: Basic Functionality
- [ ] System boots successfully
- [ ] Desktop loads properly
- [ ] WiFi/Ethernet connects
- [ ] Sound works (speakers/headphones)
- [ ] Display resolution correct

### Day 2-3: Core Features
- [ ] Install an app from Sanchala Store
- [ ] Install a Flatpak app
- [ ] Test Sanchala Guardian (security center)
- [ ] Test file manager
- [ ] Test web browser

### Day 4-5: Your Workflow
- [ ] Install your regular applications
- [ ] Test your typical tasks
- [ ] Note any friction points
- [ ] Test suspend/resume

### Day 6-7: Advanced
- [ ] Test system updates
- [ ] Test Btrfs snapshots
- [ ] Test any peripherals (printers, etc.)
- [ ] Complete onboarding survey

---

## Reporting Issues

### Found a Bug?
1. Check [Known Issues](KNOWN-ISSUES.md) first
2. Search existing [GitHub Issues](https://github.com/sanchala-os/sanchala-os/issues)
3. If new, [create a bug report](BUG-REPORTING.md)

### Quick Info Collection
```bash
# Generate system report for bug reports
sanchala-info --full > ~/bug-report-info.txt
```

### Security Issues
**Do NOT report publicly.** Email: security@sanchala.id

---

## Best Practices

### DO ✅
- Test on real hardware when possible
- Report issues with detailed steps
- Check for existing issues before reporting
- Be patient and constructive
- Update regularly to latest beta

### DON'T ❌
- Use beta as your only system (have backups!)
- Share beta ISO publicly
- Report security issues publicly
- Expect production-level stability

---

## Getting Help

| Need | Where |
|------|-------|
| Technical help | GitHub Discussions, Forum |
| Bug report help | #sanchala-beta Matrix |
| Program questions | beta@sanchala.id |
| Security concerns | security@sanchala.id |

---

## Recognition Program

Your contributions earn recognition:

| Tier | Requirements |
|------|--------------|
| Bronze | 5+ valid contributions |
| Silver | 15+ contributions |
| Gold | 30+ contributions or critical bug |
| Platinum | Exceptional contribution |

---

## Thank You!

Your participation makes Sanchala OS better for everyone. We truly appreciate your time and effort.

Happy testing! 🎉

---

**Beta Program Team**  
beta@sanchala.id
