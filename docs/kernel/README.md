# Sanchala OS - Kernel Documentation

## Overview

Sanchala OS uses **linux-hardened** from Arch repositories as its kernel. This provides enterprise-grade security without the maintenance burden of a custom kernel build.

## Why linux-hardened?

| Feature | linux-hardened | Standard linux |
|---------|---------------|----------------|
| KASLR | Enhanced | Basic |
| Stack Protection | Strong | Standard |
| Usercopy Hardening | Yes | No |
| BPF JIT Hardening | Yes | No |
| Kernel Lockdown | Yes | Optional |
| Audit Subsystem | Enhanced | Basic |

## Kernel Boot Parameters

Sanchala uses optimized cmdline parameters for security and fast boot:

```
quiet loglevel=3 splash slab_nomerge init_on_alloc=1 init_on_free=1 
page_alloc.shuffle=1 pti=on vsyscall=none debugfs=off oops=panic 
lockdown=confidentiality iommu=force randomize_kstack_offset=on
```

### Parameter Explanation

| Parameter | Purpose |
|-----------|---------|
| `slab_nomerge` | Prevents slab cache merging (exploit mitigation) |
| `init_on_alloc=1` | Zero-fills memory on allocation |
| `init_on_free=1` | Zero-fills memory on free (prevents UAF leaks) |
| `pti=on` | Page Table Isolation (Meltdown fix) |
| `vsyscall=none` | Disables legacy vsyscall interface |
| `debugfs=off` | Disables debugfs (attack surface reduction) |
| `lockdown=confidentiality` | Strictest kernel lockdown mode |
| `iommu=force` | Forces IOMMU for DMA protection |

## Security Layers

The kernel provides Layer 4 (Kernel Fortress) of Sanchala's 8-layer security:

1. **Kernel Lockdown** - Prevents runtime kernel modification
2. **Module Signing** - Only signed modules load
3. **Sysctl Hardening** - Via `/etc/sysctl.d/99-sanchala-hardening.conf`
4. **Module Blacklist** - Via `/etc/modprobe.d/sanchala-blacklist.conf`

## Initramfs Configuration

We use systemd-based initramfs for faster boot:

```
HOOKS=(base systemd autodetect modconf kms keyboard sd-vconsole block sd-encrypt filesystems fsck)
COMPRESSION="zstd"
```

## Files Reference

| File | Purpose |
|------|---------|
| `/kernel/config` | Kernel config documentation |
| `/kernel/cmdline` | Boot parameter presets |
| `/security/kernel/99-sanchala-hardening.conf` | Sysctl hardening |
| `/security/kernel/module-blacklist.conf` | Module restrictions |
| `/iso/airootfs/etc/mkinitcpio.conf` | Initramfs config |

## Verification

After installation, verify security features:

```bash
# Check kernel lockdown
cat /sys/kernel/security/lockdown

# Check KASLR
dmesg | grep -i kaslr

# Check AppArmor
aa-status

# Check loaded modules
lsmod | wc -l
```
