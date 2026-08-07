#!/bin/bash
# ============================================
# SANCHALA OS - Download Manager Daemon
# ============================================
# Manages aria2 daemon and download scheduling
# ============================================

set -euo pipefail

SCRIPT_NAME="sanchala-download-manager"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/sanchala/downloads"
ARIA2_CONFIG="/etc/aria2/aria2.conf"
ARIA2_SESSION="$CONFIG_DIR/session.txt"
ARIA2_LOG="$CONFIG_DIR/aria2.log"
PID_FILE="$CONFIG_DIR/aria2.pid"
BANDWIDTH_CONFIG="/etc/sanchala/downloads/downloads.conf"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[OK]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Initialize directories
init_dirs() {
    mkdir -p "$CONFIG_DIR"
    mkdir -p "$HOME/Downloads/Torrents/Incomplete"
    mkdir -p "$HOME/Downloads/Incomplete"
    touch "$ARIA2_SESSION"
}

# Start aria2 daemon
start_aria2() {
    if is_aria2_running; then
        log_warn "aria2 is already running (PID: $(cat "$PID_FILE"))"
        return 0
    fi

    init_dirs
    log_info "Starting aria2 daemon..."

    aria2c --conf-path="$ARIA2_CONFIG" \
           --input-file="$ARIA2_SESSION" \
           --save-session="$ARIA2_SESSION" \
           --save-session-interval=60 \
           --log="$ARIA2_LOG" \
           --daemon=true

    sleep 1
    if pgrep -x aria2c > /dev/null; then
        pgrep -x aria2c > "$PID_FILE"
        log_success "aria2 daemon started (PID: $(cat "$PID_FILE"))"
    else
        log_error "Failed to start aria2 daemon"
        return 1
    fi
}

# Stop aria2 daemon
stop_aria2() {
    if ! is_aria2_running; then
        log_warn "aria2 is not running"
        return 0
    fi

    log_info "Stopping aria2 daemon..."
    
    # Graceful shutdown via RPC
    local secret
    secret=$(grep -E "^rpc-secret=" "$ARIA2_CONFIG" | cut -d= -f2)
    
    if command -v curl &>/dev/null; then
        curl -s "http://localhost:6800/jsonrpc" \
             -d '{"jsonrpc":"2.0","method":"aria2.shutdown","id":"shutdown","params":["token:'"$secret"'"]}' \
             &>/dev/null || true
    fi

    sleep 2

    # Force kill if still running
    if is_aria2_running; then
        kill "$(cat "$PID_FILE")" 2>/dev/null || true
        sleep 1
    fi

    rm -f "$PID_FILE"
    log_success "aria2 daemon stopped"
}

# Check if aria2 is running
is_aria2_running() {
    [[ -f "$PID_FILE" ]] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null
}

# Get aria2 status
status_aria2() {
    if is_aria2_running; then
        log_success "aria2 is running (PID: $(cat "$PID_FILE"))"
        
        # Get active downloads via RPC
        local secret
        secret=$(grep -E "^rpc-secret=" "$ARIA2_CONFIG" | cut -d= -f2)
        
        if command -v curl &>/dev/null; then
            echo ""
            echo "Active Downloads:"
            curl -s "http://localhost:6800/jsonrpc" \
                 -d '{"jsonrpc":"2.0","method":"aria2.tellActive","id":"status","params":["token:'"$secret"'"]}' \
                 | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    downloads = data.get('result', [])
    if not downloads:
        print('  No active downloads')
    for d in downloads:
        name = d.get('bittorrent', {}).get('info', {}).get('name', d.get('files', [{}])[0].get('path', 'Unknown').split('/')[-1])
        progress = int(d.get('completedLength', 0)) / max(int(d.get('totalLength', 1)), 1) * 100
        speed = int(d.get('downloadSpeed', 0)) / 1024
        print(f'  {name[:50]}: {progress:.1f}% @ {speed:.1f} KiB/s')
except:
    print('  Unable to fetch download status')
" 2>/dev/null || echo "  Unable to connect to RPC"
        fi
    else
        log_warn "aria2 is not running"
    fi
}

# Add download via RPC
add_download() {
    local url="$1"
    local secret
    secret=$(grep -E "^rpc-secret=" "$ARIA2_CONFIG" | cut -d= -f2)

    if ! is_aria2_running; then
        log_error "aria2 is not running. Start it first."
        return 1
    fi

    log_info "Adding download: $url"
    
    local response
    response=$(curl -s "http://localhost:6800/jsonrpc" \
         -d '{"jsonrpc":"2.0","method":"aria2.addUri","id":"add","params":["token:'"$secret"'",["'"$url"'"]]}')
    
    if echo "$response" | grep -q '"result"'; then
        local gid
        gid=$(echo "$response" | python3 -c "import sys,json; print(json.load(sys.stdin)['result'])" 2>/dev/null)
        log_success "Download added (GID: $gid)"
    else
        log_error "Failed to add download"
        echo "$response"
    fi
}

# Usage
usage() {
    cat << EOF
Sanchala OS Download Manager

Usage: $SCRIPT_NAME <command> [options]

Commands:
  start         Start aria2 daemon
  stop          Stop aria2 daemon
  restart       Restart aria2 daemon
  status        Show daemon status and active downloads
  add <url>     Add a download URL
  pause         Pause all downloads
  resume        Resume all downloads
  
Bandwidth:
  limit <kbps>  Set global download speed limit
  unlimit       Remove speed limit
  schedule      Apply scheduled bandwidth limits

Examples:
  $SCRIPT_NAME start
  $SCRIPT_NAME add "https://example.com/file.zip"
  $SCRIPT_NAME limit 2048
EOF
}

# Main
case "${1:-}" in
    start)
        start_aria2
        ;;
    stop)
        stop_aria2
        ;;
    restart)
        stop_aria2
        sleep 1
        start_aria2
        ;;
    status)
        status_aria2
        ;;
    add)
        [[ -z "${2:-}" ]] && { log_error "URL required"; exit 1; }
        add_download "$2"
        ;;
    *)
        usage
        exit 1
        ;;
esac
