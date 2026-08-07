#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0
# Sanchala Cleaner - Cache management functions

# Clean package cache using paccache
# Returns bytes freed
clean_package_cache() {
    local dry_run="${1:-false}" keep="${2:-2}"
    local freed=0
    
    if ! command -v paccache &>/dev/null; then
        echo 0
        return
    fi
    
    local before=$(du -sb /var/cache/pacman/pkg 2>/dev/null | cut -f1 || echo 0)
    
    if $dry_run; then
        paccache -dk"$keep" 2>/dev/null || true
    else
        paccache -rk"$keep" 2>/dev/null || true
    fi
    
    local after=$(du -sb /var/cache/pacman/pkg 2>/dev/null | cut -f1 || echo 0)
    freed=$((before - after))
    (( freed < 0 )) && freed=0
    
    echo $freed
}

# Clean thumbnail cache
clean_thumbnails() {
    local dry_run="${1:-false}" max_age="${2:-30}"
    local freed=0
    
    for user_home in /home/* /root; do
        local thumb_dir="$user_home/.cache/thumbnails"
        [[ -d "$thumb_dir" ]] || continue
        
        local before=$(du -sb "$thumb_dir" 2>/dev/null | cut -f1 || echo 0)
        
        if ! $dry_run; then
            find "$thumb_dir" -type f -atime +"$max_age" -delete 2>/dev/null || true
            # Remove empty directories
            find "$thumb_dir" -type d -empty -delete 2>/dev/null || true
        fi
        
        local after=$(du -sb "$thumb_dir" 2>/dev/null | cut -f1 || echo 0)
        freed=$((freed + before - after))
    done
    
    (( freed < 0 )) && freed=0
    echo $freed
}

# Clean browser caches
clean_browser_cache() {
    local dry_run="${1:-false}"
    local freed=0
    
    local cache_dirs=(
        ".cache/mozilla/firefox"
        ".cache/chromium"
        ".cache/google-chrome"
        ".cache/BraveSoftware"
        ".cache/vivaldi"
        ".mozilla/firefox/*/cache2"
        ".config/chromium/*/Cache"
        ".config/google-chrome/*/Cache"
    )
    
    for user_home in /home/*; do
        for pattern in "${cache_dirs[@]}"; do
            for cache_dir in "$user_home"/$pattern; do
                [[ -d "$cache_dir" ]] || continue
                
                local before=$(du -sb "$cache_dir" 2>/dev/null | cut -f1 || echo 0)
                
                if ! $dry_run; then
                    rm -rf "$cache_dir"/* 2>/dev/null || true
                fi
                
                local after=$(du -sb "$cache_dir" 2>/dev/null | cut -f1 || echo 0)
                freed=$((freed + before - after))
            done
        done
    done
    
    (( freed < 0 )) && freed=0
    echo $freed
}

# Clean trash
clean_trash() {
    local dry_run="${1:-false}" max_age="${2:-30}"
    local freed=0
    
    for user_home in /home/* /root; do
        local trash_dir="$user_home/.local/share/Trash"
        [[ -d "$trash_dir" ]] || continue
        
        local before=$(du -sb "$trash_dir" 2>/dev/null | cut -f1 || echo 0)
        
        if ! $dry_run; then
            if (( max_age == 0 )); then
                # Empty all trash
                rm -rf "$trash_dir/files"/* "$trash_dir/info"/* 2>/dev/null || true
            else
                # Only old items
                find "$trash_dir/files" -mindepth 1 -mtime +"$max_age" -delete 2>/dev/null || true
                find "$trash_dir/info" -mindepth 1 -mtime +"$max_age" -delete 2>/dev/null || true
            fi
        fi
        
        local after=$(du -sb "$trash_dir" 2>/dev/null | cut -f1 || echo 0)
        freed=$((freed + before - after))
    done
    
    (( freed < 0 )) && freed=0
    echo $freed
}

# Clean temporary files
clean_temp() {
    local dry_run="${1:-false}"
    local freed=0
    
    local temp_dirs=("/tmp" "/var/tmp")
    
    for tmp in "${temp_dirs[@]}"; do
        [[ -d "$tmp" ]] || continue
        
        local before=$(du -sb "$tmp" 2>/dev/null | cut -f1 || echo 0)
        
        if ! $dry_run; then
            # Only clean files older than 7 days, preserve directory
            find "$tmp" -mindepth 1 -type f -atime +7 -delete 2>/dev/null || true
            find "$tmp" -mindepth 1 -type d -empty -delete 2>/dev/null || true
        fi
        
        local after=$(du -sb "$tmp" 2>/dev/null | cut -f1 || echo 0)
        freed=$((freed + before - after))
    done
    
    (( freed < 0 )) && freed=0
    echo $freed
}
