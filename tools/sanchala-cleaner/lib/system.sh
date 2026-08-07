#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0
# Sanchala Cleaner - System utility functions

# Get size of directory in bytes
get_dir_size() {
    local dir="$1"
    du -sb "$dir" 2>/dev/null | cut -f1 || echo 0
}

# Check if running low on disk space
is_disk_critical() {
    local threshold="${1:-90}"
    local usage=$(df / | awk 'NR==2 {gsub(/%/,""); print $5}')
    (( usage >= threshold ))
}

# Find large files
find_large_files() {
    local path="${1:-/}" min_size="${2:-100M}" limit="${3:-20}"
    
    echo "Files larger than $min_size in $path:"
    find "$path" -type f -size +"$min_size" -exec ls -lh {} \; 2>/dev/null | \
        awk '{print $5, $9}' | sort -rh | head -"$limit"
}

# Find old files
find_old_files() {
    local path="${1:-/home}" days="${2:-365}" limit="${3:-20}"
    
    echo "Files not accessed in $days days:"
    find "$path" -type f -atime +"$days" -size +10M 2>/dev/null | \
        xargs -I{} ls -lh {} 2>/dev/null | \
        awk '{print $5, $6, $7, $9}' | head -"$limit"
}

# Estimate space savings
estimate_cleanup() {
    local total=0
    
    # Package cache estimate
    if [[ -d /var/cache/pacman/pkg ]]; then
        local pkg_old=$(find /var/cache/pacman/pkg -name "*.pkg.tar.*" | wc -l)
        total=$((total + pkg_old * 50000000))  # ~50MB per package estimate
    fi
    
    # Journal estimate
    local journal=$(journalctl --disk-usage 2>/dev/null | grep -oP '\d+\.?\d*G' | head -1)
    [[ "$journal" =~ ([0-9.]+) ]] && total=$((total + ${BASH_REMATCH[1]%.*} * 500000000))
    
    # Trash estimate
    for home in /home/*; do
        [[ -d "$home/.local/share/Trash" ]] && \
            total=$((total + $(get_dir_size "$home/.local/share/Trash")))
    done
    
    # Thumbnails
    for home in /home/*; do
        [[ -d "$home/.cache/thumbnails" ]] && \
            total=$((total + $(get_dir_size "$home/.cache/thumbnails")))
    done
    
    echo $total
}
