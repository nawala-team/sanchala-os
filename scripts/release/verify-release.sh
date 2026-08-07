#!/bin/bash
# ══════════════════════════════════════════════════════════════════════════════
# SANCHALA OS - Release Verification Script
# ══════════════════════════════════════════════════════════════════════════════
# Performs automated verification checks on built ISO
# Usage: ./verify-release.sh <path-to-iso>

set -euo pipefail

ISO="${1:-}"
REPORT_DIR="${2:-./verification-report}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

PASS=0
FAIL=0
WARN=0

log_pass() { echo -e "${GREEN}[PASS]${NC} $1"; ((PASS++)); }
log_fail() { echo -e "${RED}[FAIL]${NC} $1"; ((FAIL++)); }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; ((WARN++)); }
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }

print_banner() {
    echo -e "${BLUE}"
    echo "══════════════════════════════════════════════════════════════"
    echo "       SANCHALA OS - Release Verification"
    echo "══════════════════════════════════════════════════════════════"
    echo -e "${NC}"
}

usage() {
    echo "Usage: $0 <iso-file> [report-dir]"
    echo "  iso-file    Path to Sanchala OS ISO"
    echo "  report-dir  Output directory for report (default: ./verification-report)"
    exit 1
}

verify_iso_exists() {
    log_info "Checking ISO file..."
    if [[ -f "$ISO" ]]; then
        log_pass "ISO file exists: $ISO"
        SIZE=$(stat -c%s "$ISO" | numfmt --to=iec)
        log_info "ISO size: $SIZE"
    else
        log_fail "ISO file not found: $ISO"
        exit 1
    fi
}

verify_iso_size() {
    log_info "Verifying ISO size..."
    SIZE_BYTES=$(stat -c%s "$ISO")
    SIZE_GB=$(echo "scale=2; $SIZE_BYTES / 1024 / 1024 / 1024" | bc)
    
    if (( $(echo "$SIZE_GB >= 2.0" | bc -l) )) && (( $(echo "$SIZE_GB <= 5.0" | bc -l) )); then
        log_pass "ISO size within expected range: ${SIZE_GB}GB"
    else
        log_warn "ISO size outside expected range: ${SIZE_GB}GB (expected 2-5GB)"
    fi
}

verify_iso_type() {
    log_info "Verifying ISO type..."
    FILE_TYPE=$(file -b "$ISO")
    if [[ "$FILE_TYPE" == *"ISO 9660"* ]]; then
        log_pass "Valid ISO 9660 image"
    else
        log_fail "Not a valid ISO 9660 image: $FILE_TYPE"
    fi
}

generate_checksums() {
    log_info "Generating checksums..."
    mkdir -p "$REPORT_DIR"
    
    sha256sum "$ISO" > "$REPORT_DIR/$(basename "$ISO").sha256"
    log_pass "SHA256: $(cat "$REPORT_DIR/$(basename "$ISO").sha256" | cut -d' ' -f1)"
    
    sha512sum "$ISO" > "$REPORT_DIR/$(basename "$ISO").sha512"
    log_pass "SHA512 generated"
    
    if command -v b2sum &>/dev/null; then
        b2sum "$ISO" > "$REPORT_DIR/$(basename "$ISO").b2sum"
        log_pass "BLAKE2 generated"
    else
        log_warn "b2sum not available, skipping BLAKE2"
    fi
}

verify_iso_structure() {
    log_info "Verifying ISO structure..."
    MOUNT_POINT=$(mktemp -d)
    
    if sudo mount -o loop,ro "$ISO" "$MOUNT_POINT" 2>/dev/null; then
        # Check required paths
        REQUIRED_PATHS=(
            "arch/x86_64/airootfs.sfs"
            "arch/boot/x86_64/vmlinuz-linux"
            "arch/boot/x86_64/initramfs-linux.img"
        )
        
        for path in "${REQUIRED_PATHS[@]}"; do
            if [[ -e "$MOUNT_POINT/$path" ]]; then
                log_pass "Found: $path"
            else
                log_fail "Missing: $path"
            fi
        done
        
        # Check UEFI boot
        if [[ -f "$MOUNT_POINT/EFI/BOOT/BOOTX64.EFI" ]]; then
            log_pass "UEFI bootloader present"
        else
            log_fail "UEFI bootloader missing"
        fi
        
        # Check BIOS boot
        if [[ -f "$MOUNT_POINT/isolinux/isolinux.bin" ]]; then
            log_pass "BIOS bootloader present"
        else
            log_warn "BIOS bootloader missing (UEFI-only ISO?)"
        fi
        
        sudo umount "$MOUNT_POINT"
    else
        log_fail "Could not mount ISO for verification"
    fi
    
    rmdir "$MOUNT_POINT" 2>/dev/null || true
}

generate_report() {
    log_info "Generating verification report..."
    REPORT="$REPORT_DIR/verification-report.txt"
    
    {
        echo "═══════════════════════════════════════════════════════════"
        echo "  SANCHALA OS ISO VERIFICATION REPORT"
        echo "═══════════════════════════════════════════════════════════"
        echo ""
        echo "ISO: $(basename "$ISO")"
        echo "Date: $(date -Iseconds)"
        echo "Verified by: $(whoami)@$(hostname)"
        echo ""
        echo "── Results ──"
        echo "Passed: $PASS"
        echo "Failed: $FAIL"
        echo "Warnings: $WARN"
        echo ""
        echo "── File Info ──"
        ls -lh "$ISO"
        echo ""
        echo "── Checksums ──"
        cat "$REPORT_DIR"/*.sha256 2>/dev/null || echo "N/A"
        echo ""
        echo "═══════════════════════════════════════════════════════════"
        if [[ $FAIL -eq 0 ]]; then
            echo "  ✓ VERIFICATION PASSED"
        else
            echo "  ✗ VERIFICATION FAILED"
        fi
        echo "═══════════════════════════════════════════════════════════"
    } | tee "$REPORT"
}

# Main
[[ -z "$ISO" ]] && usage
print_banner

verify_iso_exists
verify_iso_size
verify_iso_type
generate_checksums
verify_iso_structure
generate_report

echo ""
if [[ $FAIL -eq 0 ]]; then
    echo -e "${GREEN}Verification complete: $PASS passed, $WARN warnings${NC}"
    exit 0
else
    echo -e "${RED}Verification failed: $FAIL failures${NC}"
    exit 1
fi
