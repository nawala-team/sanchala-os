# 🎯 SANCHALA OS - Test Strategy

## Philosophy

Sanchala OS follows a **security-first, quality-always** testing philosophy. Every change must pass automated tests before merge, and security-sensitive components require additional validation.

## Test Pyramid

```
                    ┌─────────────────┐
                    │   E2E / ISO     │  ← Slow, comprehensive
                    │   Boot Tests    │
                   ─┴─────────────────┴─
                  ┌───────────────────────┐
                  │   Installation Tests  │  ← VM-based validation
                 ─┴───────────────────────┴─
                ┌─────────────────────────────┐
                │     Integration Tests       │  ← Component interaction
               ─┴─────────────────────────────┴─
              ┌───────────────────────────────────┐
              │          Security Tests           │  ← Hardening validation
             ─┴───────────────────────────────────┴─
            ┌─────────────────────────────────────────┐
            │              Unit Tests                 │  ← Fast, isolated
            └─────────────────────────────────────────┘
```

## Test Categories

### 1. Unit Tests (Fast - <30s each)
- Shell script syntax validation
- Configuration file parsing (YAML, JSON, TOML)
- PKGBUILD validation
- Individual tool validation

**Runs:** Every push, every PR

### 2. Integration Tests (Medium - <2min each)
- Filesystem structure validation
- Security stack integration
- Package list consistency
- Desktop configuration

**Runs:** Every push, every PR

### 3. Security Tests (Medium - <5min each)
- Kernel hardening validation
- AppArmor profile checks
- Encryption configuration
- Secure defaults verification

**Runs:** Every push, every PR, weekly scheduled

### 4. Installation Tests (Slow - 10-30min)
- ISO boot validation (QEMU)
- Calamares installer flow
- Post-installation verification

**Runs:** Main branch, releases, manual trigger

## Testing Environments

| Environment | Purpose | Trigger |
|-------------|---------|---------|
| GitHub Actions | CI/CD automation | Push, PR, schedule |
| Self-Hosted Runner | Fast ISO builds | Main branch, tags |
| Local Development | Developer testing | Manual |
| Hardware Lab | Physical testing | Release candidates |

## Test Data Management

- **Fixtures:** Static test data in `tests/fixtures/`
- **Mocks:** No external service dependencies in unit tests
- **Isolation:** Each test cleans up after itself

## Flaky Test Policy

1. Flaky tests are bugs - fix immediately
2. Quarantine genuinely flaky tests (mark as skip with reason)
3. Maximum 48h quarantine before fix or removal
4. No sleeping in tests - use proper synchronization

## Code Coverage

While we don't enforce coverage percentages, we require:
- All security-critical paths tested
- All user-facing features tested
- Regression tests for every bug fix

## Testing New Features

1. Write tests alongside feature code
2. Include positive and negative cases
3. Security features require dedicated security tests
4. Update documentation

## Release Testing

Before each release:
1. Full test suite passes (100%)
2. ISO boots on QEMU (BIOS + UEFI)
3. Manual installation test on physical hardware
4. Security audit on security-sensitive changes
5. Performance baseline comparison

---

_Maintainer: qa-lead_
