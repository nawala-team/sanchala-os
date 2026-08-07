#!/bin/bash
# ============================================================================
# SANCHALA OS - Quick Share (AirDrop-like)
# ============================================================================
# Location: /usr/local/bin/sanchala-drop
# Share files with nearby devices instantly
# ============================================================================

set -euo pipefail

FILE="${1:-}"
DEVICE_ID="${2:-}"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

show_devices() {
    echo -e "${BLUE}Available devices:${NC}"
    kdeconnect-cli --list-available 2>/dev/null | while read -r line; do
        echo "  $line"
    done
}

if [[ -z "$FILE" ]]; then
    echo -e "${BLUE}═══ Sanchala Drop ═══${NC}"
    echo "Usage: sanchala-drop <file> [device_id]"
    echo ""
    show_devices
    exit 0
fi

if [[ ! -e "$FILE" ]]; then
    echo -e "${RED}File not found: $FILE${NC}"
    exit 1
fi

# Select device if not specified
if [[ -z "$DEVICE_ID" ]]; then
    show_devices
    echo ""
    read -p "Enter device ID (or part of name): " DEVICE_ID
fi

# Find matching device
MATCHED_DEVICE=$(kdeconnect-cli --list-available 2>/dev/null | grep -i "$DEVICE_ID" | head -1 | awk '{print $3}' | tr -d ':')

if [[ -z "$MATCHED_DEVICE" ]]; then
    MATCHED_DEVICE="$DEVICE_ID"
fi

echo -e "${BLUE}Sharing:${NC} $(basename "$FILE")"
echo -e "${BLUE}To:${NC} $MATCHED_DEVICE"

if kdeconnect-cli --share "$FILE" --device "$MATCHED_DEVICE"; then
    echo -e "${GREEN}✓ File sent successfully${NC}"
    notify-send "Sanchala Drop" "Sent $(basename "$FILE")" -i document-send 2>/dev/null || true
else
    echo -e "${RED}✗ Failed to send file${NC}"
    exit 1
fi
