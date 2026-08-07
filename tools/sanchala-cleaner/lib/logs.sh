#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0
# Sanchala Cleaner - Log management functions

# Clean systemd journal
clean_journal() {
    local dry_run="${1:-false}" max_size="${2:-500M}"
    local freed=0
    
    if ! command -v journalctl &>/dev/null; then
        echo 0
        return
    fi
    
    local before=$(journalctl --disk-usage 2>/dev/null | grep -oP '\d+\.?\d*[MGK]' | head -1)
    
    if ! $dry_run; then
        journalctl --vacuum-size="$max_size" 2>/dev/null || true
    fi
    
    # Estimate freed space (rough calculation)
    local after=$(journalctl --disk-usage 2>/dev/null | grep -oP '\d+\.?\d*[MGK]' | head -1)
    
    # Convert to bytes for comparison (simplified)
    local before_bytes=0 after_bytes=0
    [[ "$before" =~ ([0-9.]+)G ]] && before_bytes=$(( ${BASH_REMATCH[1]%.*} * 1073741824 ))
    [[ "$before" =~ ([0-9.]+)M ]] && before_bytes=$(( ${BASH_REMATCH[1]%.*} * 1048576 ))
    [[ "$after" =~ ([0-9.]+)G ]] && after_bytes=$(( ${BASH_REMATCH[1]%.*} * 1073741824 ))
    [[ "$after" =~ ([0-9.]+)M ]] && after_bytes=$(( ${BASH_REMATCH[1]%.*} * 1048576 ))
    
    freed=$((before_bytes - after_bytes))
    (( freed < 0 )) && freed=0
    
    echo $freed
}

# Rotate application logs
rotate_logs() {
    local dry_run="${1:-false}"
    
    # Force logrotate run
    if ! $dry_run && command -v logrotate &>/dev/null; then
        logrotate -f /etc/logrotate.conf 2>/dev/null || true
    fi
    
    # Clean old rotated logs
    local log_dirs=("/var/log")
    
    for log_dir in "${log_dirs[@]}"; do
        [[ -d "$log_dir" ]] || continue
        
        if ! $dry_run; then
            # Remove .gz logs older than 30 days
            find "$log_dir" -name "*.gz" -mtime +30 -delete 2>/dev/null || true
            find "$log_dir" -name "*.old" -mtime +30 -delete 2>/dev/null || true
            find "$log_dir" -name "*.[0-9]" -mtime +30 -delete 2>/dev/null || true
        fi
    done
    
    echo "Log rotation complete"
}

# Clean coredumps
clean_coredumps() {
    local dry_run="${1:-false}"
    local freed=0
    
    local coredump_dir="/var/lib/systemd/coredump"
    
    if [[ -d "$coredump_dir" ]]; then
        local before=$(du -sb "$coredump_dir" 2>/dev/null | cut -f1 || echo 0)
        
        if ! $dry_run; then
            find "$coredump_dir" -type f -mtime +7 -delete 2>/dev/null || true
        fi
        
        local after=$(du -sb "$coredump_dir" 2>/dev/null | cut -f1 || echo 0)
        freed=$((before - after))
    fi
    
    (( freed < 0 )) && freed=0
    echo $freed
}
