#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════════════
# Unit Tests: Sanchala Backup Tool
# ══════════════════════════════════════════════════════════════════════════════

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../framework/core.sh"

BACKUP_TOOL="$SANCHALA_ROOT/tools/sanchala-backup"

test_backup_lib_exists() {
    assert_dir_exists "$BACKUP_TOOL/lib"
}

test_backup_config_lib() {
    assert_file_exists "$BACKUP_TOOL/lib/config.sh"
    assert_file_not_empty "$BACKUP_TOOL/lib/config.sh"
}

test_backup_utils_lib() {
    assert_file_exists "$BACKUP_TOOL/lib/utils.sh"
}

test_backup_snapshot_lib() {
    assert_file_exists "$BACKUP_TOOL/lib/snapshot.sh"
}

test_backup_restore_lib() {
    assert_file_exists "$BACKUP_TOOL/lib/restore.sh"
}

test_backup_remote_lib() {
    assert_file_exists "$BACKUP_TOOL/lib/remote.sh"
}

test_backup_shell_syntax() {
    local errors=0
    for lib in "$BACKUP_TOOL"/lib/*.sh; do
        [[ -f "$lib" ]] || continue
        bash -n "$lib" 2>/dev/null || ((errors++))
    done
    (( errors == 0 ))
}

# Run tests
run_test "Backup lib directory exists" test_backup_lib_exists
run_test "Backup config.sh exists" test_backup_config_lib
run_test "Backup utils.sh exists" test_backup_utils_lib
run_test "Backup snapshot.sh exists" test_backup_snapshot_lib
run_test "Backup restore.sh exists" test_backup_restore_lib
run_test "Backup remote.sh exists" test_backup_remote_lib
run_test "Backup shell syntax valid" test_backup_shell_syntax
