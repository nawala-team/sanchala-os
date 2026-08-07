# SANCHALA OS - Keyring & Secret Management

## Overview

Sanchala OS provides secure secret storage through GNOME Keyring
(default) or KWallet (KDE), with automatic unlock on login via PAM.

## GNOME Keyring

### What it stores
- WiFi passwords
- Application passwords (browsers, email clients)
- SSH key passphrases
- GPG key passphrases
- Website credentials

### Installation

```bash
sudo pacman -S gnome-keyring libsecret seahorse
```

### Configuration

Auto-unlock is configured in PAM:

```
# /etc/pam.d/system-auth
auth     optional  pam_gnome_keyring.so
session  optional  pam_gnome_keyring.so auto_start

# /etc/pam.d/gdm-password
password optional  pam_gnome_keyring.so use_authtok
```

### User Configuration

`~/.config/sanchala/keyring/keyring.conf`:

```ini
[keyring]
default-keyring = login
auto-unlock-login = true
lock-on-screenlock = false

[storage]
encryption = aes-256-gcm
key-derivation = argon2id

[integration]
ssh-agent = true
secret-service = true
```

### Management

```bash
# CLI tool
sanchala-keyring status
sanchala-keyring lock
sanchala-keyring unlock

# GUI tool
seahorse
```

### Secret Tool CLI

```bash
# Store a secret
secret-tool store --label="My API Key" service myapp username apikey

# Retrieve a secret
secret-tool lookup service myapp username apikey

# Search secrets
secret-tool search service myapp

# Clear a secret
secret-tool clear service myapp username apikey
```

---

## KWallet (KDE/Plasma)

### Installation

```bash
sudo pacman -S kwallet kwalletmanager
```

### Configuration

PAM auto-unlock:

```
# /etc/pam.d/sddm
auth     optional  pam_kwallet5.so
session  optional  pam_kwallet5.so auto_start
```

User config `~/.config/kwalletrc`:

```ini
[Wallet]
Enabled=true
Default Wallet=kdewallet

[PAM]
Enabled=true
```

### Management

```bash
# CLI query
kwallet-query -l kdewallet

# GUI
kwalletmanager5
```

---

## TPM-Backed Secrets (Advanced)

For highest security, secrets can be sealed to TPM:

```bash
# Seal secret to TPM
echo "mysecret" | tpm2_create -C primary.ctx -i- -u seal.pub -r seal.priv

# Unseal (only works on same machine, same boot state)
tpm2_unseal -c seal.ctx
```

This ensures secrets are only accessible when:
- Hardware hasn't changed
- Boot chain is unmodified
- TPM PCRs match expected values

---

## Application Integration

### Flatpak Apps

Flatpak apps access keyring via Secret Service D-Bus API.
Grant permission in Flatseal or:

```bash
flatpak override --user --talk-name=org.freedesktop.secrets com.app.Name
```

### Browsers

- **Firefox**: Uses native keyring automatically
- **Brave/Chrome**: Enable "Use keyring" in settings
- **GNOME Web**: Native integration

### SSH Keys

```bash
# Start SSH agent with keyring
eval $(gnome-keyring-daemon --start --components=ssh)
export SSH_AUTH_SOCK

# Add key (passphrase stored in keyring)
ssh-add ~/.ssh/id_ed25519
```

---

## Security Notes

1. **Keyring password = login password** for auto-unlock
2. Change keyring password if login password changes
3. Keyring is encrypted at rest with AES-256
4. Lock keyring when stepping away: `sanchala-keyring lock`
5. Backup keyrings: `~/.local/share/keyrings/`

---

Version: 2.0 | See also: IDENTITY.md
