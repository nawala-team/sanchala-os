# 🏗️ SANCHALA OS - Infrastructure Overview

## Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         SANCHALA OS INFRASTRUCTURE                          │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐  │
│  │   GitHub    │───▶│   CI/CD     │───▶│  Package    │───▶│   Mirror    │  │
│  │    Repo     │    │  Pipelines  │    │   Repo      │    │   Network   │  │
│  └─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘  │
│                            │                  │                  │          │
│                            ▼                  ▼                  ▼          │
│                     ┌─────────────┐    ┌─────────────┐    ┌─────────────┐  │
│                     │  Artifacts  │    │   Signing   │    │    CDN      │  │
│                     │   Storage   │    │   Service   │    │  (CloudFl.) │  │
│                     └─────────────┘    └─────────────┘    └─────────────┘  │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Components

| Component | Purpose | Technology |
|-----------|---------|------------|
| Source Control | Code hosting | GitHub |
| CI/CD | Build automation | GitHub Actions |
| Package Repository | Package hosting | Custom + rsync |
| Mirror Network | ISO distribution | Geo-distributed servers |
| CDN | Static assets | Cloudflare |
| Monitoring | Infrastructure health | Prometheus + Grafana |

## Documentation Index

- [CI/CD Pipeline Guide](./CI-CD.md)
- [Mirror Infrastructure](./MIRRORS.md)
- [Repository Server Setup](./REPOSITORY-SERVER.md)
- [Self-Hosted Runner Setup](./SELF-HOSTED-RUNNERS.md)
- [Monitoring & Alerting](./MONITORING.md)

## Quick Start

### For Contributors
1. Fork the repository
2. CI runs automatically on PRs
3. Packages built on merge to main

### For Mirror Operators
See [MIRRORS.md](./MIRRORS.md) for joining the mirror network.

### For Infrastructure Admins
See individual guides for setup instructions.

---

**Contact:** infra@sanchala.id
