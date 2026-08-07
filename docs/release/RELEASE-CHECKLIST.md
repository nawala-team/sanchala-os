# Sanchala OS Release Checklist

> Comprehensive pre-release verification and sign-off procedures

## Overview

This checklist must be completed for every stable release. Each section requires explicit sign-off from the responsible party before proceeding to the next phase.

---

## Phase 1: Pre-Release Preparation (T-14 days)

### 1.1 Version Management

- [ ] Version number finalized and approved
- [ ] Codename confirmed (current: Gati)
- [ ] CHANGELOG.md updated with all changes
- [ ] VERSION file updated in repository root
- [ ] All version references synchronized

### 1.2 Feature Completeness

- [ ] All planned features merged to main
- [ ] Feature freeze announced
- [ ] No pending feature PRs
- [ ] Feature documentation complete

### 1.3 Dependency Audit

- [ ] Package lists reviewed (`iso/packages/*.list`)
- [ ] Package versions pinned where necessary
- [ ] AUR package availability confirmed
- [ ] No deprecated packages in tree

**Sign-off:** _______________ (Release Manager) Date: ___________

---

## Phase 2: Quality Assurance (T-10 days)

### 2.1 Automated Testing

- [ ] All CI pipelines passing
- [ ] Unit test coverage ≥80%
- [ ] Integration tests passing
- [ ] Security scan completed

### 2.2 Manual Testing Matrix

| Test Case | UEFI | BIOS | VM | Hardware |
|-----------|------|------|-----|----------|
| Live boot | [ ] | [ ] | [ ] | [ ] |
| Full install | [ ] | [ ] | [ ] | [ ] |
| Encrypted install | [ ] | [ ] | [ ] | [ ] |
| First boot | [ ] | [ ] | [ ] | [ ] |
| Network | [ ] | [ ] | [ ] | [ ] |
| Graphics | [ ] | [ ] | [ ] | [ ] |
| Audio | [ ] | [ ] | [ ] | [ ] |
| Suspend/resume | [ ] | [ ] | [ ] | [ ] |

### 2.3 Hardware Compatibility

- [ ] Tested on 3+ hardware configs
- [ ] NVIDIA/AMD/Intel graphics verified
- [ ] Touchpad functionality confirmed
- [ ] Webcam functionality confirmed

**Sign-off:** _______________ (QA Lead) Date: ___________

---

## Phase 3: Security Verification (T-7 days)

### 3.1 Security Audit

- [ ] Upstream security patches applied
- [ ] CVE database checked
- [ ] Kernel hardening verified
- [ ] AppArmor profiles enforcing
- [ ] Firewall rules validated

### 3.2 Cryptographic Verification

- [ ] GPG signing keys valid (6+ months)
- [ ] ISO signing tested
- [ ] Secure boot compatibility verified

### 3.3 Privacy Compliance

- [ ] No telemetry by default
- [ ] Privacy policy current
- [ ] Third-party connections documented

**Sign-off:** _______________ (Security Lead) Date: ___________

---

## Phase 4: Build Verification (T-5 days)

### 4.1 ISO Build

- [ ] Clean build successful
- [ ] Build reproducible
- [ ] Build time <3 hours
- [ ] No build errors/warnings

### 4.2 ISO Integrity

- [ ] ISO size 2.5-4.0 GB
- [ ] SHA256/SHA512 checksums generated
- [ ] GPG signature created



---

## Phase 5: Documentation (T-3 days)

### 5.1 Release Documentation

- [ ] Release notes written and reviewed
- [ ] Known issues documented
- [ ] Upgrade path documented
- [ ] Breaking changes highlighted

### 5.2 Website Updates

- [ ] Download page updated
- [ ] Documentation reflects new features
- [ ] System requirements current

### 5.3 Community Communication

- [ ] Release announcement prepared
- [ ] Social media posts scheduled
- [ ] Community forums notified

**Sign-off:** _______________ (Documentation Lead) Date: ___________

---

## Phase 6: Distribution Preparation (T-2 days)

### 6.1 Mirror Synchronization

- [ ] Primary mirror upload complete
- [ ] CDN cache purged/prewarmed
- [ ] Mirror sync verified (≥3 mirrors)
- [ ] Download links tested

### 6.2 Update Infrastructure

- [ ] Package repository updated
- [ ] Delta update packages generated
- [ ] Rollback packages prepared

### 6.3 Torrent Distribution

- [ ] Torrent file created
- [ ] Initial seeders configured (≥5)
- [ ] Magnet link generated

**Sign-off:** _______________ (Infrastructure Lead) Date: ___________

---

## Phase 7: Release Execution (T-0)

### 7.1 Final Verification

- [ ] All phase sign-offs complete
- [ ] No critical bugs open
- [ ] Rollback plan documented
- [ ] Support team briefed

### 7.2 Release Actions

- [ ] Git tag created: `git tag -s vX.Y.Z`
- [ ] GitHub Release created
- [ ] Download page activated
- [ ] Announcement published

### 7.3 Post-Release Monitoring

- [ ] Download stats monitored
- [ ] Error reporting checked
- [ ] Community feedback monitored
- [ ] Mirror health verified

**Sign-off:** _______________ (Release Manager) Date: ___________

---

## Emergency Procedures

### Release Abort Criteria

Abort release if:
1. **Critical CVE** - Unpatched CVSS ≥9.0
2. **Data Loss Bug** - Any data loss potential
3. **Boot Failure** - >10% hardware failure rate
4. **Installation Failure** - Standard configs fail

### Hotfix Process

1. Branch: `git checkout -b hotfix/X.Y.Z+1`
2. Minimal fix only
3. Fast-track QA
4. Release within 48 hours

---

## Summary

| Phase | Owner | Status |
|-------|-------|--------|
| Pre-Release | Release Manager | ⬜ |
| QA | QA Lead | ⬜ |
| Security | Security Lead | ⬜ |
| Build | Build Engineer | ⬜ |
| Documentation | Doc Lead | ⬜ |
| Distribution | Infrastructure | ⬜ |
| Release | Release Manager | ⬜ |

### 4.3 Boot Verification

- [ ] UEFI boot successful
- [ ] Legacy BIOS boot successful
- [ ] Boot menu displays correctly

**Sign-off:** _______________ (Build Engineer) Date: ___________
