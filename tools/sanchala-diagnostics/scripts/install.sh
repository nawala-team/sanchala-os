#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0
# Sanchala Diagnostics - Installation script

set -euo pipefail

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
PREFIX="${PREFIX:-/usr}"
SYSCONFDIR="${SYSCONFDIR:-/etc}"

echo "Installing Sanchala Diagnostics..."

# Create directories
sudo mkdir -p "$PREFIX/bin"
sudo mkdir -p "$PREFIX/lib/sanchala/diagnostics"
sudo mkdir -p "$SYSCONFDIR/sanchala/diagnostics"
sudo mkdir -p /var/lib/sanchala/diagnostics
sudo mkdir -p /var/log/sanchala

# Install main binary
sudo install -Dm755 "$SCRIPT_DIR/sanchala-diagnostics" "$PREFIX/bin/sanchala-diagnostics"

# Install libraries
for lib in system process disk network hardware; do
    sudo install -Dm644 "$SCRIPT_DIR/lib/${lib}.sh" "$PREFIX/lib/sanchala/diagnostics/${lib}.sh"
done

# Install configuration
sudo install -Dm644 "$SCRIPT_DIR/config/diagnostics.toml" "$SYSCONFDIR/sanchala/diagnostics/diagnostics.toml"
sudo install -Dm644 "$SCRIPT_DIR/config/btop.conf" "$SYSCONFDIR/sanchala/diagnostics/btop.conf"

# Install btop theme for user
if [[ -n "${HOME:-}" ]]; then
    mkdir -p "$HOME/.config/btop/themes"
    cp "$SCRIPT_DIR/config/btop.conf" "$HOME/.config/btop/btop.conf" 2>/dev/null || true
fi

# Update library path in main script
sudo sed -i "s|SCRIPT_DIR=.*|SCRIPT_DIR=\"$PREFIX/lib/sanchala/diagnostics\"|" "$PREFIX/bin/sanchala-diagnostics"

echo "✓ Sanchala Diagnostics installed successfully!"
echo ""
echo "Usage: sanchala-diagnostics [command]"
echo "Run 'sanchala-diagnostics --help' for available commands"
