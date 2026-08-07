# SANCHALA OS - Biometric Authentication Guide

## Fingerprint Setup

### Prerequisites

```bash
# Install required packages
sudo pacman -S fprintd libfprint

# Start the service
sudo systemctl enable --now fprintd.service
```

### Enrollment

```bash
# Guided setup (recommended)
sanchala-fingerprint setup

# Manual enrollment
fprintd-enroll -f right-index-finger

# List enrolled
fprintd-list $USER

# Delete all
fprintd-delete $USER
```

### Supported Hardware

| Vendor | Models | Driver |
|--------|--------|--------|
| Goodix | MOC sensors | goodixmoc |
| Synaptics | ThinkPad, Dell | synaptics |
| Elan | Various laptops | elan |
| Validity | Older ThinkPads | validity |

### Troubleshooting

**No scanner detected:**
```bash
# Check device
lsusb | grep -i finger

# Check driver
sudo dmesg | grep -i fingerprint

# Some scanners need proprietary firmware
# Check Arch Wiki for your specific model
```

**Verification fails:**
```bash
# Re-enroll with better quality
fprintd-delete $USER
fprintd-enroll -f right-index-finger

# Use multiple angles during enrollment
```

---

## FIDO2/WebAuthn Setup

### Prerequisites

```bash
# Install required packages
sudo pacman -S pam-u2f libfido2

# Add udev rules for security keys
sudo pacman -S libu2f-host
```

### Key Enrollment

```bash
# Guided setup
sanchala-fido2 setup

# Manual enrollment
pamu2fcfg -u $USER | sudo tee -a /etc/sanchala/identity/u2f_keys

# Multiple keys (append)
pamu2fcfg -u $USER -n | sudo tee -a /etc/sanchala/identity/u2f_keys
```

### Key Management

```bash
# List connected keys
fido2-token -L

# Key information
fido2-token -I /dev/hidraw0

# Set/change PIN
fido2-token -S /dev/hidraw0

# Factory reset (DESTRUCTIVE)
fido2-token -R /dev/hidraw0
```

### Resident Keys (Passkeys)

```bash
# Create resident credential
fido2-cred -M -r -i cred_param /dev/hidraw0

# List resident credentials
fido2-token -L -r /dev/hidraw0

# Delete resident credential
fido2-token -D -r /dev/hidraw0 <cred_id>
```

### Supported Keys

- **YubiKey 5 Series**: Full FIDO2, NFC, USB-A/C
- **YubiKey Security Key**: FIDO2 only, affordable
- **SoloKey v2**: Open source, USB-A/C
- **Google Titan**: USB-A/C, NFC, Bluetooth
- **Thetis**: Budget FIDO2, USB-A
- **Feitian ePass**: Enterprise, various form factors

---

## Best Practices

### Recommended Setup

1. **Primary**: Enroll 2-3 fingerprints (index fingers + thumb)
2. **Backup**: Register 1-2 FIDO2 keys
3. **Emergency**: Keep strong password memorized

### Security Tips

- Register backup authentication before primary
- Store backup FIDO2 key in secure location
- Use different fingers for different security levels
- Enable PIN on FIDO2 keys

### What NOT to do

- Don't rely on single fingerprint only
- Don't skip password setup
- Don't share FIDO2 keys between users
- Don't use wet/dirty fingers for enrollment

---

## Integration Points

### Sudo with Biometric

```bash
# Test
sudo -k
sudo echo "Touch fingerprint or security key"
```

### Polkit (GUI Prompts)

System prompts automatically use biometric when configured.

### Screen Lock

Fingerprint works immediately after screen locks.

### GNOME/KDE Keyring

Auto-unlocks with login authentication.

---

Version: 2.0 | See also: IDENTITY.md, PAM-REFERENCE.md
