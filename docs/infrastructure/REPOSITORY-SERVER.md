# 📦 SANCHALA OS - Repository Server Setup

## Overview

This guide covers setting up the Sanchala OS package repository server that hosts custom packages built by the CI/CD pipeline.

## Architecture

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  GitHub     │────▶│  Repo       │────▶│   Users     │
│  Actions    │ SSH │  Server     │HTTP │  (pacman)   │
└─────────────┘     └─────────────┘     └─────────────┘
                           │
                           ▼
                    ┌─────────────┐
                    │   Mirrors   │
                    └─────────────┘
```

## Server Requirements

- **OS:** Arch Linux (recommended) or any Linux
- **CPU:** 2+ cores
- **RAM:** 4GB+
- **Storage:** 100GB+ SSD
- **Bandwidth:** 100Mbps+

## Installation

### 1. Base Setup

```bash
# Update system
pacman -Syu

# Install required packages
pacman -S --needed \
  nginx \
  rsync \
  gnupg \
  pacman-contrib \
  certbot \
  certbot-nginx

# Create repository structure
mkdir -p /srv/repo/sanchala/{x86_64,sources}
chown -R http:http /srv/repo
```

### 2. GPG Key Setup

```bash
# Generate repository signing key
gpg --full-generate-key
# Choose: RSA, 4096 bits, no expiration
# Name: Sanchala OS Repository
# Email: repo@sanchala.id

# Export public key
gpg --export -a "Sanchala OS Repository" > /srv/repo/sanchala.gpg

# Note the key ID for signing
gpg --list-keys --keyid-format long
```

### 3. Repository Database Scripts

```bash
# /usr/local/bin/repo-add-package
#!/bin/bash
# Add a package to the repository

REPO_PATH="/srv/repo/sanchala/x86_64"
REPO_NAME="sanchala"
GPG_KEY="YOUR_KEY_ID"  # Replace with actual key

set -e

for pkg in "$@"; do
    if [[ -f "$pkg" ]]; then
        cp "$pkg" "$REPO_PATH/"
        repo-add --sign --key "$GPG_KEY" \
            "$REPO_PATH/$REPO_NAME.db.tar.gz" \
            "$REPO_PATH/$(basename "$pkg")"
        echo "Added: $(basename "$pkg")"
    fi
done

echo "Repository updated"
```

```bash
# /usr/local/bin/repo-remove-package
#!/bin/bash
# Remove a package from the repository

REPO_PATH="/srv/repo/sanchala/x86_64"
REPO_NAME="sanchala"
GPG_KEY="YOUR_KEY_ID"

for pkg in "$@"; do
    repo-remove --sign --key "$GPG_KEY" \
        "$REPO_PATH/$REPO_NAME.db.tar.gz" "$pkg"
    rm -f "$REPO_PATH/$pkg"*.pkg.tar.*
    echo "Removed: $pkg"
done
```

### 4. Nginx Configuration

```nginx
# /etc/nginx/sites-available/sanchala-repo
server {
    listen 80;
    server_name repo.sanchala.id;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name repo.sanchala.id;

    ssl_certificate /etc/letsencrypt/live/repo.sanchala.id/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/repo.sanchala.id/privkey.pem;

    root /srv/repo/sanchala;
    autoindex on;

    # Security headers
    add_header X-Content-Type-Options nosniff;
    add_header X-Frame-Options DENY;

    location / {
        try_files $uri $uri/ =404;
    }

    # Cache static files
    location ~* \.(pkg\.tar\.(zst|xz)|db|sig|files)$ {
        expires 1h;
        add_header Cache-Control "public, immutable";
    }
}
```

### 5. CI/CD Upload Access

```bash
# Create upload user
useradd -r -m -d /srv/repo -s /bin/bash repo-upload

# Setup SSH key authentication
mkdir -p /srv/repo/.ssh
# Add CI/CD public key to authorized_keys
cat >> /srv/repo/.ssh/authorized_keys << 'EOF'
# Restrict to rsync only
command="rsync --server -vlogDtprze.iLsfxCIvu . /srv/repo/incoming/",no-port-forwarding,no-X11-forwarding,no-agent-forwarding ssh-ed25519 AAAA... github-actions
EOF

chmod 700 /srv/repo/.ssh
chmod 600 /srv/repo/.ssh/authorized_keys
chown -R repo-upload:repo-upload /srv/repo/.ssh

# Create incoming directory
mkdir -p /srv/repo/incoming
chown repo-upload:repo-upload /srv/repo/incoming
```

### 6. Automatic Package Processing

```bash
# /usr/local/bin/process-incoming
#!/bin/bash
# Process uploaded packages

INCOMING="/srv/repo/incoming"
REPO_PATH="/srv/repo/sanchala/x86_64"

cd "$INCOMING"

for pkg in *.pkg.tar.*; do
    [[ -f "$pkg" ]] || continue
    
    # Verify package
    if pacman -Qp "$pkg" &>/dev/null; then
        /usr/local/bin/repo-add-package "$pkg"
        rm "$pkg"
    else
        echo "Invalid package: $pkg"
        mv "$pkg" "$INCOMING/failed/"
    fi
done
```

```bash
# Systemd service for watching incoming
# /etc/systemd/system/repo-watcher.service
[Unit]
Description=Repository Package Watcher
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/inotifywait -m -e close_write /srv/repo/incoming --format '%f' | while read f; do /usr/local/bin/process-incoming; done
Restart=always
User=root

[Install]
WantedBy=multi-user.target
```

## Client Configuration

Add to `/etc/pacman.conf`:

```ini
[sanchala]
SigLevel = Required DatabaseOptional
Server = https://repo.sanchala.id/$arch
```

Import the signing key:
```bash
sudo pacman-key --recv-keys YOUR_KEY_ID --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key YOUR_KEY_ID

# Or from file
curl -sL https://repo.sanchala.id/sanchala.gpg | sudo pacman-key --add -
```

## Maintenance

### Cleanup Old Packages
```bash
# Keep only latest 2 versions of each package
paccache -rk2 -c /srv/repo/sanchala/x86_64/
```

### Backup
```bash
# Backup repository database and keys
tar -czf repo-backup-$(date +%Y%m%d).tar.gz \
  /srv/repo/sanchala/*.db* \
  /srv/repo/sanchala/*.files* \
  /root/.gnupg/
```

## Monitoring

Monitor these metrics:
- Disk usage
- HTTP response times
- Package sync status
- SSL certificate expiry

See [MONITORING.md](./MONITORING.md) for Prometheus/Grafana setup.
