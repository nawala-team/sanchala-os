#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════════════
# SANCHALA OS - Mock & Stub Functions
# ══════════════════════════════════════════════════════════════════════════════

declare -gA MOCK_COMMANDS=()
declare -gA MOCK_CALL_COUNTS=()
declare -gA MOCK_CALL_ARGS=()

mock_command() {
    local cmd="$1"
    local output="${2:-}"
    local exit_code="${3:-0}"
    
    MOCK_COMMANDS["$cmd"]="$output"
    MOCK_CALL_COUNTS["$cmd"]=0
    MOCK_CALL_ARGS["$cmd"]=""
    
    eval "${cmd}() {
        MOCK_CALL_COUNTS['$cmd']=\$(( \${MOCK_CALL_COUNTS['$cmd']} + 1 ))
        MOCK_CALL_ARGS['$cmd']=\"\$*\"
        echo '${output}'
        return ${exit_code}
    }"
}

mock_command_sequence() {
    local cmd="$1"
    shift
    local -a outputs=("$@")
    local idx=0
    
    MOCK_CALL_COUNTS["$cmd"]=0
    
    eval "${cmd}() {
        local idx=\${MOCK_CALL_COUNTS['$cmd']}
        MOCK_CALL_COUNTS['$cmd']=\$(( idx + 1 ))
        local outputs=($@)
        echo \"\${outputs[\$idx]:-}\"
    }"
}

unmock_command() {
    local cmd="$1"
    unset -f "$cmd" 2>/dev/null || true
    unset "MOCK_COMMANDS[$cmd]" 2>/dev/null || true
    unset "MOCK_CALL_COUNTS[$cmd]" 2>/dev/null || true
    unset "MOCK_CALL_ARGS[$cmd]" 2>/dev/null || true
}

unmock_all() {
    for cmd in "${!MOCK_COMMANDS[@]}"; do
        unmock_command "$cmd"
    done
}

assert_mock_called() {
    local cmd="$1"
    local expected="${2:-1}"
    local actual="${MOCK_CALL_COUNTS[$cmd]:-0}"
    
    if [[ "$actual" != "$expected" ]]; then
        echo "ASSERTION FAILED: Expected '$cmd' called $expected times, was $actual" >&2
        return 1
    fi
}

assert_mock_called_with() {
    local cmd="$1"
    local expected_args="$2"
    local actual_args="${MOCK_CALL_ARGS[$cmd]:-}"
    
    if [[ "$actual_args" != "$expected_args" ]]; then
        echo "ASSERTION FAILED: Expected '$cmd' called with '$expected_args', got '$actual_args'" >&2
        return 1
    fi
}

assert_mock_not_called() {
    local cmd="$1"
    local actual="${MOCK_CALL_COUNTS[$cmd]:-0}"
    
    if [[ "$actual" != "0" ]]; then
        echo "ASSERTION FAILED: Expected '$cmd' not called, was called $actual times" >&2
        return 1
    fi
}

get_mock_call_count() {
    local cmd="$1"
    echo "${MOCK_CALL_COUNTS[$cmd]:-0}"
}

get_mock_call_args() {
    local cmd="$1"
    echo "${MOCK_CALL_ARGS[$cmd]:-}"
}

# Spy function - wraps real command and tracks calls
spy_command() {
    local cmd="$1"
    local original_path
    original_path=$(command -v "$cmd" 2>/dev/null || echo "")
    
    MOCK_CALL_COUNTS["$cmd"]=0
    MOCK_CALL_ARGS["$cmd"]=""
    
    if [[ -n "$original_path" ]]; then
        eval "${cmd}() {
            MOCK_CALL_COUNTS['$cmd']=\$(( \${MOCK_CALL_COUNTS['$cmd']} + 1 ))
            MOCK_CALL_ARGS['$cmd']=\"\$*\"
            command $cmd \"\$@\"
        }"
    fi
}

export -f mock_command mock_command_sequence unmock_command unmock_all
export -f assert_mock_called assert_mock_called_with assert_mock_not_called
export -f get_mock_call_count get_mock_call_args spy_command
