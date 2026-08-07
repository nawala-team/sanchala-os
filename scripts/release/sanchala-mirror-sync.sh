#!/bin/bash
# ══════════════════════════════════════════════════════════════════════════════
# SANCHALA OS - Mirror Sync Script
# ══════════════════════════════════════════════════════════════════════════════
# For mirror operators to sync from upstream
# Usage: sanchala-mirror-sync [--check-only]

set -euo pipefail

# Configuration
UPSTREAM="${SANCHALA_UPSTREAM:-rsync://rsync.sanchala.id/sanchala}"
LOCAL="${SANCHALA_MIRROR_PATH:-/srv/mirror/sanchala}"
LOCK="/var/lock/sanchala-sync.lock"
LOG="/var/log/sanchala-sync.log"
BANDWIDTH="${SANCHALA_BANDWIDTH:-0}"  # 0 = unlimited, otherwise KB/s

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() {
    echo "[$(date -Iseconds)] $*" | tee -a "$LOG"
}

check_requirements() {
    if ! command -v rsync &>/dev/null; then
        echo -e "${RED}Error: rsync is required${NC}"
        exit 1
    fi
}

acquire_lock() {
    exec 200>"$LOCK"
    if ! flock -n 200; then
        echo -e "${YELLOW}Sync already in progress${NC}"
        exit 0
    fi
}

sync_mirror() {
    local start_time end_time duration
    start_time=$(date +%s)
    
    log "Starting sync from $UPSTREAM"
    
    RSYNC_OPTS=(
        -avz
        --delete
        --delay-updates
        --safe-links
        --timeout=600
        --contimeout=60
        --exclude='*.tmp'
        --exclude='.~tmp~'
    )
    
    # Add bandwidth limit if set
    if [[ "$BANDWIDTH" -gt 0 ]]; then
        RSYNC_OPTS+=(--bwlimit="$BANDWIDTH")
    fi
    
    if rsync "${RSYNC_OPTS[@]}" "$UPSTREAM/" "$LOCAL/" >> "$LOG" 2>&1; then
        log "Sync completed successfully"
        
        # Update timestamp
        date -Iseconds > "$LOCAL/lastsync"
        
        # Update status file
        cat > "$LOCAL/STATUS" << EOF
mirror_status: online
last_sync: $(date -Iseconds)
upstream: $UPSTREAM
sync_duration: $(($(date +%s) - start_time))s
EOF
        
        end_time=$(date +%s)
        duration=$((end_time - start_time))
        echo -e "${GREEN}✓ Sync complete in ${duration}s${NC}"
    else
        log "Sync failed with exit code $?"
        echo -e "${RED}✗ Sync failed - check $LOG${NC}"
        exit 1
    fi
}

check_upstream() {
    echo "Checking upstream availability..."
    if rsync --list-only "$UPSTREAM/" &>/dev/null; then
        echo -e "${GREEN}✓ Upstream reachable${NC}"
        
        # Show last upstream update
        echo ""
        echo "Upstream contents:"
        rsync --list-only "$UPSTREAM/" | head -10
    else
        echo -e "${RED}✗ Cannot reach upstream${NC}"
        exit 1
    fi
}

show_status() {
    echo -e "${BLUE}Sanchala OS Mirror Status${NC}"
    echo ""
    echo "Configuration:"
    echo "  Upstream: $UPSTREAM"
    echo "  Local:    $LOCAL"
    echo "  Log:      $LOG"
    echo ""
    
    if [[ -f "$LOCAL/lastsync" ]]; then
        echo "Last sync: $(cat "$LOCAL/lastsync")"
    else
        echo "Last sync: Never"
    fi
    
    if [[ -d "$LOCAL" ]]; then
        echo "Local size: $(du -sh "$LOCAL" 2>/dev/null | cut -f1)"
    fi
}

show_help() {
    cat << 'EOF'
Sanchala OS Mirror Sync

Usage: sanchala-mirror-sync [options]

Options:
  --check-only    Check upstream without syncing
  --status        Show mirror status
  --help          Show this help

Environment Variables:
  SANCHALA_UPSTREAM      Upstream rsync URL
  SANCHALA_MIRROR_PATH   Local mirror path
  SANCHALA_BANDWIDTH     Bandwidth limit in KB/s (0=unlimited)

Setup for cron:
  # Sync every 15 minutes (Tier 1)
  */15 * * * * /usr/local/bin/sanchala-mirror-sync

  # Sync hourly (Tier 2)
  0 * * * * /usr/local/bin/sanchala-mirror-sync
EOF
}

# Main
case "${1:-}" in
    --check-only)
        check_requirements
        check_upstream
        ;;
    --status)
        show_status
        ;;
    --help|-h)
        show_help
        ;;
    "")
        check_requirements
        acquire_lock
        sync_mirror
        ;;
    *)
        echo "Unknown option: $1"
        show_help
        exit 1
        ;;
esac
