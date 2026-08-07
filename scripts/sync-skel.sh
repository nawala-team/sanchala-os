#!/bin/bash
#
# SANCHALA OS - Sync settings/etc/skel to iso/airootfs/etc/skel
# Run this before building ISO
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

SOURCE_SKEL="${PROJECT_ROOT}/settings/etc/skel"
DEST_SKEL="${PROJECT_ROOT}/iso/airootfs/etc/skel"

echo "=== Syncing skel configuration ==="
echo "Source: ${SOURCE_SKEL}"
echo "Dest:   ${DEST_SKEL}"

# Create destination
mkdir -p "${DEST_SKEL}/.config"

# Copy all config files
if [ -d "${SOURCE_SKEL}/.config" ]; then
    cp -rv "${SOURCE_SKEL}/.config/"* "${DEST_SKEL}/.config/" 2>/dev/null || true
    echo "✓ Copied .config files"
fi

# Copy any dotfiles
for f in "${SOURCE_SKEL}"/.*; do
    if [ -f "$f" ]; then
        cp -v "$f" "${DEST_SKEL}/" 2>/dev/null || true
    fi
done

echo ""
echo "=== Skel sync complete! ==="
echo "Files in ${DEST_SKEL}/.config:"
ls -la "${DEST_SKEL}/.config/" | head -20
