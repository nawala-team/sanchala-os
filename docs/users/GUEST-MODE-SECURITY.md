# 🛡️ Guest Mode Security Model

## Filesystem Isolation

```
/home/guest/           → tmpfs (max 512MB, noexec optional)
  ├── .config/         → Guest KDE settings
  ├── .local/          → Local data (cleared)
  ├── .cache/          → Cache (cleared)
  ├── Documents/       → Read-only sample docs
  ├── Downloads/       → Writable, cleared on logout
  └── .sanchala/       → Guest restrictions config

/tmp/guest-session/    → Private tmpfs namespace
/run/user/65534/       → XDG_RUNTIME_DIR (tmpfs)
```

## AppArmor Profile

**File: `/etc/apparmor.d/sanchala-guest`**

```apparmor
#include <tunables/global>

profile sanchala-guest flags=(attach_disconnected) {
  #include <abstractions/base>
  #include <abstractions/nameservice>

  # Guest home directory
  owner /home/guest/** rw,
  
  # Deny access to other homes
  deny /home/[^g]** r,
  deny /home/guest/../** r,
  
  # Read-only system access
  /usr/** r,
  /opt/** r,
  /etc/** r,
  deny /etc/shadow r,
  deny /etc/gshadow r,
  
  # Deny dangerous operations
  deny /boot/** rwx,
  deny capability sys_admin,
  deny capability sys_ptrace,
  deny capability net_admin,
}
```

## Resource Limits

**File: `/etc/security/limits.d/99-sanchala-guest.conf`**

```
# Sanchala Guest User Limits
guest    soft    nproc     256
guest    hard    nproc     512
guest    soft    nofile    1024
guest    hard    nofile    2048
guest    soft    fsize     1073741824   # 1GB max file
guest    hard    fsize     2147483648   # 2GB absolute max
guest    soft    as        4294967296   # 4GB address space
guest    -       maxlogins 1            # Single session only
```

## Available Applications

| Category | Allowed | Restricted |
|----------|---------|------------|
| Web | Firefox, Brave | Password managers |
| Office | LibreOffice (view) | Save to system |
| Media | VLC, Photos | DRM content |
| Files | Dolphin (limited) | /home/*, System |
| System | Calculator, Notes | Settings, Terminal |

## Testing Requirements

1. **Session Creation** - tmpfs mounts correctly
2. **Isolation** - Cannot access /home/user
3. **Cleanup** - Data destroyed on logout
4. **Limits** - Resource limits enforced
5. **AppArmor** - Profile blocks unauthorized access
6. **Multi-session** - Only one guest session allowed
7. **Crash Recovery** - Cleanup runs even after crash
8. **Performance** - Login < 5 seconds
