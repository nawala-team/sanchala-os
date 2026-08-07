# Sanchala OS Release Workflow

> End-to-end release automation and CI/CD pipeline

## Overview

This document describes the automated release workflow from development to distribution.

---

## Release Pipeline

```
┌─────────────────────────────────────────────────────────────────┐
│                    RELEASE PIPELINE                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  [Commit] ──► [CI Tests] ──► [Build] ──► [Test] ──► [Release]  │
│     │            │            │           │            │        │
│   Push       Lint/Test    ISO Build    QA/Boot     Publish     │
│   Tag        Security     Packages     Verify      Mirrors     │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Workflow Triggers

| Trigger | Action | Channel |
|---------|--------|---------|
| Push to `main` | Build + test | Nightly |
| Push to `develop` | Build only | Dev |
| Tag `v*` | Full release | Stable/Beta |
| Schedule (daily) | Nightly build | Nightly |
| Manual dispatch | Custom build | Any |

---

## GitHub Actions Workflows

### 1. Test Workflow (test.yml)

Runs on every push and PR.

```yaml
name: Test
on: [push, pull_request]
jobs:
  lint:
    - ShellCheck on scripts
    - YAML validation
    - Markdown linting
  
  unit-test:
    - Package build tests
    - Configuration validation
  
  security:
    - Secret scanning
    - Dependency audit
```

### 2. Build ISO Workflow (build-iso.yml)

Builds the distribution ISO.

```yaml
name: Build ISO
on:
  push:
    tags: ['v*']
  workflow_dispatch:

jobs:
  validate:
    - Syntax check build scripts
    - Determine version from tag
  
  build:
    - Setup Arch container
    - Install dependencies
    - Run iso/build-binary
    - Generate checksums
  
  test:
    - Boot test with QEMU
    - Verify checksums
  
  release:
    - Create GitHub Release
    - Upload artifacts
    - Trigger mirror sync
```

### 3. Package Build Workflow (package-build.yml)

Builds individual packages.

```yaml
name: Build Packages
on:
  push:
    paths: ['pkgbuilds/**']

jobs:
  detect:
    - Find changed packages
  
  build:
    - Build with makepkg
    - Validate with namcap
  
  publish:
    - Upload to package repo
```

---

## Release Process

### Automated Steps

```bash
# 1. Tag the release
git tag -s v1.0.0 -m "Release 1.0.0 (Gati)"
git push origin v1.0.0

# 2. CI automatically:
#    - Builds ISO
#    - Runs tests
#    - Generates checksums
#    - Creates GitHub Release
#    - Uploads artifacts
```

### Manual Verification

Before tagging:
- [ ] All CI checks passing
- [ ] Release checklist complete
- [ ] Changelog updated
- [ ] Version files updated

After CI completes:
- [ ] Download and verify ISO
- [ ] Test on real hardware
- [ ] Approve GitHub Release
- [ ] Trigger mirror sync

---

## Version Detection Logic

```bash
#!/bin/bash
# Used in CI to determine version

if [[ "$GITHUB_REF" == refs/tags/v* ]]; then
    # Tagged release: v1.0.0 -> 1.0.0
    VERSION="${GITHUB_REF#refs/tags/v}"
elif [[ "$GITHUB_REF" == refs/heads/main ]]; then
    # Main branch: rolling date
    VERSION="$(date +%Y.%m.%d)-$(git rev-parse --short HEAD)"
else
    # Other branches: dev build
    BRANCH="${GITHUB_REF#refs/heads/}"
    VERSION="dev-${BRANCH}-$(git rev-parse --short HEAD)"
fi

echo "VERSION=$VERSION"
```

---

## Artifact Management

### Build Outputs

| Artifact | Retention | Location |
|----------|-----------|----------|
| ISO (release) | Permanent | GitHub Releases |
| ISO (PR/dev) | 30 days | GitHub Artifacts |
| Packages | Permanent | Package repo |
| Checksums | With ISO | GitHub Releases |
| SBOM | 90 days | GitHub Artifacts |

### Checksum Generation

```bash
# Generated for every ISO
sha256sum "$ISO" > "${ISO}.sha256"
sha512sum "$ISO" > "${ISO}.sha512"
b2sum "$ISO" > "${ISO}.b2sum"

# GPG signature (releases only)
gpg --armor --detach-sign "$ISO"
```

---

## Mirror Sync Automation

```yaml
# Triggered after successful release
mirror-sync:
  needs: release
  steps:
    - name: Trigger CDN purge
      run: curl -X POST "$CDN_PURGE_URL"
    
    - name: Notify mirrors
      run: |
        for mirror in $MIRROR_ENDPOINTS; do
          curl -X POST "$mirror/sync-trigger"
        done
    
    - name: Verify propagation
      run: ./scripts/verify-mirror-sync.sh
```

---

## Rollback Procedure

### Automated Rollback

```yaml
rollback:
  if: failure()
  steps:
    - name: Delete failed release
      run: gh release delete "v$VERSION" --yes
    
    - name: Remove tag
      run: git push --delete origin "v$VERSION"
    
    - name: Notify team
      run: ./scripts/notify-failure.sh
```

### Manual Rollback

```bash
# 1. Delete GitHub release
gh release delete v1.0.0 --yes

# 2. Remove git tag
git tag -d v1.0.0
git push origin :refs/tags/v1.0.0

# 3. Revert mirrorlist to previous version
# 4. Post incident report
```

---

## Secrets Management

| Secret | Purpose | Rotation |
|--------|---------|----------|
| `GITHUB_TOKEN` | Release creation | Auto |
| `GPG_PRIVATE_KEY` | ISO signing | Yearly |
| `REPO_SSH_KEY` | Package upload | Yearly |
| `CDN_API_TOKEN` | Cache purge | Quarterly |

---

## Monitoring

### Build Metrics

- Build duration
- Success/failure rate
- Artifact sizes
- Test coverage

### Release Metrics

- Download counts
- Mirror sync times
- Geographic distribution
- Error reports

---

## Quick Reference

```bash
# Trigger nightly build
gh workflow run build-iso.yml

# Trigger release build
git tag -s v1.0.0 && git push origin v1.0.0

# Check workflow status
gh run list --workflow=build-iso.yml

# Download artifacts
gh run download <run-id>
```
