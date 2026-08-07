#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════════════
# Unit Tests: Sanchala Updater Tool
# ══════════════════════════════════════════════════════════════════════════════

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../framework/core.sh"

UPDATER_TOOL="$SANCHALA_ROOT/tools/sanchala-updater"

test_updater_lib_exists() {
    assert_dir_exists "$UPDATER_TOOL/lib"
}

test_updater_hooks_exist() {
    assert_dir_exists "$UPDATER_TOOL/hooks"
    assert_dir_exists "$UPDATER_TOOL/hooks/pre-update"
    assert_dir_exists "$UPDATER_TOOL/hooks/post-update"
}

test_updater_common_lib() {
    assert_file_exists "$UPDATER_TOOL/lib/common.sh"
}

test_updater_snapshot_lib() {
    assert_file_exists "$UPDATER_TOOL/lib/snapshot.sh"
}

test_updater_delta_lib() {
    assert_file_exists "$UPDATER_TOOL/lib/delta.sh"
}

test_updater_notify_lib() {
    assert_file_exists "$UPDATER_TOOL/lib/notify.sh"
}

test_pre_update_hooks() {
    local hooks_found=0
    for hook in "$UPDATER_TOOL/hooks/pre-update"/*.sh; do
        [[ -f "$hook" ]] && ((hooks_found++))
    done
    (( hooks_found > 0 ))
}

test_post_update_hooks() {
    local hooks_found=0
    for hook in "$UPDATER_TOOL/hooks/post-update"/*.sh; do
        [[ -f "$hook" ]] && ((hooks_found++))
    done
    (( hooks_found > 0 ))
}

test_updater_shell_syntax() {
    local errors=0
    while IFS= read -r -d '' file; do
        bash -n "$file" 2>/dev/null || ((errors++))
    done < <(find "$UPDATER_TOOL" -name "*.sh" -type f -print0 2>/dev/null)
    (( errors == 0 ))
}

# Run tests
run_test "Updater lib directory exists" test_updater_lib_exists
run_test "Updater hooks directories exist" test_updater_hooks_exist
run_test "Updater common.sh exists" test_updater_common_lib
run_test "Updater snapshot.sh exists" test_updater_snapshot_lib
run_test "Updater delta.sh exists" test_updater_delta_lib
run_test "Updater notify.sh exists" test_updater_notify_lib
run_test "Pre-update hooks present" test_pre_update_hooks
run_test "Post-update hooks present" test_post_update_hooks
run_test "Updater shell syntax valid" test_updater_shell_syntax
