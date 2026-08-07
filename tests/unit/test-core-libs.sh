#!/bin/bash
# Test core libraries

PROJECT_ROOT="${PROJECT_ROOT:-$(dirname $0)/../..}"
PASS=0
FAIL=0

echo "=== Testing Core Libraries ==="

if [ -d "${PROJECT_ROOT}/lib" ]; then
    for f in "${PROJECT_ROOT}/lib"/*.sh "${PROJECT_ROOT}/lib"/*.py; do
        [ -f "$f" ] || continue
        if [ -r "$f" ]; then
            echo "✅ $f exists"
            ((PASS++))
        else
            echo "❌ $f missing"
            ((FAIL++))
        fi
    done
fi

echo "Passed: $PASS, Failed: $FAIL"
exit $FAIL
