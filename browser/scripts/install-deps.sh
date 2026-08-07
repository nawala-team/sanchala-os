#!/bin/bash
# Install build dependencies for Sanchala Browser
# Copyright 2024 Sanchala OS Project

set -e

log() { echo "[DEPS] $1"; }

# Detect package manager
if command -v pacman &> /dev/null; then
    PM="pacman"
    INSTALL="pacman -S --noconfirm"
elif command -v apt &> /dev/null; then
    PM="apt"
    INSTALL="apt install -y"
elif command -v dnf &> /dev/null; then
    PM="dnf"
    INSTALL="dnf install -y"
else
    echo "Unsupported package manager"
    exit 1
fi

log "Using package manager: $PM"

# Common dependencies
COMMON_DEPS=(
    git
    python3
    ninja
    cmake
    clang
    lld
    pkg-config
    nodejs
    npm
)

# Arch Linux specific
ARCH_DEPS=(
    base-devel
    gn
    libxss
    nss
    alsa-lib
    pulseaudio
    libcups
    gtk3
    qt5-base
    qt6-base
)

# Debian/Ubuntu specific  
DEB_DEPS=(
    build-essential
    libx11-dev
    libxss-dev
    libnss3-dev
    libasound2-dev
    libpulse-dev
    libcups2-dev
    libgtk-3-dev
    qtbase5-dev
    qt6-base-dev
)

log "Installing common dependencies..."
sudo $INSTALL "${COMMON_DEPS[@]}"

case $PM in
    pacman)
        log "Installing Arch-specific dependencies..."
        sudo $INSTALL "${ARCH_DEPS[@]}"
        ;;
    apt)
        log "Installing Debian/Ubuntu dependencies..."
        sudo $INSTALL "${DEB_DEPS[@]}"
        ;;
esac

# Install depot_tools
if [ ! -d "$HOME/depot_tools" ]; then
    log "Installing depot_tools..."
    git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git "$HOME/depot_tools"
    echo 'export PATH="$HOME/depot_tools:$PATH"' >> ~/.bashrc
fi

log "Dependencies installed successfully!"
