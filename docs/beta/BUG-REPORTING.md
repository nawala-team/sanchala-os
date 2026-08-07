# 🐛 Bug Reporting Guidelines

> How to report bugs effectively in the Sanchala OS Beta Program

---

## Before Reporting

### 1. Check Existing Issues
Search [GitHub Issues](https://github.com/sanchala-os/sanchala-os/issues) to avoid duplicates:
- Use keywords from your issue
- Check both open AND closed issues
- Look at the [Known Issues](KNOWN-ISSUES.md) document

### 2. Verify It's a Bug
- Can you reproduce it consistently?
- Does it happen on a fresh install?
- Is it specific to your hardware?

### 3. Gather Information
Run these commands and save the output:

```bash
# System information
sanchala-info --full > ~/sanchala-bug-info.txt

# Or manually collect:
uname -a                          # Kernel version
cat /etc/sanchala-release         # OS version
lspci -v                          # Hardware info
journalctl -b -p err              # Error logs from current boot
dmesg | tail -100                 # Kernel messages
```

---

## Bug Report Structure

### Required Information

| Field | Description |
|-------|-------------|
| **Title** | Clear, specific summary (e.g., "WiFi disconnects after suspend on Intel AX200") |
| **Component** | Which part is affected (Installation, Desktop, Security, etc.) |
| **Severity** | Critical / High / Medium / Low |
| **Description** | What went wrong |
| **Expected** | What should have happened |
| **Actual** | What actually happened |
| **Steps to Reproduce** | Numbered steps to trigger the bug |
| **System Info** | Output from `sanchala-info` |

### Optional but Helpful

- Screenshots or screen recordings
- Relevant log excerpts
- Workaround if you found one
- Related issues or links

---

## Severity Guide

| Severity | Use When | Examples |
|----------|----------|----------|
| **Critical** | System unusable, data loss risk, security vulnerability | Boot failure, encryption not working, data corruption |
| **High** | Major feature completely broken | Can't connect to WiFi, installer crashes, app won't launch |
| **Medium** | Feature partially broken, workaround exists | Bluetooth pairs but audio stutters, theme partially applied |
| **Low** | Minor annoyance, cosmetic issue | Typo in UI, icon alignment off, animation stutter |

---

## Writing Good Bug Reports

### ✅ Good Example

```markdown
**Title:** [BUG] System freezes when connecting USB-C dock with dual monitors

**Component:** Graphics / Display

**Severity:** High

**Description:**
System completely freezes when connecting CalDigit TS3 Plus dock with two
external monitors. Requires hard reboot to recover.

**Expected Behavior:**
Monitors should be detected and desktop extended/mirrored based on settings.

**Actual Behavior:**
Screen freezes on last frame, no mouse/keyboard response, must hold power
button to reboot.

**Steps to Reproduce:**
1. Boot Sanchala OS normally
2. Log into desktop
3. Connect CalDigit TS3 Plus USB-C dock
4. Connect two monitors to dock (DisplayPort)
5. System freezes within 5 seconds

**System Information:**
- Sanchala OS: 1.0-beta.2
- Kernel: 6.6.10-hardened1-1-hardened
- CPU: Intel i7-1365U
- GPU: Intel Iris Xe
- RAM: 32GB
- Dock: CalDigit TS3 Plus
- Monitors: 2x Dell U2722D (2560x1440)

**Logs:**
(Attached journalctl output from previous boot showing GPU errors)

**Workaround:**
Connecting monitors before boot works. Only hot-plugging causes freeze.
```

### ❌ Bad Example

```markdown
**Title:** display broken

**Description:**
my screen doesnt work fix it
```

---

## Where to Report

| Issue Type | Where to Report |
|------------|-----------------|
| Regular bugs | [GitHub Issues](https://github.com/sanchala-os/sanchala-os/issues/new?template=beta-bug-report.yml) |
| Security vulnerabilities | Email: security@sanchala.id (NOT public issues) |
| Questions (not bugs) | [GitHub Discussions](https://github.com/sanchala-os/sanchala-os/discussions) |
| Feature requests | [GitHub Issues](https://github.com/sanchala-os/sanchala-os/issues/new?template=feature-request.yml) |

---

## After Reporting

1. **Monitor your issue** — Respond to questions from maintainers
2. **Test fixes** — When a fix is proposed, test and confirm
3. **Update status** — Let us know if you find a workaround
4. **Be patient** — We prioritize by severity and impact

---

## Collecting Logs

### System Logs
```bash
# All logs from current boot
journalctl -b > ~/logs/journal.log

# Only errors and warnings
journalctl -b -p warning > ~/logs/journal-warnings.log

# Specific service
journalctl -u NetworkManager > ~/logs/network.log
```

### Application Logs
```bash
# KDE/Plasma logs
journalctl --user -b > ~/logs/user-session.log

# Sanchala tools
cat ~/.local/share/sanchala/*/logs/*.log
```

### Hardware Information
```bash
# Full hardware report
sudo lshw > ~/logs/hardware.log

# Graphics
lspci -v | grep -A 20 VGA > ~/logs/gpu.log

# USB devices
lsusb -v > ~/logs/usb.log
```

### Crash Dumps
```bash
# Check for coredumps
coredumpctl list
coredumpctl info [PID]
```

---

## Privacy Note

Before sharing logs, review them for sensitive information:
- Remove WiFi passwords (usually not logged, but check)
- Remove personal file paths if desired
- Remove any accidentally logged credentials

---

**Questions?** Ask in the [Beta Forum](https://forum.sanchala.id/c/beta) or email beta@sanchala.id
