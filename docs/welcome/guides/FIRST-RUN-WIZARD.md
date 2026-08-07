# First-Run Setup Wizard

The Sanchala Welcome wizard guides users through initial system configuration with a 12-page flow designed to complete in 4-5 minutes.

## Wizard Flow

```
┌─────────┐   ┌──────────┐   ┌────────┐   ┌──────────┐
│ Welcome │ → │ Language │ → │ Region │ → │ Keyboard │
└─────────┘   └──────────┘   └────────┘   └──────────┘
                                                │
┌─────────┐   ┌──────────┐   ┌─────────┐   ┌────────┐
│ Account │ ← │ Network  │ ← │   ...   │ ← │  ...   │
└─────────┘   └──────────┘   └─────────┘   └────────┘
      │
      ▼
┌──────────┐   ┌─────────┐   ┌────────────┐   ┌──────────┐
│ Security │ → │ Privacy │ → │ Appearance │ → │ Accounts │
└──────────┘   └─────────┘   └────────────┘   └──────────┘
                                                    │
                              ┌──────────┐   ┌──────────┐
                              │ All Done │ ← │  Tour    │
                              └──────────┘   └──────────┘
```

## Page Specifications

### 1. Welcome Page
**Duration:** ~5 seconds (auto-advance available)

- Animated Sanchala logo entrance
- Brand tagline: "Beautiful. Secure. Private."
- Background hardware detection starts
- Accessibility: Screen reader announces welcome

### 2. Language Page
**Duration:** ~15 seconds

- 50+ languages with native names and flags
- Search/filter by typing
- Live UI preview in selected language
- Auto-detect from system locale
- Keyboard shortcut: Type to filter

### 3. Region & Timezone Page
**Duration:** ~20 seconds

- Interactive world map (click to select)
- IP-based geolocation suggestion
- Timezone search by city name
- Format preferences:
  - Date format (YYYY-MM-DD, DD/MM/YYYY, MM/DD/YYYY)
  - Time format (12h/24h)
  - First day of week

### 4. Keyboard Layout Page
**Duration:** ~15 seconds

- Visual keyboard preview
- Type-to-test input field
- Layout auto-detection from hardware
- Variant selection (e.g., US International)
- Multiple layout support

### 5. Network Page
**Duration:** ~30 seconds (skippable)

- Wi-Fi network list with signal strength
- WPA/WPA2/WPA3 support
- WPA Enterprise (username/password)
- Hidden network manual entry
- Ethernet auto-detection
- Connection status indicator

### 6. Account Creation Page
**Duration:** ~45 seconds

- Full name → auto-generates username
- Username validation (Linux rules)
- Password with zxcvbn strength meter
- Password confirmation
- Avatar selection:
  - Camera capture
  - File picker
  - Default avatars
- Auto-login option
- Admin privilege notice

### 7. Security Page
**Duration:** ~30 seconds

- System status overview
- Detected features:
  - Secure Boot status
  - Disk encryption (LUKS)
  - TPM availability
- Firewall enable/disable
- Biometric setup (if hardware detected):
  - Fingerprint enrollment
  - Enrollment progress UI

### 8. Privacy Page
**Duration:** ~20 seconds

**All options OFF by default (privacy-first)**

| Option | Default | Description |
|--------|---------|-------------|
| Usage Statistics | OFF | Anonymous feature usage |
| Crash Reports | OFF | Bug reports (no PII) |
| Location Services | OFF | Per-app location access |
| Analytics | OFF | System analytics |

- Privacy score indicator
- Clear explanations for each option
- Link to privacy policy

### 9. Appearance Page
**Duration:** ~25 seconds

- Theme: Light / Dark / Auto
- Accent color: 12 presets + custom picker
- Wallpaper gallery with preview
- Live desktop preview
- Icon theme selection

### 10. Online Accounts Page
**Duration:** ~20 seconds (skippable)

- Google (Calendar, Contacts, Drive)
- Microsoft (Outlook, OneDrive)
- Nextcloud (self-hosted)
- Generic IMAP/SMTP
- CalDAV/CardDAV
- Privacy indicators per service
- Skip-friendly design

### 11. All Done Page
**Duration:** ~10 seconds

- Confetti celebration animation
- Animated checkmark
- Setup summary card:
  - Setup duration
  - Security status
  - Privacy score
- Quick action buttons

### 12. Tour Offer Page
**Duration:** ~5 seconds

- Available tours with descriptions
- Time estimates
- Recommended tour highlighted
- "Skip" and "Start Tour" options
- Note about Help menu access

## State Management

Wizard state is persisted to allow resumption after interruption:

```
/var/lib/sanchala/welcome/
├── state.json          # Current progress
└── first-boot-complete # Completion flag
```

## Skippable Pages

- Network (offline setup supported)
- Online Accounts (optional)
- Tour Offer (optional)

## Keyboard Navigation

| Key | Action |
|-----|--------|
| Tab | Next element |
| Shift+Tab | Previous element |
| Enter | Continue / Activate |
| Escape | Back |
| Alt+N | Next page |
| Alt+B | Previous page |
| Alt+S | Skip (if available) |

---

**Document Version:** 1.0
