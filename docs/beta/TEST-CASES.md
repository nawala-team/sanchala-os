# 🧪 Beta Test Cases

> Structured test scenarios for Sanchala OS beta testers

---

## Overview

This document provides structured test cases for beta testers. Each test includes steps, expected results, and a pass/fail field.

**Format:** ID | Priority (P0=Critical, P1=High, P2=Medium) | Steps | Expected

---

## TC-100: Installation Tests

### TC-101: Fresh Install (UEFI) — P0
1. Boot from USB (UEFI mode) → Live environment loads
2. Click "Install Sanchala OS" → Calamares opens
3. Select language/timezone → Settings applied
4. Choose "Erase disk", enable encryption → Partition shown
5. Create user, click Install → Installation completes
6. Reboot → System boots to login

**Result:** [ ] Pass / [ ] Fail

### TC-102: Fresh Install (BIOS) — P1
1. Boot from USB (Legacy mode) → Live environment loads
2. Complete installation → System installs
3. Reboot → GRUB appears, system boots

**Result:** [ ] Pass / [ ] Fail

### TC-103: Dual Boot with Windows — P1
1. Boot installer on Windows system → Partitions detected
2. Choose "Install alongside" → Resize offered
3. Complete install → Both OS in bootloader
4. Boot each OS → Both work

**Result:** [ ] Pass / [ ] Fail

---

## TC-200: Boot & Desktop Tests

### TC-201: Normal Boot — P0
1. Power on → Plymouth splash appears
2. If encrypted, enter password → Disk unlocks
3. Wait → SDDM login appears
4. Enter credentials → Desktop loads <10s

**Result:** [ ] Pass / [ ] Fail

### TC-202: Desktop Functionality — P0
1. Desktop loads → Wallpaper, dock, panel visible
2. Click dock icons → Apps launch
3. Open app menu → Apps listed
4. Test window controls → Min/max/close work

**Result:** [ ] Pass / [ ] Fail

### TC-203: Global Menu — P1
1. Open Dolphin → Menu in top panel
2. Open Firefox → Menu in top panel

**Result:** [ ] Pass / [ ] Fail

### TC-204: Dock Behavior — P1
1. Hover dock icon → Magnification effect
2. Click icon → App launches with indicator
3. Right-click → Context menu appears

**Result:** [ ] Pass / [ ] Fail

---

## TC-300: Security Tests

### TC-301: Firewall Active — P0
1. Run `sudo firewall-cmd --state` → Output: "running"

**Result:** [ ] Pass / [ ] Fail

### TC-302: AppArmor Enforcement — P0
1. Run `sudo aa-status` → AppArmor enabled, profiles loaded

**Result:** [ ] Pass / [ ] Fail

### TC-303: Disk Encryption — P0
1. Run `lsblk` → LUKS partitions shown
2. Run `sudo cryptsetup status root` → Details shown

**Result:** [ ] Pass / [ ] Fail

---

## TC-400: Hardware Tests

### TC-401: Audio — P1
1. Play audio → Sound works
2. Adjust volume → Changes apply
3. Plug headphones → Audio switches
4. Test mic → Recording works

**Result:** [ ] Pass / [ ] Fail

### TC-402: Network — P0
1. Check WiFi → Networks listed
2. Connect → Connection successful
3. Test after suspend → Reconnects

**Result:** [ ] Pass / [ ] Fail

### TC-403: Suspend/Resume — P1
1. Suspend from menu → System suspends
2. Wake system → Resumes
3. Check session → State preserved

**Result:** [ ] Pass / [ ] Fail

---

## TC-500: Application Tests

### TC-501: Sanchala Store — P1
1. Open Store → Categories load
2. Search "firefox" → Results appear
3. Install app → Works
4. Uninstall app → Removed

**Result:** [ ] Pass / [ ] Fail

### TC-502: Sanchala Guardian — P1
1. Open Guardian → Dashboard loads
2. Run scan → Completes with results

**Result:** [ ] Pass / [ ] Fail

---

## Submitting Results

1. Note failures with details
2. Create GitHub issues for bugs
3. Email results: beta@sanchala.id
