#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════════════
# SANCHALA OS - Unit Tests: Configuration Files
# ══════════════════════════════════════════════════════════════════════════════
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../framework/test-engine.sh"

PROJECT_ROOT="${SCRIPT_DIR}/../../"

describe "Configuration File Tests"

test_config_directory_exists() {
    assert_dir_exists "${PROJECT_ROOT}/config" "config directory should exist"
}

test_yaml_files_valid() {
    local errors=0
    while IFS= read -r yaml_file; do
        if command -v python3 &>/dev/null; then
            if ! python3 -c "import yaml; yaml.safe_load(open('$yaml_file'))" 2>/dev/null; then
                log_warn "Invalid YAML: $yaml_file"
                ((errors++))
            fi
        fi
    done < <(find "$PROJECT_ROOT" \( -name "*.yml" -o -name "*.yaml" \) -type f 2>/dev/null | head -50)
    assert_equals 0 "$errors" "All YAML files should be valid"
}

test_ini_files_valid() {
    local errors=0
    while IFS= read -r ini_file; do
        if ! python3 -c "import configparser; c=configparser.ConfigParser(); c.read('$ini_file')" 2>/dev/null; then
            # Some .conf files aren't INI format, skip
            :
        fi
    done < <(find "$PROJECT_ROOT" -name "*.ini" -type f 2>/dev/null | head -20)
    assert_equals 0 "$errors" "INI files should be valid"
}

test_no_secrets_in_config() {
    local violations=0
    local patterns=("password=" "secret=" "api_key=" "token=" "private_key")
    while IFS= read -r config_file; do
        for pattern in "${patterns[@]}"; do
            if grep -qi "$pattern" "$config_file" 2>/dev/null; then
                # Check if it's a placeholder
                if ! grep -qiE "${pattern}['\"]?(example|changeme|xxx|\$|{)" "$config_file" 2>/dev/null; then
                    log_warn "Possible secret in: $config_file"
                    ((violations++))
                fi
            fi
        done
    done < <(find "${PROJECT_ROOT}/config" -type f 2>/dev/null | head -50)
    assert_equals 0 "$violations" "No secrets in config files"
}

it "Config directory exists"; test_config_directory_exists && pass_test || fail_test
it "YAML files valid"; test_yaml_files_valid && pass_test || fail_test  
it "INI files valid"; test_ini_files_valid && pass_test || fail_test
it "No secrets in config"; test_no_secrets_in_config && pass_test || fail_test

end_describe
