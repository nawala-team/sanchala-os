#!/bin/bash
# SPDX-License-Identifier: GPL-3.0
# Post-update hook: Update GRUB with new snapshots
# /etc/sanchala-updater/hooks.d/post-update/30-update-grub.sh

set -euo pipefail

# Regenerate GRUB config to include new snapshots
if [[ -f /etc/default/grub ]]; then
    echo "Updating GRUB configuration..."
    grub-mkconfig -o /boot/grub/grub.cfg 2>/dev/null
fi

# Trigger grub-btrfs daemon if running
if systemctl is-active grub-btrfsd &>/dev/null; then
    systemctl reload grub-btrfsd 2>/dev/null || true
fi
