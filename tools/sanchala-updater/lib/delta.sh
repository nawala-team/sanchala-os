#!/bin/bash
# SPDX-License-Identifier: GPL-3.0
# Sanchala OS Updater - Delta Update Support

readonly DELTA_CACHE_DIR="${CACHE_DIR}/deltas"
readonly DELTA_SERVER="${DELTA_SERVER:-https://updates.sanchala.os/deltas}"

# Check if delta updates are available for a package
check_delta_available() {
    local pkg_name="$1"
    local old_ver="$2"
    local new_ver="$3"
    
    local delta_file="${pkg_name}-${old_ver}_to_${new_ver}.delta"
    local delta_url="${DELTA_SERVER}/${pkg_name}/${delta_file}"
    
    # Check if delta exists on server
    curl -sfI "$delta_url" &>/dev/null
}

# Download delta file
download_delta() {
    local pkg_name="$1"
    local old_ver="$2"
    local new_ver="$3"
    
    local delta_file="${pkg_name}-${old_ver}_to_${new_ver}.delta"
    local delta_url="${DELTA_SERVER}/${pkg_name}/${delta_file}"
    local local_path="${DELTA_CACHE_DIR}/${delta_file}"
    
    mkdir -p "$DELTA_CACHE_DIR"
    
    log_info "Downloading delta: ${delta_file}"
    if curl -sfL -o "$local_path" "$delta_url"; then
        echo "$local_path"
        return 0
    fi
    return 1
}

# Apply delta to create new package
apply_delta() {
    local old_pkg="$1"
    local delta_file="$2"
    local new_pkg="$3"
    
    if command -v xdelta3 &>/dev/null; then
        xdelta3 -d -s "$old_pkg" "$delta_file" "$new_pkg"
        return $?
    elif command -v zstd &>/dev/null && [[ "$delta_file" == *.zstd.delta ]]; then
        # Zstd-based delta format
        zstd -d "$delta_file" -o "${delta_file%.zstd}" 
        bspatch "$old_pkg" "$new_pkg" "${delta_file%.zstd}"
        rm -f "${delta_file%.zstd}"
        return $?
    fi
    
    log_warn "No delta tool available, falling back to full download"
    return 1
}

# Calculate delta savings
calculate_delta_savings() {
    local full_size="$1"
    local delta_size="$2"
    
    local savings=$((full_size - delta_size))
    local percent=$((savings * 100 / full_size))
    
    echo "${percent}% (saved $(numfmt --to=iec $savings))"
}

# Verify delta integrity
verify_delta() {
    local delta_file="$1"
    local expected_hash="$2"
    
    local actual_hash
    actual_hash=$(sha256sum "$delta_file" | awk '{print $1}')
    
    [[ "$actual_hash" == "$expected_hash" ]]
}

# Get list of packages that can use delta updates
get_delta_candidates() {
    local updates
    updates=$(pacman -Qu 2>/dev/null) || return 1
    
    while read -r pkg old_ver _ new_ver; do
        [[ -z "$pkg" ]] && continue
        
        # Check if we have the old package cached
        local old_pkg="/var/cache/pacman/pkg/${pkg}-${old_ver}-*.pkg.tar.*"
        if compgen -G "$old_pkg" > /dev/null; then
            echo "$pkg $old_ver $new_ver"
        fi
    done <<< "$updates"
}

# Download updates with delta support
download_with_deltas() {
    local total_saved=0
    local delta_count=0
    
    if [[ "${DELTA_ENABLED:-true}" != "true" ]]; then
        log_info "Delta updates disabled, using full downloads"
        download_updates
        return $?
    fi
    
    log_info "Checking for delta updates..."
    
    local candidates
    candidates=$(get_delta_candidates)
    
    while read -r pkg old_ver new_ver; do
        [[ -z "$pkg" ]] && continue
        
        if check_delta_available "$pkg" "$old_ver" "$new_ver"; then
            local delta_path
            if delta_path=$(download_delta "$pkg" "$old_ver" "$new_ver"); then
                local old_pkg
                old_pkg=$(compgen -G "/var/cache/pacman/pkg/${pkg}-${old_ver}-*.pkg.tar.*" | head -1)
                local new_pkg="/var/cache/pacman/pkg/${pkg}-${new_ver}.pkg.tar.zst"
                
                if apply_delta "$old_pkg" "$delta_path" "$new_pkg"; then
                    ((delta_count++))
                    log_info "Applied delta for $pkg"
                fi
            fi
        fi
    done <<< "$candidates"
    
    # Download remaining packages normally
    download_updates
    
    [[ $delta_count -gt 0 ]] && log_info "Used $delta_count delta updates"
    return 0
}
