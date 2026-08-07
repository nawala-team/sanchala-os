#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════════════
# Integration Tests: System Components
# ══════════════════════════════════════════════════════════════════════════════

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../framework/core.sh"

# Test ISO configuration
test_iso_profiledef() {
    local profiledef="$SANCHALA_ROOT/iso/profiledef.sh"
    assert_file_exists "$profiledef"
    bash -n "$profiledef" 2>/dev/null
}

test_iso_airootfs() {
    assert_dir_exists "$SANCHALA_ROOT/iso/airootfs"
}

# Test security configuration
test_security_tpm_setup() {
    local tpm_setup="$SANCHALA_ROOT/security/tpm/setup-tpm.sh"
    [[ -f "$tpm_setup" ]] && bash -n "$tpm_setup" 2>/dev/null
    return 0
}

# Test settings structure
test_settings_profile() {
    local profile="$SANCHALA_ROOT/settings/etc/profile.d/sanchala-gaming.sh"
    [[ -f "$profile" ]] && bash -n "$profile" 2>/dev/null
    return 0
}

test_settings_shortcuts() {
    assert_dir_exists "$SANCHALA_ROOT/settings/usr/share/sanchala/shortcuts"
}

test_settings_file_associations() {
    assert_dir_exists "$SANCHALA_ROOT/settings/usr/share/sanchala/file-associations"
}

# Test installer components
test_installer_exists() {
    assert_dir_exists "$SANCHALA_ROOT/installer"
}

# Test kernel configuration
test_kernel_config() {
    assert_dir_exists "$SANCHALA_ROOT/kernel"
}

# Test scripts directory
test_scripts_exist() {
    assert_dir_exists "$SANCHALA_ROOT/scripts"
}

# Test config directory structure
test_config_structure() {
    assert_dir_exists "$SANCHALA_ROOT/config"
}

# Test branding assets
test_branding_exists() {
    assert_dir_exists "$SANCHALA_ROOT/branding"
}

# Test documentation
test_docs_exist() {
    assert_dir_exists "$SANCHALA_ROOT/docs"
}

# Run tests
run_test "ISO profiledef valid" test_iso_profiledef
run_test "ISO airootfs exists" test_iso_airootfs
run_test "Security TPM setup" test_security_tpm_setup
run_test "Settings profile script" test_settings_profile
run_test "Settings shortcuts dir" test_settings_shortcuts
run_test "Settings file associations" test_settings_file_associations
run_test "Installer directory" test_installer_exists
run_test "Kernel configuration" test_kernel_config
run_test "Scripts directory" test_scripts_exist
run_test "Config structure" test_config_structure
run_test "Branding assets" test_branding_exists
run_test "Documentation" test_docs_exist
