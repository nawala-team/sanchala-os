#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════════════════
# SANCHALA OS - Test Fixtures
# ══════════════════════════════════════════════════════════════════════════════

declare -g FIXTURE_DIR=""
declare -g FIXTURE_HOME=""
declare -ga FIXTURE_CLEANUP_HOOKS=()

setup_fixture() {
    FIXTURE_DIR=$(mktemp -d -t sanchala_test_XXXXXX)
    FIXTURE_HOME="$FIXTURE_DIR/home"
    mkdir -p "$FIXTURE_HOME"
    export FIXTURE_DIR FIXTURE_HOME
    export HOME="$FIXTURE_HOME"
    log_debug "Created fixture directory: $FIXTURE_DIR"
}

teardown_fixture() {
    # Run cleanup hooks
    for hook in "${FIXTURE_CLEANUP_HOOKS[@]}"; do
        eval "$hook" 2>/dev/null || true
    done
    FIXTURE_CLEANUP_HOOKS=()
    
    if [[ -n "$FIXTURE_DIR" ]] && [[ -d "$FIXTURE_DIR" ]]; then
        rm -rf "$FIXTURE_DIR"
        log_debug "Removed fixture directory: $FIXTURE_DIR"
    fi
    FIXTURE_DIR=""
    FIXTURE_HOME=""
}

add_cleanup_hook() {
    FIXTURE_CLEANUP_HOOKS+=("$1")
}

create_fixture_file() {
    local filename="$1"
    local content="${2:-}"
    local filepath="$FIXTURE_DIR/$filename"
    
    mkdir -p "$(dirname "$filepath")"
    printf '%s' "$content" > "$filepath"
    echo "$filepath"
}

create_fixture_dir() {
    local dirname="$1"
    local dirpath="$FIXTURE_DIR/$dirname"
    mkdir -p "$dirpath"
    echo "$dirpath"
}

create_fixture_script() {
    local filename="$1"
    local content="$2"
    local filepath
    filepath=$(create_fixture_file "$filename" "#!/usr/bin/env bash
set -euo pipefail
$content")
    chmod +x "$filepath"
    echo "$filepath"
}

create_fixture_python() {
    local filename="$1"
    local content="$2"
    local filepath
    filepath=$(create_fixture_file "$filename" "#!/usr/bin/env python3
# -*- coding: utf-8 -*-
$content")
    chmod +x "$filepath"
    echo "$filepath"
}

create_fixture_config() {
    local filename="$1"
    local -n config_map=$2
    local filepath="$FIXTURE_DIR/$filename"
    
    mkdir -p "$(dirname "$filepath")"
    : > "$filepath"
    
    for key in "${!config_map[@]}"; do
        echo "${key}=${config_map[$key]}" >> "$filepath"
    done
    echo "$filepath"
}

create_fixture_json() {
    local filename="$1"
    local json="$2"
    create_fixture_file "$filename" "$json"
}

create_fixture_tree() {
    local base="$1"
    shift
    
    for path in "$@"; do
        if [[ "$path" == */ ]]; then
            mkdir -p "$FIXTURE_DIR/$base/$path"
        else
            mkdir -p "$FIXTURE_DIR/$base/$(dirname "$path")"
            touch "$FIXTURE_DIR/$base/$path"
        fi
    done
    echo "$FIXTURE_DIR/$base"
}

copy_to_fixture() {
    local source="$1"
    local dest="${2:-$(basename "$source")}"
    
    if [[ -d "$source" ]]; then
        cp -r "$source" "$FIXTURE_DIR/$dest"
    else
        mkdir -p "$FIXTURE_DIR/$(dirname "$dest")"
        cp "$source" "$FIXTURE_DIR/$dest"
    fi
    echo "$FIXTURE_DIR/$dest"
}

get_fixture_path() {
    local relative="$1"
    echo "$FIXTURE_DIR/$relative"
}

export -f setup_fixture teardown_fixture add_cleanup_hook
export -f create_fixture_file create_fixture_dir create_fixture_script
export -f create_fixture_python create_fixture_config create_fixture_json
export -f create_fixture_tree copy_to_fixture get_fixture_path
