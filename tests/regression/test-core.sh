#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════════════
# SANCHALA OS - Regression Test Suite
# ══════════════════════════════════════════════════════════════════════════════
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../framework/test-engine.sh"

PROJECT_ROOT="${SCRIPT_DIR}/../../"

describe "Regression Tests: Core Functionality"

test_project_structure_intact() {
    local required_dirs=("tools" "config" "scripts" "docs" "security" "installer")
    local missing=0
    for dir in "${required_dirs[@]}"; do
        if [[ ! -d "${PROJECT_ROOT}/$dir" ]]; then
            log_warn "Missing required directory: $dir"
            ((missing++))
        fi
    done
    assert_equals 0 "$missing" "All required directories should exist"
}

test_critical_files_exist() {
    local critical_files=("README.md" "LICENSE" ".gitignore")
    local missing=0
    for file in "${critical_files[@]}"; do
        if [[ ! -f "${PROJECT_ROOT}/$file" ]]; then
            log_warn "Missing critical file: $file"
            ((missing++))
        fi
    done
    assert_equals 0 "$missing" "All critical files should exist"
}

test_tool_count_not_decreased() {
    local tool_count=$(find "$PROJECT_ROOT/tools" -maxdepth 1 -type d -name "sanchala-*" | wc -l)
    # Baseline: should have at least 200 tools based on previous count
    assert_greater_than "$tool_count" 200 "Tool count should not decrease (was 227+)"
}

describe "Regression Tests: Build Artifacts"

test_installer_scripts_valid() {
    local errors=0
    while IFS= read -r script; do
        if ! bash -n "$script" 2>/dev/null; then
            log_warn "Invalid installer script: $script"
            ((errors++))
        fi
    done < <(find "$PROJECT_ROOT/installer" -name "*.sh" -type f 2>/dev/null)
    assert_equals 0 "$errors" "Installer scripts should be valid"
}

test_iso_config_valid() {
    if [[ -d "${PROJECT_ROOT}/iso" ]]; then
        assert_file_exists "${PROJECT_ROOT}/iso/profiledef.sh" "ISO profile should exist"
    else
        skip_test "ISO directory not present"
    fi
}

describe "Regression Tests: Configuration Consistency"

test_config_files_not_empty() {
    local empty_configs=0
    while IFS= read -r config; do
        if [[ ! -s "$config" ]]; then
            log_warn "Empty config: $config"
            ((empty_configs++))
        fi
    done < <(find "$PROJECT_ROOT/config" -type f 2>/dev/null | head -50)
    assert_less_than "$empty_configs" 3 "Config files should not be empty"
}

test_no_broken_symlinks() {
    local broken=0
    while IFS= read -r link; do
        if [[ ! -e "$link" ]]; then
            log_warn "Broken symlink: $link"
            ((broken++))
        fi
    done < <(find "$PROJECT_ROOT" -type l 2>/dev/null)
    assert_equals 0 "$broken" "No broken symlinks"
}

describe "Regression Tests: Documentation"

test_readme_not_empty() {
    assert_file_not_empty "${PROJECT_ROOT}/README.md" "README should not be empty"
}

test_docs_structure_valid() {
    if [[ -d "${PROJECT_ROOT}/docs" ]]; then
        local doc_count=$(find "$PROJECT_ROOT/docs" -name "*.md" -type f | wc -l)
        assert_greater_than "$doc_count" 10 "Should have documentation"
    else
        skip_test "Docs directory not present"
    fi
}

# Run regression tests
it "Project structure intact"; test_project_structure_intact && pass_test || fail_test
it "Critical files exist"; test_critical_files_exist && pass_test || fail_test
it "Tool count maintained"; test_tool_count_not_decreased && pass_test || fail_test
it "Installer scripts valid"; test_installer_scripts_valid && pass_test || fail_test
it "ISO config valid"; test_iso_config_valid && pass_test || fail_test
it "Config files not empty"; test_config_files_not_empty && pass_test || fail_test
it "No broken symlinks"; test_no_broken_symlinks && pass_test || fail_test
it "README not empty"; test_readme_not_empty && pass_test || fail_test
it "Docs structure valid"; test_docs_structure_valid && pass_test || fail_test

end_describe
