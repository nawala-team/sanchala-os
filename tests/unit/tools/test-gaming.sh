#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════════════
# Unit Tests: Sanchala Gaming Tools
# ══════════════════════════════════════════════════════════════════════════════

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../framework/core.sh"

GAMING_TOOL="$SANCHALA_ROOT/tools/sanchala-gaming"

test_gaming_lib_exists() {
    assert_dir_exists "$GAMING_TOOL/lib"
}

test_gaming_core_lib() {
    assert_file_exists "$GAMING_TOOL/lib/core.sh"
}

test_gaming_launch_lib() {
    assert_file_exists "$GAMING_TOOL/lib/launch.sh"
}

test_gaming_helpers_lib() {
    assert_file_exists "$GAMING_TOOL/lib/helpers.sh"
}

test_gaming_config_dir() {
    assert_dir_exists "$GAMING_TOOL/config"
}

test_gaming_start_script() {
    assert_file_exists "$GAMING_TOOL/config/game-start.sh"
}

test_gaming_end_script() {
    assert_file_exists "$GAMING_TOOL/config/game-end.sh"
}

test_gaming_shell_syntax() {
    local errors=0
    while IFS= read -r -d '' file; do
        bash -n "$file" 2>/dev/null || ((errors++))
    done < <(find "$GAMING_TOOL" -name "*.sh" -type f -print0 2>/dev/null)
    (( errors == 0 ))
}

# Run tests
run_test "Gaming lib directory exists" test_gaming_lib_exists
run_test "Gaming core.sh exists" test_gaming_core_lib
run_test "Gaming launch.sh exists" test_gaming_launch_lib
run_test "Gaming helpers.sh exists" test_gaming_helpers_lib
run_test "Gaming config directory exists" test_gaming_config_dir
run_test "Gaming game-start.sh exists" test_gaming_start_script
run_test "Gaming game-end.sh exists" test_gaming_end_script
run_test "Gaming shell syntax valid" test_gaming_shell_syntax
