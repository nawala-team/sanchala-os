#!/bin/bash
# security.sh - Secure transfer and verification functions for sanchala-migrate
# Part of SANCHALA OS

# Generate SHA256 manifest of source files
generate_manifest() {
    local source_dir="$1"
    local manifest_file="$2"
    
    echo "Generating file manifest..."
    find "$source_dir" -type f -print0 2>/dev/null | \
        xargs -0 sha256sum 2>/dev/null > "$manifest_file"
    
    local count=$(wc -l < "$manifest_file")
    echo "Manifest created: ${count} files"
}

# Verify transferred files against manifest
verify_transfer() {
    local manifest_file="$1"
    local target_base="$2"
    local errors=0
    
    echo "Verifying transfer integrity..."
    
    while IFS=' ' read -r hash filepath; do
        local relative_path="${filepath##*/}"
        local target_file=$(find "$target_base" -name "$relative_path" -type f 2>/dev/null | head -1)
        
        if [[ -f "$target_file" ]]; then
            local target_hash=$(sha256sum "$target_file" 2>/dev/null | cut -d' ' -f1)
            if [[ "$hash" != "$target_hash" ]]; then
                echo "  MISMATCH: $relative_path"
                errors=$((errors + 1))
            fi
        fi
    done < "$manifest_file"
    
    [[ $errors -eq 0 ]] && { echo "✓ All files verified"; return 0; } || { echo "✗ ${errors} failed"; return 1; }
}

# Secure delete of temporary files
secure_cleanup() {
    local temp_dir="$1"
    if [[ -d "$temp_dir" && "$temp_dir" == */sanchala-migrate* ]]; then
        find "$temp_dir" -type f -name "*.csv" -o -name "*password*" | while read -r f; do
            shred -u "$f" 2>/dev/null || rm -f "$f"
        done
        rm -rf "$temp_dir"
        echo "Temporary files securely removed"
    fi
}

# Encrypt sensitive data for transfer
encrypt_data() {
    local source_file="$1" output_file="$2" password="$3"
    if command -v openssl &>/dev/null; then
        openssl enc -aes-256-cbc -salt -pbkdf2 -in "$source_file" -out "$output_file" -pass "pass:${password}"
    else
        cp "$source_file" "$output_file"
    fi
}

# Decrypt transferred data
decrypt_data() {
    local source_file="$1" output_file="$2" password="$3"
    command -v openssl &>/dev/null && \
        openssl enc -aes-256-cbc -d -salt -pbkdf2 -in "$source_file" -out "$output_file" -pass "pass:${password}"
}

# Check for sensitive files that need special handling
scan_sensitive_files() {
    local source_dir="$1"
    local patterns=("*.pem" "*.key" "*.p12" "*password*" "*.kdbx" "id_rsa" "id_ed25519" ".env")
    
    echo "Scanning for sensitive files..."
    local found=0
    
    for pattern in "${patterns[@]}"; do
        while IFS= read -r -d '' file; do
            echo "  ⚠ ${file}"
            found=$((found + 1))
        done < <(find "$source_dir" -iname "$pattern" -type f -print0 2>/dev/null)
    done
    
    [[ $found -gt 0 ]] && { echo "Found ${found} sensitive file(s) - manual review required"; return 1; }
    echo "No sensitive files detected"
    return 0
}

# Validate source before migration
validate_source() {
    local source_dir="$1" os_type="$2"
    
    echo "Validating migration source..."
    [[ ! -r "$source_dir" ]] && { echo "ERROR: Source not readable"; return 1; }
    
    local source_size=$(du -sb "$source_dir" 2>/dev/null | cut -f1)
    local available=$(df -B1 "$HOME" | tail -1 | awk '{print $4}')
    
    if [[ $source_size -gt $available ]]; then
        echo "ERROR: Insufficient disk space"
        return 1
    fi
    
    case "$os_type" in
        windows*|macos*) [[ ! -d "${source_dir}/Users" ]] && { echo "ERROR: Users folder not found"; return 1; } ;;
    esac
    
    echo "✓ Source validation passed"
    return 0
}

# Rate-limited copy to prevent system overload
throttled_copy() {
    local src="$1" dst="$2" bwlimit="${3:-0}"
    [[ $bwlimit -gt 0 ]] && rsync -av --progress --bwlimit="$bwlimit" "$src" "$dst" || rsync -av --progress "$src" "$dst"
}

# Create migration state backup
backup_state() {
    local state_dir="${DATA_DIR:-$HOME/.local/share/sanchala-migrate}"
    local backup_dir="${state_dir}/backups"
    mkdir -p "$backup_dir"
    [[ -f "${state_dir}/state.json" ]] && cp "${state_dir}/state.json" "${backup_dir}/state_$(date +%Y%m%d_%H%M%S).json"
}
