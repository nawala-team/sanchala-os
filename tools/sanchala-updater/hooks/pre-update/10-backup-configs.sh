#!/bin/bash
# SPDX-License-Identifier: GPL-3.0
# Pre-update hook: Create backup of critical configs
# /etc/sanchala-updater/hooks.d/pre-update/10-backup-configs.sh

set -euo pipefail

BACKUP_DIR="/var/lib/sanchala-updater/config-backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Critical config files to backup
CONFIGS=(
    "/etc/fstab"
    "/etc/mkinitcpio.conf"
    "/etc/default/grub"
    "/etc/pacman.conf"
)

mkdir -p "${BACKUP_DIR}/${TIMESTAMP}"

for config in "${CONFIGS[@]}"; do
    if [[ -f "$config" ]]; then
        cp "$config" "${BACKUP_DIR}/${TIMESTAMP}/"
    fi
done

# Keep only last 5 backups
ls -dt "${BACKUP_DIR}"/*/ 2>/dev/null | tail -n +6 | xargs rm -rf 2>/dev/null || true

echo "Config backup created: ${BACKUP_DIR}/${TIMESTAMP}"
