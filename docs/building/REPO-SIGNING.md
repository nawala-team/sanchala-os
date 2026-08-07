# Sanchala OS - Repository Signing Key Specification

## Overview

Sanchala OS uses GPG signing for package integrity and authenticity. All packages
in the official Sanchala repository must be signed by an authorized key.

## Key Specification

### Master Signing Key

| Property | Value |
|----------|-------|
| **Key Type** | RSA |
| **Key Size** | 4096 bits |
| **Expiration** | 5 years (renewable) |
| **Usage** | Certify only (master key) |
| **UID** | `Sanchala OS Master Key <master@sanchala.id>` |
| **Key ID** | To be generated |

### Package Signing Subkey

| Property | Value |
|----------|-------|
| **Key Type** | RSA |
| **Key Size** | 4096 bits |
| **Expiration** | 2 years (renewable) |
| **Usage** | Sign only |
| **UID** | `Sanchala OS Package Signing <packages@sanchala.id>` |

### Repository Database Signing Key

| Property | Value |
|----------|-------|
| **Key Type** | RSA |
| **Key Size** | 4096 bits |
| **Expiration** | 2 years (renewable) |
| **Usage** | Sign only |
| **UID** | `Sanchala OS Repository <repo@sanchala.id>` |

## Key Generation Procedure

### 1. Generate Master Key

```bash
# Generate master key (air-gapped machine recommended)
gpg --full-generate-key --expert

# Select: (8) RSA (set your own capabilities)
# Toggle: S, E off - leave only Certify
# Key size: 4096
# Expiration: 5y
# Real name: Sanchala OS Master Key
# Email: master@sanchala.id
```

### 2. Generate Signing Subkeys

```bash
# Add package signing subkey
gpg --edit-key master@sanchala.id
> addkey
# Select: (4) RSA (sign only)
# Key size: 4096
# Expiration: 2y

# Add repository signing subkey
> addkey
# Repeat for repo signing

> save
```

### 3. Export Public Keys

```bash
# Export for distribution
gpg --armor --export master@sanchala.id > sanchala.gpg

# Export for pacman keyring
gpg --export master@sanchala.id > /usr/share/pacman/keyrings/sanchala.gpg
```

### 4. Create Keyring Files

```bash
# sanchala-trusted (key fingerprints to trust)
echo "FINGERPRINT:4:" > sanchala-trusted

# sanchala-revoked (empty initially)
touch sanchala-revoked
```

## Pacman Integration

### pacman.conf Configuration

```ini
[sanchala]
SigLevel = Required DatabaseRequired
Server = https://repo.sanchala.id/packages/$arch
```

### Trust Levels

| SigLevel | Description |
|----------|-------------|
| `Required` | Package signatures required |
| `DatabaseRequired` | Database signature required |
| `TrustedOnly` | Only accept keys in keyring |

## Package Signing Workflow

### Sign a Package

```bash
# Sign package with repo key
gpg --detach-sign --no-armor -u packages@sanchala.id package-1.0-1-x86_64.pkg.tar.zst

# Verify signature
gpg --verify package-1.0-1-x86_64.pkg.tar.zst.sig
```

### Add to Repository

```bash
# Add package and sign database
repo-add --sign --key packages@sanchala.id sanchala.db.tar.gz package-*.pkg.tar.zst
```

## Key Storage & Security

### Master Key Storage

- Store on air-gapped machine or hardware security module (HSM)
- Keep encrypted backup in secure location
- Never expose to networked systems

### Signing Key Distribution

- Signing subkeys can be on build servers
- Use GPG agent forwarding for CI/CD
- Rotate keys every 2 years

### Revocation

```bash
# Generate revocation certificate (do this immediately after key creation)
gpg --gen-revoke master@sanchala.id > revoke-master.asc

# Store securely, separate from the key itself
```

## Keyring Package

The `sanchala-keyring` package contains:

```
/usr/share/pacman/keyrings/
├── sanchala.gpg          # Public keys
├── sanchala-trusted      # Trusted key fingerprints
└── sanchala-revoked      # Revoked key fingerprints
```

### Installation Hook

```bash
# sanchala-keyring.install
post_install() {
    pacman-key --populate sanchala
}

post_upgrade() {
    pacman-key --populate sanchala
}
```

## Verification Commands

```bash
# List Sanchala keys
pacman-key --list-keys | grep -A2 sanchala

# Verify a package manually
gpg --verify package.pkg.tar.zst.sig package.pkg.tar.zst

# Check database signature
gpg --verify sanchala.db.tar.gz.sig sanchala.db.tar.gz
```

## Emergency Procedures

### Key Compromise

1. Generate revocation certificate
2. Upload to keyservers
3. Update `sanchala-revoked` in keyring package
4. Push emergency keyring update
5. Generate new signing keys
6. Re-sign all packages

### Key Expiration

1. Extend expiration on master key (if not compromised)
2. Generate new signing subkeys
3. Update keyring package
4. Transition period: accept both old and new signatures

## CI/CD Integration

### GitHub Actions Example

```yaml
- name: Import GPG Key
  run: |
    echo "${{ secrets.GPG_SIGNING_KEY }}" | gpg --import
    echo "${{ secrets.GPG_PASSPHRASE }}" | gpg --batch --yes --passphrase-fd 0 \
      --pinentry-mode loopback --sign /dev/null

- name: Sign Package
  run: |
    gpg --detach-sign --no-armor -u packages@sanchala.id *.pkg.tar.zst
```

## References

- [Arch Wiki: Pacman Package Signing](https://wiki.archlinux.org/title/Pacman/Package_signing)
- [GnuPG Best Practices](https://riseup.net/en/security/message-security/openpgp/best-practices)
- [Debian Secure APT](https://wiki.debian.org/SecureApt)

---

*Sanchala OS Security Team*
