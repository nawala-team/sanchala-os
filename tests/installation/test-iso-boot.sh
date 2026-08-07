#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════════════
# SANCHALA OS - Installation Tests: ISO Boot
# ══════════════════════════════════════════════════════════════════════════════

test_iso_exists() {
    log_subheader "ISO File Check"
    
    if [[ -f "$TEST_ISO_PATH" ]]; then
        pass "ISO file exists: $(basename "$TEST_ISO_PATH")"
        
        local iso_size
        iso_size=$(stat -f%z "$TEST_ISO_PATH" 2>/dev/null || stat -c%s "$TEST_ISO_PATH" 2>/dev/null)
        if [[ -n "$iso_size" ]] && [[ $iso_size -gt 1000000000 ]]; then
            pass "ISO size reasonable: $((iso_size / 1024 / 1024)) MB"
        else
            skip "ISO size check" "Size: $((iso_size / 1024 / 1024)) MB"
        fi
    else
        skip "ISO file check" "ISO not found at: $TEST_ISO_PATH"
        return 1
    fi
}

test_iso_checksum() {
    log_subheader "ISO Checksum Verification"
    
    if [[ ! -f "$TEST_ISO_PATH" ]]; then
        skip "ISO checksum" "ISO file not found"
        return
    fi
    
    local checksum_file="${TEST_ISO_PATH}.sha256"
    if [[ -f "$checksum_file" ]]; then
        if sha256sum -c "$checksum_file" &>/dev/null; then
            pass "ISO checksum valid"
        else
            fail "ISO checksum mismatch" "SHA256 verification failed"
        fi
    else
        skip "ISO checksum" "No .sha256 file found"
    fi
}

test_qemu_boot() {
    log_subheader "QEMU Boot Test"
    
    if ! command -v qemu-system-x86_64 &>/dev/null; then
        skip "QEMU boot test" "qemu-system-x86_64 not installed"
        return
    fi
    
    if [[ ! -f "$TEST_ISO_PATH" ]]; then
        skip "QEMU boot test" "ISO file not found"
        return
    fi
    
    local temp_dir
    temp_dir=$(create_temp_dir)
    local boot_log="${temp_dir}/boot.log"
    
    log_info "Starting QEMU boot test (timeout: ${QEMU_TIMEOUT}s)..."
    
    # Run QEMU with serial output, timeout after configured seconds
    timeout "${QEMU_TIMEOUT}" qemu-system-x86_64 \
        -m "${QEMU_MEMORY}" \
        -smp "${QEMU_CPUS}" \
        -cdrom "$TEST_ISO_PATH" \
        -boot d \
        -nographic \
        -serial file:"${boot_log}" \
        -no-reboot \
        2>/dev/null &
    
    local qemu_pid=$!
    
    # Wait for boot indicators
    local boot_success=false
    local waited=0
    while [[ $waited -lt $QEMU_TIMEOUT ]]; do
        if [[ -f "$boot_log" ]]; then
            # Check for successful boot indicators
            if grep -qiE "(login:|Welcome to|systemd|Started)" "$boot_log" 2>/dev/null; then
                boot_success=true
                break
            fi
            # Check for kernel panic or boot failure
            if grep -qiE "(kernel panic|fatal error|boot failed)" "$boot_log" 2>/dev/null; then
                break
            fi
        fi
        sleep 5
        ((waited += 5))
    done
    
    # Cleanup
    kill $qemu_pid 2>/dev/null || true
    
    if $boot_success; then
        pass "ISO boots successfully in QEMU"
    else
        fail "ISO boot test" "No boot indicators found within timeout"
    fi
    
    cleanup_temp "$temp_dir"
}

# Run tests
test_iso_exists
test_iso_checksum
test_qemu_boot
