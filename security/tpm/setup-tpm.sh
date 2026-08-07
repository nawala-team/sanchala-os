#!/bin/bash
# ============================================================================
# SANCHALA OS - TPM 2.0 Setup Script
# ============================================================================
# Version: 2.0
# Run as root after fresh installation
# ============================================================================

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check root
if [[ $EUID -ne 0 ]]; then
    log_error "This script must be run as root"
    exit 1
fi

# Check TPM presence
check_tpm() {
    log_info "Checking TPM 2.0 presence..."
    
    if [[ ! -c /dev/tpm0 ]] && [[ ! -c /dev/tpmrm0 ]]; then
        log_error "TPM device not found. Ensure TPM is enabled in BIOS."
        exit 1
    fi
    
    if command -v tpm2_getcap &> /dev/null; then
        TPM_VERSION=$(tpm2_getcap properties-fixed 2>/dev/null | grep -i "TPM2_PT_FAMILY_INDICATOR" || echo "unknown")
        log_info "TPM detected: $TPM_VERSION"
    else
        log_warn "tpm2-tools not installed, cannot verify TPM version"
    fi
}

# Install required packages
install_packages() {
    log_info "Installing TPM packages..."
    pacman -S --needed --noconfirm \
        tpm2-tss \
        tpm2-tools \
        tpm2-abrmd \
        tpm2-pkcs11 \
        clevis \
        clevis-luks
}

# Enable TPM services
enable_services() {
    log_info "Enabling TPM services..."
    systemctl enable --now tpm2-abrmd.service
}

# Setup LUKS with TPM
setup_luks_tpm() {
    local LUKS_DEVICE="$1"
    
    log_info "Setting up LUKS + TPM for $LUKS_DEVICE..."
    
    # Verify device is LUKS
    if ! cryptsetup isLuks "$LUKS_DEVICE"; then
        log_error "$LUKS_DEVICE is not a LUKS device"
        return 1
    fi
    
    # Enroll TPM
    log_info "Enrolling TPM with PCRs 0,1,2,7,8,9..."
    systemd-cryptenroll "$LUKS_DEVICE" \
        --tpm2-device=auto \
        --tpm2-pcrs=0+1+2+7+8+9
    
    # Generate recovery key
    log_info "Generating recovery key (SAVE THIS SECURELY)..."
    systemd-cryptenroll "$LUKS_DEVICE" --recovery-key
    
    log_info "LUKS + TPM setup complete"
}

# Verify TPM health
verify_tpm() {
    log_info "Verifying TPM health..."
    
    # Test self-test
    tpm2_selftest --full
    
    # Read PCR values
    log_info "Current PCR values:"
    tpm2_pcrread sha256:0,1,2,7,8,9
    
    # Check capabilities
    log_info "TPM Capabilities:"
    tpm2_getcap algorithms | head -20
}

# Main menu
main() {
    echo "============================================"
    echo "SANCHALA OS - TPM 2.0 Setup"
    echo "============================================"
    echo ""
    echo "1) Check TPM presence"
    echo "2) Install TPM packages"
    echo "3) Enable TPM services"
    echo "4) Setup LUKS + TPM auto-unlock"
    echo "5) Verify TPM health"
    echo "6) Full setup (all of the above)"
    echo "0) Exit"
    echo ""
    read -rp "Select option: " choice
    
    case $choice in
        1) check_tpm ;;
        2) install_packages ;;
        3) enable_services ;;
        4)
            read -rp "Enter LUKS device (e.g., /dev/nvme0n1p3): " device
            setup_luks_tpm "$device"
            ;;
        5) verify_tpm ;;
        6)
            check_tpm
            install_packages
            enable_services
            verify_tpm
            log_info "Full setup complete. Run option 4 to enable LUKS auto-unlock."
            ;;
        0) exit 0 ;;
        *) log_error "Invalid option" ;;
    esac
}

main "$@"
