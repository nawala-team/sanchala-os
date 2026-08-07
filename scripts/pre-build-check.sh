#!/bin/bash
#
# SANCHALA OS - Pre-build Checks
# Run this before building ISO to verify everything is ready
#

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║           SANCHALA OS - Pre-build Verification                ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

ERRORS=0
WARNINGS=0

check_file() {
    if [ -f "$1" ]; then
        echo "✓ $2"
    else
        echo "✗ $2 - MISSING!"
        ((ERRORS++))
    fi
}

check_dir() {
    if [ -d "$1" ]; then
        echo "✓ $2"
    else
        echo "✗ $2 - MISSING!"
        ((ERRORS++))
    fi
}

warn_file() {
    if [ -f "$1" ]; then
        echo "✓ $2"
    else
        echo "⚠ $2 - Missing (optional)"
        ((WARNINGS++))
    fi
}

echo "=== Critical Files ==="
check_file "${PROJECT_ROOT}/iso/profiledef.sh" "profiledef.sh"
check_file "${PROJECT_ROOT}/iso/pacman.conf" "pacman.conf"
check_file "${PROJECT_ROOT}/iso/build-binary" "build-binary"
check_file "${PROJECT_ROOT}/iso/grub/grub.cfg" "grub.cfg"
check_file "${PROJECT_ROOT}/iso/syslinux/syslinux.cfg" "syslinux.cfg"

echo ""
echo "=== Package Lists ==="
check_file "${PROJECT_ROOT}/iso/packages/base.list" "base.list"
check_file "${PROJECT_ROOT}/iso/packages/desktop.list" "desktop.list"
check_file "${PROJECT_ROOT}/iso/packages/apps.list" "apps.list"

echo ""
echo "=== Installer ==="
check_file "${PROJECT_ROOT}/installer/settings.conf" "calamares settings.conf"
check_dir "${PROJECT_ROOT}/installer/modules" "calamares modules"
check_dir "${PROJECT_ROOT}/installer/branding" "calamares branding"

echo ""
echo "=== Branding ==="
check_dir "${PROJECT_ROOT}/branding/logos" "logos"
check_dir "${PROJECT_ROOT}/branding/icons" "icons"
check_dir "${PROJECT_ROOT}/branding/plymouth" "plymouth theme"
check_dir "${PROJECT_ROOT}/branding/grub" "grub theme"
check_dir "${PROJECT_ROOT}/branding/sddm" "sddm theme"

echo ""
echo "=== Security ==="
check_dir "${PROJECT_ROOT}/security/apparmor" "apparmor profiles"
check_dir "${PROJECT_ROOT}/security/seccomp" "seccomp policies"

echo ""
echo "=== Airootfs ==="
check_dir "${PROJECT_ROOT}/iso/airootfs/etc" "airootfs/etc"
check_file "${PROJECT_ROOT}/iso/airootfs/root/.automated_script.sh" "automated_script.sh"
warn_file "${PROJECT_ROOT}/iso/airootfs/etc/skel/.config/kdeglobals" "skel kde config"

echo ""
echo "=== EFI Boot ==="
check_file "${PROJECT_ROOT}/iso/efiboot/loader/loader.conf" "loader.conf"
check_dir "${PROJECT_ROOT}/iso/efiboot/loader/entries" "boot entries"

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "RESULTS: $ERRORS errors, $WARNINGS warnings"
echo "═══════════════════════════════════════════════════════════════"

if [ $ERRORS -gt 0 ]; then
    echo ""
    echo "❌ BUILD NOT READY - Please fix errors above!"
    exit 1
else
    echo ""
    echo "✅ BUILD READY - You can proceed with: sudo ./iso/build-binary"
    exit 0
fi
