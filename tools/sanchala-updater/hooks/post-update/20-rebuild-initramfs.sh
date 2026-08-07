#!/bin/bash
# SPDX-License-Identifier: GPL-3.0
# Post-update hook: Rebuild initramfs if needed
# /etc/sanchala-updater/hooks.d/post-update/20-rebuild-initramfs.sh

set -euo pipefail

# Check if kernel or mkinitcpio was updated
if pacman -Qo /boot/vmlinuz-linux &>/dev/null; then
    KERNEL_PKG=$(pacman -Qo /boot/vmlinuz-linux 2>/dev/null | awk '{print $5}')
    
    # Check if kernel package was updated recently
    if [[ -n "$KERNEL_PKG" ]]; then
        INSTALL_DATE=$(pacman -Qi "$KERNEL_PKG" 2>/dev/null | grep "Install Date" | cut -d: -f2-)
        INSTALL_EPOCH=$(date -d "$INSTALL_DATE" +%s 2>/dev/null || echo 0)
        NOW_EPOCH=$(date +%s)
        DIFF=$((NOW_EPOCH - INSTALL_EPOCH))
        
        # If kernel was installed in last 5 minutes, rebuild initramfs
        if [[ $DIFF -lt 300 ]]; then
            echo "Kernel updated, rebuilding initramfs..."
            mkinitcpio -P
            
            # Mark for reboot
            touch /run/reboot-required
            touch /var/lib/sanchala-updater/kernel_updated
        fi
    fi
fi
