#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════════════
# SANCHALA OS - Coverage Tracking
# ══════════════════════════════════════════════════════════════════════════════

COVERAGE_DIR="${SCRIPT_DIR:-$(dirname "$0")/../}/coverage"
mkdir -p "$COVERAGE_DIR"

declare -A COVERED_FILES
declare -A COVERED_FUNCTIONS

track_file() {
    local file="$1"
    COVERED_FILES["$file"]=1
}

track_function() {
    local func="$1"
    COVERED_FUNCTIONS["$func"]=1
}

generate_coverage_summary() {
    local output="${1:-$COVERAGE_DIR/summary.txt}"
    local total_files=$(find "$PROJECT_ROOT" -name "*.sh" -o -name "*.py" 2>/dev/null | wc -l)
    local covered=${#COVERED_FILES[@]}
    
    cat > "$output" << EOF
SANCHALA OS - Coverage Report
Generated: $(date)
================================
Total Files: $total_files
Covered: $covered
Coverage: $(( total_files > 0 ? (covered * 100) / total_files : 0 ))%

Covered Files:
$(printf '%s\n' "${!COVERED_FILES[@]}" | sort)
EOF
}

# Bash coverage using PS4 and set -x
enable_bash_coverage() {
    export PS4='+(${BASH_SOURCE}:${LINENO}): '
    exec 2>> "$COVERAGE_DIR/bash_trace.log"
    set -x
}

disable_bash_coverage() {
    set +x
    exec 2>&1
}
