#!/bin/bash
# ============================================
# SANCHALA OS - Browser Download Integration
# ============================================
# Intercepts browser downloads and routes to aria2
# ============================================

set -euo pipefail

SCRIPT_NAME="sanchala-browser-download"
CONFIG_FILE="/etc/sanchala/downloads/downloads.conf"
ARIA2_RPC="http://localhost:6800/jsonrpc"

# Get config value
get_config() {
    grep -E "^${1}=" "$CONFIG_FILE" 2>/dev/null | cut -d= -f2 || echo ""
}

# Get aria2 secret
get_secret() {
    grep -E "^rpc-secret=" /etc/aria2/aria2.conf 2>/dev/null | cut -d= -f2 || echo "sanchala_aria2_secret"
}

# Check if URL should be captured
should_capture() {
    local url="$1"
    local size="${2:-0}"
    
    # Check minimum size threshold
    local min_size
    min_size=$(get_config "min_capture_size")
    min_size=${min_size:-10}
    
    if [[ $size -gt 0 && $size -lt $((min_size * 1024 * 1024)) ]]; then
        return 1
    fi
    
    # Check file extension
    local extensions
    extensions=$(get_config "capture_extensions")
    extensions=${extensions:-.exe,.msi,.deb,.rpm,.AppImage,.tar.gz,.zip,.rar,.7z,.iso,.torrent}
    
    local ext
    for ext in ${extensions//,/ }; do
        if [[ "$url" == *"$ext"* ]]; then
            return 0
        fi
    done
    
    # Large files always captured
    [[ $size -gt $((min_size * 1024 * 1024)) ]] && return 0
    
    return 1
}

# Add download to aria2
add_to_aria2() {
    local url="$1"
    local filename="${2:-}"
    local referer="${3:-}"
    local cookies="${4:-}"
    
    local secret
    secret=$(get_secret)
    
    # Build options
    local options="{}"
    [[ -n "$filename" ]] && options=$(echo "$options" | jq --arg f "$filename" '. + {"out": $f}')
    [[ -n "$referer" ]] && options=$(echo "$options" | jq --arg r "$referer" '. + {"referer": $r}')
    [[ -n "$cookies" ]] && options=$(echo "$options" | jq --arg c "$cookies" '. + {"header": ["Cookie: " + $c]}')
    
    local response
    response=$(curl -s "$ARIA2_RPC" \
         -H "Content-Type: application/json" \
         -d '{"jsonrpc":"2.0","method":"aria2.addUri","id":"browser","params":["token:'"$secret"'",["'"$url"'"],'"$options"']}')
    
    if echo "$response" | grep -q '"result"'; then
        local gid
        gid=$(echo "$response" | jq -r '.result')
        notify-send -i "download" "Download Started" "$(basename "$url")\nGID: $gid" 2>/dev/null || true
        echo "$gid"
        return 0
    else
        notify-send -i "dialog-error" "Download Failed" "Failed to add: $(basename "$url")" 2>/dev/null || true
        return 1
    fi
}

# Handle magnet link
handle_magnet() {
    local magnet="$1"
    
    # Check if qBittorrent is preferred for torrents
    if pgrep -x qbittorrent &>/dev/null; then
        qbittorrent "$magnet" &
        notify-send -i "qbittorrent" "Torrent Added" "Magnet link sent to qBittorrent" 2>/dev/null || true
    else
        add_to_aria2 "$magnet"
    fi
}

# Handle .torrent file
handle_torrent_file() {
    local file="$1"
    
    if pgrep -x qbittorrent &>/dev/null; then
        qbittorrent "$file" &
        notify-send -i "qbittorrent" "Torrent Added" "$(basename "$file")" 2>/dev/null || true
    else
        local secret
        secret=$(get_secret)
        
        local torrent_b64
        torrent_b64=$(base64 -w0 "$file")
        
        curl -s "$ARIA2_RPC" \
             -d '{"jsonrpc":"2.0","method":"aria2.addTorrent","id":"torrent","params":["token:'"$secret"'","'"$torrent_b64"'"]}' \
             &>/dev/null
    fi
}

# Main handler for browser integration
handle_download() {
    local url="$1"
    local filename="${2:-}"
    local size="${3:-0}"
    local referer="${4:-}"
    local cookies="${5:-}"
    
    # Handle magnet links
    if [[ "$url" == magnet:* ]]; then
        handle_magnet "$url"
        return 0
    fi
    
    # Handle torrent files
    if [[ "$url" == *.torrent ]]; then
        # Download torrent file first, then add
        local tmp_torrent="/tmp/$(basename "$url")"
        curl -sL -o "$tmp_torrent" "$url"
        handle_torrent_file "$tmp_torrent"
        rm -f "$tmp_torrent"
        return 0
    fi
    
    # Regular downloads
    if should_capture "$url" "$size"; then
        add_to_aria2 "$url" "$filename" "$referer" "$cookies"
        return 0
    fi
    
    # Let browser handle small files
    return 1
}

# Usage
case "${1:-}" in
    download)
        shift
        handle_download "$@"
        ;;
    magnet)
        handle_magnet "$2"
        ;;
    torrent)
        handle_torrent_file "$2"
        ;;
    *)
        echo "Usage: $SCRIPT_NAME {download|magnet|torrent} <url/file> [filename] [size] [referer] [cookies]"
        exit 1
        ;;
esac
