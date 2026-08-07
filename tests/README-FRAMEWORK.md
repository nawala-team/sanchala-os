# SANCHALA OS - Zero Bug Test Framework
## Quality Assurance Infrastructure

### Overview
This test framework ensures **ZERO BUG** delivery across all 288 tools in Sanchala OS.

### Directory Structure
```
tests/
├── framework/          # Core test engine
│   ├── test-engine.sh  # Main test framework
│   ├── assertions.sh   # Assertion functions
│   ├── runner.sh       # Test runner
│   ├── reporters.sh    # Report generators
│   └── static-analysis.sh
├── unit/               # Unit tests
├── integration/        # Integration tests
├── security/           # Security audit tests
├── performance/        # Benchmark tests
├── accessibility/      # WCAG compliance tests
├── regression/         # Regression tests
├── coverage/           # Coverage tracking
├── mocks/              # Mock utilities
├── reports/            # Generated reports
└── run-all-tests.sh    # Master test runner
```

### Quick Start
```bash
# Run all tests
./tests/run-all-tests.sh

# Run specific category
./tests/run-all-tests.sh --security
./tests/run-all-tests.sh --unit

# Quick smoke test
./tests/run-all-tests.sh --quick

# CI mode with reports
./tests/run-all-tests.sh --ci
```

### Test Categories

| Category | Description | Tests |
|----------|-------------|-------|
| Unit | Individual tool validation | Syntax, structure, configs |
| Integration | Cross-component testing | Data flow, services |
| Security | Vulnerability scanning | Secrets, injection, permissions |
| Performance | Benchmarks | Startup time, memory |
| Accessibility | WCAG compliance | Labels, contrast, i18n |
| Regression | Stability testing | API compat, structure |

### Assertions Available
- `assert_equals`, `assert_not_equals`
- `assert_contains`, `assert_matches`
- `assert_file_exists`, `assert_dir_exists`
- `assert_executable`, `assert_readable`, `assert_writable`
- `assert_command_exists`, `assert_exit_code`
- `assert_json_valid`, `assert_greater_than`, `assert_less_than`

### Writing Tests
```bash
#!/usr/bin/env bash
source "${SCRIPT_DIR}/../framework/test-engine.sh"

describe "My Test Suite"

test_example() {
    assert_equals "expected" "expected" "Values match"
}

it "Example test"; test_example && pass_test || fail_test
end_describe
```

### CI Integration
Copy `.github-actions.yml` to `.github/workflows/tests.yml` for GitHub Actions.

### Reports
- `reports/junit.xml` - JUnit XML for CI systems
- `reports/results.json` - JSON summary
- `reports/coverage.txt` - Coverage report

### Standards
- 100% syntax validation for shell/Python
- Security scanning (secrets, injection)
- WCAG 2.1 accessibility checks
- Performance benchmarks
- Zero tolerance for critical bugs
