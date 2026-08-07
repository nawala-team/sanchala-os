#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════════════
# SANCHALA OS - Security Testing Module
# ══════════════════════════════════════════════════════════════════════════════

# Security test helpers
check_file_permissions() {
    local file="$1"
    local max_perm="${2:-644}"
    local actual
    actual=$(stat -c %a "$file" 2>/dev/null || stat -f %Lp "$file" 2>/dev/null)
    (( actual <= max_perm ))
}

check_no_world_writable() {
    local path="$1"
    ! find "$path" -type f -perm -002 2>/dev/null | grep -q .
}

check_no_suid() {
    local path="$1"
    ! find "$path" -type f -perm -4000 2>/dev/null | grep -q .
}

check_no_hardcoded_secrets() {
    local file="$1"
    local patterns=(
        'password\s*=\s*["\x27][^"\x27]+'
        'api_key\s*=\s*["\x27][^"\x27]+'
        'secret\s*=\s*["\x27][^"\x27]+'
        'token\s*=\s*["\x27][^"\x27]+'
        'BEGIN RSA PRIVATE KEY'
        'BEGIN OPENSSH PRIVATE KEY'
    )
    for pattern in "${patterns[@]}"; do
        if grep -qiE "$pattern" "$file" 2>/dev/null; then
            return 1
        fi
    done
    return 0
}

check_sql_injection_safe() {
    local file="$1"
    # Check for unsafe SQL patterns
    local unsafe_patterns=(
        '\$\{.*\}.*SELECT'
        '\$\{.*\}.*INSERT'
        '\$\{.*\}.*UPDATE'
        '\$\{.*\}.*DELETE'
        'execute.*\$'
    )
    for pattern in "${unsafe_patterns[@]}"; do
        if grep -qE "$pattern" "$file" 2>/dev/null; then
            return 1
        fi
    done
    return 0
}

check_command_injection_safe() {
    local file="$1"
    # Check for unsafe eval/exec patterns
    local unsafe_patterns=(
        'eval\s+\$'
        'bash\s+-c\s+\$'
        '\$\(.*\$.*\)'
    )
    for pattern in "${unsafe_patterns[@]}"; do
        if grep -qE "$pattern" "$file" 2>/dev/null; then
            return 1
        fi
    done
    return 0
}

check_path_traversal_safe() {
    local file="$1"
    # Check for path traversal vulnerabilities
    ! grep -qE '\.\./|\.\.\\' "$file" 2>/dev/null
}

run_shellcheck() {
    local file="$1"
    local severity="${2:-warning}"
    if command -v shellcheck &>/dev/null; then
        shellcheck -S "$severity" "$file" 2>&1
        return $?
    fi
    return 0
}

run_bandit() {
    local file="$1"
    local severity="${2:-medium}"
    if command -v bandit &>/dev/null; then
        bandit -ll -ii "$file" 2>&1
        return $?
    fi
    return 0
}

scan_for_vulnerabilities() {
    local path="$1"
    local issues=()
    
    while IFS= read -r -d '' file; do
        if ! check_no_hardcoded_secrets "$file"; then
            issues+=("Potential secrets in: $file")
        fi
        if [[ "$file" == *.sh ]] && ! check_command_injection_safe "$file"; then
            issues+=("Potential command injection in: $file")
        fi
    done < <(find "$path" -type f \( -name "*.sh" -o -name "*.py" \) -print0 2>/dev/null)
    
    if (( ${#issues[@]} > 0 )); then
        printf '%s\n' "${issues[@]}"
        return 1
    fi
    return 0
}

export -f check_file_permissions check_no_world_writable check_no_suid
export -f check_no_hardcoded_secrets check_sql_injection_safe
export -f check_command_injection_safe check_path_traversal_safe
export -f run_shellcheck run_bandit scan_for_vulnerabilities
