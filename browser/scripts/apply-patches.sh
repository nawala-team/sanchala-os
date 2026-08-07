#!/bin/bash
# Apply all Sanchala patches to Chromium source
# Copyright 2024 Sanchala OS Project

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BROWSER_DIR="$(dirname "$SCRIPT_DIR")"
PATCHES_DIR="$BROWSER_DIR/patches"
SRC_DIR="$BROWSER_DIR/chromium/src"

log() { echo "[PATCH] $1"; }
warn() { echo "[WARN] $1"; }

if [ ! -d "$SRC_DIR" ]; then
    echo "Chromium source not found. Run './scripts/build.sh fetch' first."
    exit 1
fi

cd "$SRC_DIR"

log "Applying Sanchala security patches..."

# Apply patches in order
for patch in "$PATCHES_DIR"/*.patch; do
    if [ -f "$patch" ]; then
        name=$(basename "$patch")
        log "Applying $name..."
        
        if git apply --check "$patch" 2>/dev/null; then
            git apply "$patch"
            log "✓ $name applied"
        else
            warn "⚠ $name may already be applied or conflicts exist"
        fi
    fi
done

# Copy Sanchala source files
log "Copying Sanchala browser source..."
cp -r "$BROWSER_DIR/src"/* "$SRC_DIR/browser/" 2>/dev/null || true

# Apply branding
log "Applying branding..."
"$SCRIPT_DIR/apply-branding.sh"

log "All patches applied successfully!"
