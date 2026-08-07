#!/bin/bash
# Apply Sanchala branding to Chromium
# Copyright 2024 Sanchala OS Project

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BROWSER_DIR="$(dirname "$SCRIPT_DIR")"
SRC_DIR="$BROWSER_DIR/chromium/src"

log() { echo "[BRANDING] $1"; }

# Replace Chrome branding with Sanchala
apply_branding() {
    log "Applying Sanchala branding..."
    
    # Update product name
    find "$SRC_DIR/chrome/app" -name "*.grd*" -exec sed -i \
        -e 's/Google Chrome/Sanchala/g' \
        -e 's/Chromium/Sanchala/g' {} \;
    
    # Update about page
    sed -i 's/Chrome/Sanchala/g' "$SRC_DIR/chrome/browser/ui/webui/about_ui.cc" 2>/dev/null || true
    
    # Copy icons
    if [ -d "$BROWSER_DIR/branding/icons" ]; then
        cp "$BROWSER_DIR/branding/icons/sanchala_128.png" \
           "$SRC_DIR/chrome/app/theme/chromium/product_logo_128.png" 2>/dev/null || true
    fi
    
    log "Branding applied"
}

apply_branding
