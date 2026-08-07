#!/bin/bash
# ============================================================================
# SANCHALA OS - Device Sync Service Manager
# ============================================================================
# Location: /usr/local/bin/sanchala-sync
# Unified device sync management utility
# ============================================================================

set -euo pipefail

SCRIPT_NAME="sanchala-sync"
VERSION="1.0.0"

# Configuration paths
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/sanchala/sync"
DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/sanchala/sync"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/sanchala/sync"
LOG_FILE="$DATA_DIR/sync.log"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

log() {
    local level="$1"; shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$level] $message" >> "$LOG_FILE"
    case "$level" in
        INFO)  echo -e "${GREEN}[INFO]${NC} $message" ;;
        WARN)  echo -e "${YELLOW}[WARN]${NC} $message" ;;
        ERROR) echo -e "${RED}[ERROR]${NC} $message" ;;
    esac
}

ensure_dirs() { mkdir -p "$CONFIG_DIR" "$DATA_DIR" "$CACHE_DIR"; }

# KDE Connect functions
kdeconnect_status() {
    echo -e "${BLUE}═══ KDE Connect Status ═══${NC}"
    kdeconnect-cli --list-devices 2>/dev/null || echo "No devices found"
    echo ""; kdeconnect-cli --list-available 2>/dev/null || true
}

kdeconnect_pair() {
    local device_id="${1:-}"
    [[ -z "$device_id" ]] && { kdeconnect-cli --list-available; read -p "Device ID: " device_id; }
    kdeconnect-cli --pair --device "$device_id"
    log INFO "Pairing request sent to $device_id"
}

kdeconnect_ring() {
    kdeconnect-cli --ring --device "$1"
    log INFO "Ring command sent to $1"
}

kdeconnect_share() {
    [[ -f "$2" ]] && kdeconnect-cli --share "$2" --device "$1" && log INFO "Shared $2" || log ERROR "File not found: $2"
}

kdeconnect_sms() {
    kdeconnect-cli --send-sms "$3" --destination "$2" --device "$1"
    log INFO "SMS sent to $2"
}

# Syncthing functions
syncthing_status() {
    echo -e "${BLUE}═══ Syncthing Status ═══${NC}"
    if systemctl --user is-active syncthing &>/dev/null; then
        echo -e "Service: ${GREEN}Running${NC}"
        local api_key=$(grep -oP '(?<=<apikey>)[^<]+' ~/.config/syncthing/config.xml 2>/dev/null)
        [[ -n "$api_key" ]] && curl -s -H "X-API-Key: $api_key" http://127.0.0.1:8384/rest/config/folders 2>/dev/null | jq -r '.[] | "  - \(.label): \(.path)"' 2>/dev/null
    else
        echo -e "Service: ${RED}Stopped${NC}"
    fi
}

syncthing_start() { systemctl --user start syncthing && log INFO "Syncthing started"; }
syncthing_stop() { systemctl --user stop syncthing && log INFO "Syncthing stopped"; }
syncthing_gui() { xdg-open "http://127.0.0.1:8384" &>/dev/null & }

show_status() {
    echo -e "${BLUE}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║     SANCHALA OS - Device Sync Status         ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════╝${NC}"
    echo ""; kdeconnect_status; echo ""; syncthing_status
}

usage() {
    cat << EOF
${CYAN}Sanchala Device Sync Manager v${VERSION}${NC}

Usage: $SCRIPT_NAME <command> [options]

Commands:
  status                Show all sync services status
  kdc status|pair|ring|share|sms  KDE Connect commands
  st status|start|stop|gui        Syncthing commands
EOF
}

main() {
    ensure_dirs
    case "${1:-}" in
        status) show_status ;;
        kdc) case "${2:-status}" in
            status) kdeconnect_status ;; pair) kdeconnect_pair "${3:-}" ;;
            ring) kdeconnect_ring "${3:?Device ID required}" ;;
            share) kdeconnect_share "${3:?Device ID}" "${4:?File}" ;;
            sms) kdeconnect_sms "${3:?Device}" "${4:?Phone}" "${5:?Msg}" ;;
            *) usage ;; esac ;;
        st) case "${2:-status}" in
            status) syncthing_status ;; start) syncthing_start ;;
            stop) syncthing_stop ;; gui) syncthing_gui ;;
            *) usage ;; esac ;;
        *) usage ;;
    esac
}

main "$@"
