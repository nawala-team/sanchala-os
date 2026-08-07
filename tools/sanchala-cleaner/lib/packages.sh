#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0
# Sanchala Cleaner - Package management functions

# Clean orphan packages
clean_orphans() {
    local dry_run="${1:-false}"
    
    if ! command -v pacman &>/dev/null; then
        return 0
    fi
    
    local orphans=$(pacman -Qtdq 2>/dev/null)
    
    if [[ -z "$orphans" ]]; then
        echo "No orphan packages found"
        return 0
    fi
    
    local count=$(echo "$orphans" | wc -l)
    echo "Found $count orphan packages:"
    echo "$orphans" | head -20
    (( count > 20 )) && echo "... and $((count - 20)) more"
    
    if ! $dry_run; then
        echo "$orphans" | pacman -Rns --noconfirm - 2>/dev/null || true
        echo "Removed $count orphan packages"
    else
        echo "[DRY RUN] Would remove $count packages"
    fi
}

# List packages by size
list_packages_by_size() {
    local limit="${1:-20}"
    
    if command -v expac &>/dev/null; then
        expac -H M '%m\t%n' | sort -rh | head -"$limit"
    elif command -v pacman &>/dev/null; then
        pacman -Qi | awk '/^Name/{name=$3} /^Installed Size/{print $4,$5,name}' | sort -rh | head -"$limit"
    else
        echo "Package manager not supported"
    fi
}

# Find packages not used recently
find_unused_packages() {
    local days="${1:-90}"
    
    echo "Packages not accessed in $days days:"
    
    for pkg in $(pacman -Qq 2>/dev/null); do
        local files=$(pacman -Ql "$pkg" 2>/dev/null | awk '{print $2}' | head -5)
        local accessed=false
        
        for f in $files; do
            [[ -f "$f" ]] && [[ $(find "$f" -atime -"$days" 2>/dev/null) ]] && { accessed=true; break; }
        done
        
        $accessed || echo "  $pkg"
    done | head -30
}
