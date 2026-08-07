#!/bin/bash
# Test library files

LIB_DIR="${PROJECT_ROOT:-$(dirname $0)/../..}/lib"
PASS=0
FAIL=0

echo "=== Testing Library Files ==="

if [ -d "$LIB_DIR" ]; then
    for lib in "$LIB_DIR"/*.sh; do
        [ -f "$lib" ] || continue
        if bash -n "$lib" 2>/dev/null; then
            echo "✅ $lib syntax OK"
            ((PASS++))
        else
            echo "❌ $lib syntax error"
            ((FAIL++))
        fi
    done
fi

echo "Passed: $PASS, Failed: $FAIL"
exit $FAIL
