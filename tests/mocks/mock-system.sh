#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════════════
# SANCHALA OS - Mock System for Testing
# ══════════════════════════════════════════════════════════════════════════════

# Mock filesystem
create_mock_fs() {
    local mock_root="${TEST_TEMP_DIR:-/tmp}/mock_fs"
    mkdir -p "$mock_root"/{etc,var/log,home/user,usr/bin}
    echo "mock_root=$mock_root"
}

# Mock command
mock_command() {
    local cmd="$1" output="$2" exit_code="${3:-0}"
    local mock_dir="${TEST_TEMP_DIR:-/tmp}/mock_bin"
    mkdir -p "$mock_dir"
    cat > "$mock_dir/$cmd" << EOF
#!/bin/bash
echo "$output"
exit $exit_code
EOF
    chmod +x "$mock_dir/$cmd"
    export PATH="$mock_dir:$PATH"
}

# Mock file
mock_file() {
    local path="$1" content="$2"
    mkdir -p "$(dirname "$path")"
    echo "$content" > "$path"
}

# Mock environment
mock_env() {
    local var="$1" value="$2"
    export "$var"="$value"
}

# Reset mocks
reset_mocks() {
    [[ -n "${TEST_TEMP_DIR:-}" ]] && rm -rf "${TEST_TEMP_DIR}/mock_"*
}

# Mock D-Bus
mock_dbus_call() {
    local interface="$1" method="$2" response="$3"
    mock_command "dbus-send" "$response" 0
}

# Mock systemctl
mock_systemctl() {
    local status="${1:-active}"
    mock_command "systemctl" "ActiveState=$status" 0
}
