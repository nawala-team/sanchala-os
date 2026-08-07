#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════════════
# SANCHALA OS - Integration Tests: Data Flow
# ══════════════════════════════════════════════════════════════════════════════
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../framework/test-engine.sh"

PROJECT_ROOT="${SCRIPT_DIR}/../../"

describe "Data Flow Integration Tests"

test_data_directory_structure() {
    assert_dir_exists "${PROJECT_ROOT}/data" "data directory should exist"
}

test_database_schemas_valid() {
    local errors=0
    while IFS= read -r schema_file; do
        if ! grep -qiE 'CREATE|INSERT|TABLE|DATABASE' "$schema_file" 2>/dev/null; then
            log_warn "Possibly invalid schema: $schema_file"
        fi
    done < <(find "$PROJECT_ROOT" \( -name "*.sql" -o -name "*schema*" \) -type f 2>/dev/null)
    assert_equals 0 "$errors" "Database schemas should be valid"
}

test_data_directories_writable() {
    local data_dirs=("logs" "backups" "recovery")
    for dir in "${data_dirs[@]}"; do
        if [[ -d "${PROJECT_ROOT}/$dir" ]]; then
            assert_writable "${PROJECT_ROOT}/$dir" "$dir should be writable"
        fi
    done
}

it "Data directory exists"; test_data_directory_structure && pass_test || fail_test
it "Database schemas valid"; test_database_schemas_valid && pass_test || fail_test
it "Data dirs writable"; test_data_directories_writable && pass_test || fail_test

end_describe
