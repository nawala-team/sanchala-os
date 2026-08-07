# 🧪 SANCHALA OS - Test Framework

## Overview

Comprehensive testing framework for Sanchala OS covering unit tests, integration tests, installation tests, and security validation.

## Directory Structure

```
tests/
├── README.md               # This file
├── run-tests.sh           # Main test runner
├── config.sh              # Test configuration
├── unit/                  # Unit tests for individual components
│   ├── test-shell-scripts.sh
│   ├── test-configs.sh
│   └── test-tools.sh
├── integration/           # Integration tests
│   ├── test-filesystem.sh
│   ├── test-security-stack.sh
│   └── test-desktop.sh
├── installation/          # Installation tests (VM-based)
│   ├── test-iso-boot.sh
│   ├── test-calamares.sh
│   └── test-post-install.sh
├── security/              # Security validation tests
│   ├── test-hardening.sh
│   ├── test-apparmor.sh
│   └── test-encryption.sh
├── fixtures/              # Test data and fixtures
└── helpers/               # Test helper functions
    └── common.sh
```

## Quick Start

```bash
# Run all tests
./tests/run-tests.sh

# Run specific category
./tests/run-tests.sh --unit
./tests/run-tests.sh --integration
./tests/run-tests.sh --security
./tests/run-tests.sh --installation

# Run with verbose output
./tests/run-tests.sh --verbose

# Generate JUnit XML report (for CI)
./tests/run-tests.sh --junit report.xml
```

## Test Categories

### Unit Tests
Fast, isolated tests for individual scripts and configurations:
- Shell script syntax validation
- Configuration file validation (YAML, JSON, TOML)
- PKGBUILD validation
- Tool binary/script validation

### Integration Tests
Tests for component interaction:
- Filesystem overlay structure
- Security stack integration
- Desktop environment configuration
- Package list consistency

### Installation Tests
VM-based installation validation (requires QEMU):
- ISO boot test
- Calamares installer flow
- Post-installation verification
- Upgrade path testing

### Security Tests
Security posture validation:
- Kernel hardening verification
- AppArmor profile validation
- Firewall rules testing
- Encryption configuration
- Secure Boot chain

## Writing Tests

### Test Function Convention

```bash
test_example_feature() {
    local description="Test that example feature works correctly"
    
    # Test logic here
    if [[ some_condition ]]; then
        pass "$description"
    else
        fail "$description" "Expected X but got Y"
    fi
}
```

### Available Assertions

```bash
pass "description"              # Mark test passed
fail "description" "reason"     # Mark test failed
skip "description" "reason"     # Skip test with reason
assert_eq "actual" "expected" "description"
assert_ne "actual" "unexpected" "description"
assert_file_exists "path" "description"
assert_dir_exists "path" "description"
assert_command_exists "cmd" "description"
assert_file_contains "path" "pattern" "description"
```

## CI Integration

Tests are automatically run in GitHub Actions via `.github/workflows/test.yml`.

### Quality Gates

| Gate | Requirement |
|------|-------------|
| Unit Tests | 100% pass |
| Integration Tests | 100% pass |
| Security Tests | 100% pass |
| Installation Tests | Boot success required |

## Hardware Compatibility Testing

See `HARDWARE-COMPATIBILITY.md` for the hardware testing matrix and procedures.

## Contributing

1. Add tests in the appropriate category directory
2. Follow naming convention: `test-<component>.sh`
3. Use helper functions from `helpers/common.sh`
4. Update this README if adding new test categories

---

**Part of SANCHALA OS** | "Set Your System in Motion"
