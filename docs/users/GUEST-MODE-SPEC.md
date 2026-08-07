# 🔐 SANCHALA OS - Guest Mode Implementation Specification

## Overview

Guest Mode provides a secure, temporary user session with complete isolation and automatic cleanup. Inspired by macOS Guest User but with enhanced security through Linux namespaces and AppArmor.

---

## 🎯 Design Goals

1. **Zero Persistence** - No data survives logout
2. **Complete Isolation** - Guest cannot access other users' data
3. **Sandboxed Apps** - All applications run with restricted permissions
4. **Easy Access** - One-click login from lock screen
5. **Automatic Cleanup** - Secure data destruction on logout

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                    SANCHALA GUEST MODE                              │
├─────────────────────────────────────────────────────────────────────┤
│  Login Screen (SDDM) → Guest User (No Password)                     │
│                              │                                      │
│                              ▼                                      │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │              sanchala-guest-session (PAM)                    │   │
│  │  Create tmpfs → Mount Overlay → Apply AppArmor + Namespace   │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                              │                                      │
│                              ▼                                      │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                   Guest Desktop Session                      │   │
│  │   ✓ Web Browsing (sandboxed)    ✗ System Settings           │   │
│  │   ✓ Document Viewing            ✗ Software Installation     │   │
│  │   ✓ Media Playback              ✗ Access to /home/*         │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                              │ (Logout)                             │
│                              ▼                                      │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  sanchala-guest-cleanup: Shred tmpfs → Unmount → Release    │   │
│  └─────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 🔧 Components

### 1. Guest User Account

```bash
# System guest user (created during installation)
Username: guest
UID: 65534
GID: 65534 (guests)
Home: /home/guest (tmpfs mount point)
Shell: /bin/bash
GECOS: Sanchala Guest User
```

### 2. PAM Configuration

**File: `/etc/pam.d/sanchala-guest`**

```pam
# Sanchala OS Guest Session PAM
auth       required   pam_succeed_if.so user = guest
auth       required   pam_permit.so
account    required   pam_permit.so
session    required   pam_limits.so
session    required   pam_systemd.so
session    required   pam_exec.so /usr/lib/sanchala/guest-session-start
session    optional   pam_umask.so umask=077
password   required   pam_deny.so
```

### 3. Session Scripts

**guest-session-start:**
- Create tmpfs for /home/guest (size limited)
- Copy skeleton files from /etc/skel
- Apply guest-specific config overlay
- Set up AppArmor profile
- Create private /tmp namespace
- Log session start

**guest-session-cleanup:**
- Kill all guest processes
- Sync and unmount tmpfs
- Securely overwrite (shred) sensitive areas
- Release network namespace
- Log session end with duration
