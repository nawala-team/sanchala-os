#!/bin/bash
# Sanchala Browser Build Script
# Copyright 2024 Sanchala OS Project

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BROWSER_DIR="$(dirname "$SCRIPT_DIR")"
BUILD_TYPE="${1:-Release}"
JOBS="${2:-$(nproc)}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() { echo -e "${GREEN}[SANCHALA]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# Check dependencies
check_deps() {
    log "Checking build dependencies..."
    
    local deps=(git python3 ninja gn clang++ pkg-config)
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            error "Missing dependency: $dep"
        fi
    done
    
    log "All dependencies found"
}

# Fetch Chromium source (or use cached)
fetch_source() {
    log "Setting up Chromium source..."
    
    if [ ! -d "$BROWSER_DIR/chromium/src" ]; then
        mkdir -p "$BROWSER_DIR/chromium"
        cd "$BROWSER_DIR/chromium"
        
        log "Fetching depot_tools..."
        if [ ! -d "depot_tools" ]; then
            git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
        fi
        export PATH="$BROWSER_DIR/chromium/depot_tools:$PATH"
        
        log "Fetching Chromium (this may take a while)..."
        fetch --no-history chromium
    fi
}

# Apply Sanchala patches
apply_patches() {
    log "Applying Sanchala patches..."
    
    cd "$BROWSER_DIR/chromium/src"
    
    # Apply branding patches
    if [ -d "$BROWSER_DIR/patches" ]; then
        for patch in "$BROWSER_DIR/patches"/*.patch; do
            if [ -f "$patch" ]; then
                log "Applying $(basename "$patch")..."
                git apply "$patch" || warn "Patch may already be applied: $patch"
            fi
        done
    fi
    
    log "Patches applied"
}

# Configure build
configure_build() {
    log "Configuring build for $BUILD_TYPE..."
    
    cd "$BROWSER_DIR/chromium/src"
    
    local args=""
    args+="is_official_build=true "
    args+="is_debug=false "
    args+="target_cpu=\"x64\" "
    args+="enable_nacl=false "
    args+="blink_symbol_level=0 "
    args+="symbol_level=0 "
    
    # Sanchala-specific args
    args+="chrome_pgo_phase=0 "
    args+="is_component_build=false "
    args+="use_sysroot=true "
    args+="use_qt=true "
    
    # Security hardening
    args+="is_cfi=true "
    args+="use_cfi_cast=true "
    args+="use_cfi_icall=true "
    args+="use_cfi_diag=false "
    
    # Branding
    args+="sanchala_product_name=\"Sanchala\" "
    args+="sanchala_version=\"1.0.0\" "
    
    gn gen "out/$BUILD_TYPE" --args="$args"
    
    log "Build configured"
}

# Build browser
build_browser() {
    log "Building Sanchala Browser..."
    
    cd "$BROWSER_DIR/chromium/src"
    
    ninja -C "out/$BUILD_TYPE" sanchala -j"$JOBS"
    
    log "Build complete"
}

# Package
package_browser() {
    log "Packaging Sanchala Browser..."
    
    local out_dir="$BROWSER_DIR/chromium/src/out/$BUILD_TYPE"
    local pkg_dir="$BROWSER_DIR/dist/sanchala-browser"
    
    mkdir -p "$pkg_dir"
    
    # Copy binaries
    cp "$out_dir/sanchala" "$pkg_dir/"
    cp -r "$out_dir/locales" "$pkg_dir/"
    cp "$out_dir"/*.pak "$pkg_dir/"
    cp "$out_dir"/*.bin "$pkg_dir/" 2>/dev/null || true
    cp "$out_dir/icudtl.dat" "$pkg_dir/"
    
    # Copy branding
    cp -r "$BROWSER_DIR/branding/icons" "$pkg_dir/"
    
    log "Package created at $pkg_dir"
}

# Main
main() {
    log "Sanchala Browser Build System"
    log "=============================="
    
    check_deps
    
    case "${1:-build}" in
        fetch)   fetch_source ;;
        patch)   apply_patches ;;
        config)  configure_build ;;
        build)   build_browser ;;
        package) package_browser ;;
        all)
            fetch_source
            apply_patches
            configure_build
            build_browser
            package_browser
            ;;
        *)
            echo "Usage: $0 {fetch|patch|config|build|package|all} [Release|Debug] [jobs]"
            exit 1
            ;;
    esac
    
    log "Done!"
}

main "$@"
