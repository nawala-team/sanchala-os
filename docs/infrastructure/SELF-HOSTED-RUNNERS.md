# 🖥️ SANCHALA OS - Self-Hosted Runners Setup

## Overview

Self-hosted runners dramatically reduce ISO build times from 2-3 hours (GitHub-hosted) to 30-45 minutes.

## Why Self-Hosted?

| Aspect | GitHub-Hosted | Self-Hosted |
|--------|---------------|-------------|
| ISO Build Time | 2-3 hours | 30-45 min |
| Package Cache | Limited | Persistent |
| Cost | Free tier limits | Infrastructure cost |
| Control | Limited | Full control |

## Requirements

**Minimum Specs:**
- CPU: 4 cores (8 recommended)
- RAM: 16GB (32GB recommended)
- Storage: 100GB SSD
- Network: 100Mbps+
- OS: Arch Linux, Ubuntu 22.04+, or Debian 12+

**Software:**
- Docker with privileged container support
- Git 2.x

## Setup Guide

### 1. Prepare the Server

```bash
# Arch Linux
pacman -Syu
pacman -S --needed docker git base-devel

# Ubuntu/Debian
apt update && apt upgrade -y
apt install -y docker.io git build-essential

# Enable Docker
systemctl enable --now docker
```

### 2. Create Runner User

```bash
# Create dedicated user
useradd -m -s /bin/bash github-runner
usermod -aG docker github-runner

# Setup directory
mkdir -p /opt/actions-runner
chown github-runner:github-runner /opt/actions-runner
```

### 3. Install GitHub Runner

```bash
su - github-runner
cd /opt/actions-runner

# Download latest runner (check GitHub for current version)
curl -o actions-runner-linux-x64.tar.gz -L \
  https://github.com/actions/runner/releases/download/v2.311.0/actions-runner-linux-x64-2.311.0.tar.gz

tar xzf actions-runner-linux-x64.tar.gz
```

### 4. Register Runner

Get registration token from: Repository → Settings → Actions → Runners → New self-hosted runner

```bash
./config.sh \
  --url https://github.com/YOUR_ORG/sanchala-os \
  --token YOUR_REGISTRATION_TOKEN \
  --name "sanchala-builder-01" \
  --labels "self-hosted,linux,x64,sanchala" \
  --work "_work"
```

### 5. Install as Service

```bash
sudo ./svc.sh install github-runner
sudo ./svc.sh start
sudo ./svc.sh status
```

### 6. Configure Repository

Set repository variable to enable self-hosted runners:
- Go to: Settings → Secrets and variables → Actions → Variables
- Add: `USE_SELF_HOSTED` = `true`

## Persistent Cache Setup

```bash
# Create cache directories
mkdir -p /var/cache/sanchala-build/{pacman,ccache}
chown -R github-runner:github-runner /var/cache/sanchala-build

# Pre-populate pacman cache (optional)
pacman -Syw --cachedir /var/cache/sanchala-build/pacman \
  base base-devel archiso
```

## Security Considerations

1. **Network Isolation:** Run on isolated network segment
2. **Limited Access:** Restrict SSH to authorized IPs only
3. **Regular Updates:** Keep system and runner updated
4. **Audit Logs:** Enable and monitor audit logging
5. **Ephemeral Option:** Consider ephemeral runners for PRs

## Monitoring

```bash
# Check runner status
systemctl status actions.runner.*

# View runner logs
journalctl -u actions.runner.* -f

# Check Docker
docker ps
docker system df
```

## Troubleshooting

### Runner Offline
```bash
# Restart runner service
sudo ./svc.sh stop
sudo ./svc.sh start
```

### Docker Permission Issues
```bash
# Ensure user in docker group
sudo usermod -aG docker github-runner
# Re-login required
```

### Disk Space Issues
```bash
# Clean Docker
docker system prune -af

# Clean old builds
rm -rf /opt/actions-runner/_work/*/
```

## Scaling

For multiple concurrent builds:

```bash
# Install multiple runners
for i in {1..3}; do
  mkdir -p /opt/actions-runner-$i
  # Repeat setup for each runner
done
```

## Cost Estimation

| Provider | Specs | Monthly Cost |
|----------|-------|--------------|
| Hetzner AX41 | 6c/64GB/512GB | ~$45 |
| OVH Rise-1 | 6c/64GB/500GB | ~$55 |
| AWS c5.2xlarge | 8c/16GB | ~$245 |

Self-hosted typically pays off with >50 builds/month.
