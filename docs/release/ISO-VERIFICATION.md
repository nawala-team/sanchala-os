# Sanchala OS ISO Verification

> Final ISO build verification procedures and quality gates

## Overview

All checks must pass before any ISO can be released for distribution.

---

## 1. Build Environment Verification

### 1.1 Prerequisites Check

```bash
#!/bin/bash
# verify-build-env.sh

REQUIRED=(arch-install-scripts archiso base-devel dosfstools
          git grub libisoburn mtools squashfs-tools xorriso)

for pkg in "${REQUIRED[@]}"; do
    pacman -Q "$pkg" &>/dev/null && echo "✓ $pkg" || echo "✗ $pkg MISSING"
done

# Disk space (need 15GB minimum)
AVAILABLE=$(df -BG /tmp | awk 'NR==2 {print $4}' | tr -d 'G')
[[ $AVAILABLE -ge 15 ]] && echo "✓ Disk: ${AVAILABLE}GB" || echo "✗ Need 15GB"
```

### 1.2 Source Verification

- [ ] Repository from official source
- [ ] Correct release branch/tag
- [ ] No uncommitted changes
- [ ] GPG signatures verified

---

## 2. Build Process Verification

### 2.1 Clean Build

```bash
sudo ./iso/build-binary --clean --version X.Y.Z
```

### 2.2 Build Log Analysis

- [ ] No package download failures
- [ ] No dependency conflicts
- [ ] Squashfs compression successful
- [ ] GRUB installation successful

### 2.3 Build Metrics

| Metric | Expected | Actual |
|--------|----------|--------|
| Build time | <180 min | _____ |
| Peak memory | <8 GB | _____ |
| Final ISO | 2.5-4.0 GB | _____ |

---

## 3. ISO Structure Verification

```bash
#!/bin/bash
# verify-iso-structure.sh
ISO="$1"; MOUNT="/tmp/iso-verify"
mkdir -p "$MOUNT" && sudo mount -o loop,ro "$ISO" "$MOUNT"

# Check required paths
for path in "arch/x86_64/airootfs.sfs" "EFI/BOOT/BOOTX64.EFI" \
            "arch/boot/x86_64/vmlinuz-linux" "isolinux/isolinux.bin"; do
    [[ -e "$MOUNT/$path" ]] && echo "✓ $path" || echo "✗ $path MISSING"
done

sudo umount "$MOUNT"
```

---

## 4. Boot Verification

### 4.1 QEMU Automated Test

```bash
#!/bin/bash
# verify-boot-qemu.sh
ISO="$1"

# UEFI test
timeout 120 qemu-system-x86_64 -m 2048 -cdrom "$ISO" -boot d \
    -bios /usr/share/ovmf/OVMF.fd -nographic -no-reboot 2>&1 | tee boot.log &
sleep 90 && pkill -f qemu || true

grep -qi "sanchala\|grub\|linux" boot.log && echo "✓ UEFI boot OK"
```

### 4.2 Manual Boot Checklist

| Test | UEFI | BIOS |
|------|------|------|
| Boot menu appears | [ ] | [ ] |
| Kernel loads | [ ] | [ ] |
| Desktop starts | [ ] | [ ] |
| Network available | [ ] | [ ] |

---

## 5. Checksum Generation

```bash
#!/bin/bash
# generate-checksums.sh
ISO="$1"; cd "$(dirname "$ISO")"; BASE=$(basename "$ISO")

sha256sum "$BASE" > "${BASE}.sha256"
sha512sum "$BASE" > "${BASE}.sha512"
b2sum "$BASE" > "${BASE}.b2sum"

# GPG sign
gpg --armor --detach-sign "$BASE"
```

---

## 6. Verification Sign-off

| Step | Status | Verified By |
|------|--------|-------------|
| Build environment | ⬜ | |
| Clean build | ⬜ | |
| ISO structure | ⬜ | |
| UEFI boot | ⬜ | |
| BIOS boot | ⬜ | |
| Checksums | ⬜ | |
| GPG signed | ⬜ | |

**Final Approval:** _______________ Date: ___________
