#!/bin/bash
# Test configuration files

CONFIG_DIR="${PROJECT_ROOT:-$(dirname $0)/../..}/config"
PASS=0
FAIL=0

echo "=== Testing Config Files ==="

if [ -d "$CONFIG_DIR" ]; then
    for config in "$CONFIG_DIR"/*.conf "$CONFIG_DIR"/*.yml "$CONFIG_DIR"/*.json; do
        [ -f "$config" ] || continue
        if [ -r "$config" ]; then
            echo "✅ $config readable"
            ((PASS++))
        else
            echo "❌ $config not readable"
            ((FAIL++))
        fi
    done
fi

echo "Passed: $PASS, Failed: $FAIL"
exit $FAIL
