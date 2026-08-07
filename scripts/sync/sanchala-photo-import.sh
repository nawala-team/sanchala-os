#!/bin/bash
# ============================================================================
# SANCHALA OS - Phone Photo Import Tool
# ============================================================================
# Location: /usr/local/bin/sanchala-photo-import
# Import photos from connected phone via KDE Connect
# ============================================================================

set -euo pipefail

IMPORT_DIR="${1:-$HOME/Pictures/Phone}"
DEVICE_ID="${2:-}"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}═══ Sanchala Phone Photo Import ═══${NC}"

# Find device
if [[ -z "$DEVICE_ID" ]]; then
    echo "Available devices:"
    kdeconnect-cli --list-available
    read -p "Enter device ID: " DEVICE_ID
fi

# Check device is reachable
if ! kdeconnect-cli --ping --device "$DEVICE_ID" &>/dev/null; then
    echo -e "${YELLOW}Device not reachable${NC}"
    exit 1
fi

# Mount phone storage
MOUNT_POINT="$HOME/Phone/$DEVICE_ID"
mkdir -p "$MOUNT_POINT"

echo "Mounting phone storage..."
kdeconnect-cli --device "$DEVICE_ID" --share-mount "$MOUNT_POINT" 2>/dev/null || true

# Find and copy photos
PHONE_DCIM="$MOUNT_POINT/DCIM"
if [[ -d "$PHONE_DCIM" ]]; then
    mkdir -p "$IMPORT_DIR"
    
    echo "Importing photos to $IMPORT_DIR..."
    find "$PHONE_DCIM" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.heic" -o -iname "*.mp4" -o -iname "*.mov" \) -newer "$IMPORT_DIR/.last_import" 2>/dev/null | while read -r photo; do
        filename=$(basename "$photo")
        if [[ ! -f "$IMPORT_DIR/$filename" ]]; then
            cp "$photo" "$IMPORT_DIR/"
            echo -e "${GREEN}Imported:${NC} $filename"
        fi
    done
    
    touch "$IMPORT_DIR/.last_import"
    echo -e "${GREEN}Import complete!${NC}"
else
    echo -e "${YELLOW}DCIM folder not found. Is phone mounted?${NC}"
fi
