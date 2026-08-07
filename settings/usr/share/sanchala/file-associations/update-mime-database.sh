#!/bin/bash
# ============================================
# SANCHALA OS - MIME Database Update Script
# ============================================
# Updates the MIME database with Sanchala custom types
# Run after installing or updating MIME definitions
# ============================================

set -e

MIME_DIR="/usr/share/mime"
SANCHALA_MIME_DIR="/usr/share/mime/packages"

echo "=== Sanchala OS MIME Database Update ==="
echo ""

# Check if running as root for system-wide update
if [[ $EUID -ne 0 ]]; then
    echo "Note: Running as user - updating user MIME database only"
    MIME_DIR="$HOME/.local/share/mime"
    mkdir -p "$MIME_DIR/packages"
    
    # Copy Sanchala MIME files to user directory
    if [[ -d "/usr/share/mime/packages" ]]; then
        cp /usr/share/mime/packages/sanchala-*.xml "$MIME_DIR/packages/" 2>/dev/null || true
    fi
fi

# Update MIME database
echo "Updating MIME database..."
if command -v update-mime-database &> /dev/null; then
    update-mime-database "$MIME_DIR"
    echo "✓ MIME database updated successfully"
else
    echo "✗ update-mime-database not found"
    echo "  Install shared-mime-info package"
    exit 1
fi

# Update desktop database
echo "Updating desktop database..."
if command -v update-desktop-database &> /dev/null; then
    if [[ $EUID -eq 0 ]]; then
        update-desktop-database /usr/share/applications
    else
        update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true
    fi
    echo "✓ Desktop database updated successfully"
else
    echo "⚠ update-desktop-database not found (optional)"
fi

# Verify Sanchala MIME types
echo ""
echo "Verifying Sanchala MIME types..."
MIME_TYPES=(
    "application/x-sanchala-config"
    "application/x-sanchala-theme"
    "application/x-sanchala-backup"
    "application/x-sanchala-extension"
)

for mime_type in "${MIME_TYPES[@]}"; do
    if grep -r "$mime_type" "$MIME_DIR" &> /dev/null; then
        echo "✓ $mime_type"
    else
        echo "✗ $mime_type (not found)"
    fi
done

echo ""
echo "=== MIME database update complete ==="
