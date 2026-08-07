# 🔄 SANCHALA OS - CI/CD Pipeline Documentation

## Overview

Sanchala OS uses GitHub Actions for continuous integration and delivery with support for self-hosted runners for faster builds.

## Workflows

### 1. Build ISO (`build-iso.yml`)

**Triggers:**
- Push to `main` or `develop` branches
- Tags matching `v*`
- Pull requests to `main`
- Manual dispatch

**Pipeline Stages:**
```
validate → build → test → release
```

**Features:**
- Automatic version detection from tags/commits
- Package caching for faster builds
- QEMU-based boot testing
- Automatic GitHub releases on tags
- Self-hosted runner support

### 2. Package Build (`package-build.yml`)

**Triggers:**
- Changes to `pkgbuilds/**`
- Manual dispatch with package selection

**Features:**
- Automatic change detection
- Matrix builds for multiple packages
- namcap validation
- Repository publishing (on main)

### 3. Security Scan (`security-scan.yml`)

**Triggers:**
- Push/PR to main branches
- Weekly scheduled scan
- Manual dispatch

**Checks:**
- ShellCheck for shell scripts
- Secret detection with TruffleHog
- PKGBUILD auditing with namcap
- Security configuration validation
- SBOM generation

### 4. Tests (`test.yml`)

**Triggers:**
- All pushes and PRs

**Includes:**
- Shell script syntax validation
- YAML validation
- Package list verification
- Filesystem structure checks

## Configuration

### Required Secrets

| Secret | Purpose | Required |
|--------|---------|----------|
| `GITHUB_TOKEN` | Auto-provided for releases | Yes |
| `SANCHALA_REPO_URL` | Custom package repository | No |
| `GPG_PRIVATE_KEY` | Artifact signing | No |
| `GPG_PASSPHRASE` | GPG key passphrase | No |
| `REPO_SSH_KEY` | Package upload access | No |

### Repository Variables

| Variable | Purpose | Default |
|----------|---------|---------|
| `USE_SELF_HOSTED` | Use self-hosted runners | `false` |
| `REPO_UPLOAD_URL` | Package repo rsync URL | - |
| `MIRROR_WEBHOOK_URL` | Mirror sync notification | - |

## Self-Hosted Runners

For faster builds (ISO build can take 60-180 minutes), configure self-hosted runners:

1. Go to Repository → Settings → Actions → Runners
2. Add new self-hosted runner
3. Set `USE_SELF_HOSTED=true` in repository variables

**Runner Requirements:**
- Linux x86_64 (Arch Linux preferred)
- 8GB+ RAM
- 50GB+ free disk space
- Docker installed
- Privileged container support

See [SELF-HOSTED-RUNNERS.md](./SELF-HOSTED-RUNNERS.md) for detailed setup.

## Build Artifacts

### ISO Artifacts
- `sanchala-{version}-{codename}-x86_64.iso`
- `.sha256`, `.sha512`, `.b2sum` checksums
- `.asc` GPG signatures (if configured)

### Package Artifacts
- `{pkgname}-{version}-{arch}.pkg.tar.zst`

Retention: 30 days (main branch), 7 days (other branches)

## Caching Strategy

| Cache | Key | Purpose |
|-------|-----|---------|
| Pacman packages | `pacman-{hash of package lists}` | Speed up package installation |
| ccache | `ccache-{edition}` | Compiler cache |

## Troubleshooting

### Build Timeout
- ISO builds may take 2-3 hours on GitHub-hosted runners
- Consider self-hosted runners for production
- Check for network issues in package downloads

### Package Not Found
- Verify package exists in Arch repos
- AUR packages require custom repository setup
- Check package list syntax (no trailing spaces)

### Boot Test Failures
- May be QEMU compatibility issues
- Check boot.log artifact for details
- Boot tests are informational, not blocking

## Extending the Pipeline

### Adding New Workflows
```yaml
# .github/workflows/my-workflow.yml
name: My Workflow
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      # Add your steps
```

### Adding Package Builds
1. Create `pkgbuilds/{package-name}/PKGBUILD`
2. Push to repository
3. Package-build workflow auto-detects and builds
