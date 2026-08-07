# Notification Mirroring Guide

## Overview

Mirror notifications from your phone to desktop - see messages, alerts, and app notifications without picking up your phone.

## How It Works

```
┌─────────────┐    KDE Connect    ┌─────────────┐
│   Phone     │ ───────────────►  │   Desktop   │
│ Notification│    Encrypted      │ Notification│
│   Service   │                   │   Center    │
└─────────────┘                   └─────────────┘
```

## Features

- **Mirror All Apps**: See any phone notification on desktop
- **Reply Inline**: Respond to messages without touching phone
- **Dismiss Sync**: Dismiss on desktop, gone on phone too
- **Smart Filtering**: Block noisy apps, prioritize important ones
- **Privacy Controls**: Hide content on lock screen

## Setup

### 1. Phone Permissions

On Android, open KDE Connect app:
1. Settings → Connected device
2. Enable "Receive notifications"
3. Grant Notification Access (Android settings)

### 2. Desktop Configuration

Verify plugin enabled in `~/.config/kdeconnect/plugins-notifications.conf`:

```ini
[Plugin][notifications]
enabled=true
receiveNotifications=true
allowDismiss=true
allowReply=true
```

## Filtering Notifications

### Block Noisy Apps

```ini
[FromPhone][Filtering]
Mode=blocklist
BlockedApps=com.android.systemui,com.android.vending,com.google.android.gms
```

### Allow Only Important Apps

```ini
[FromPhone][Filtering]
Mode=allowlist
AllowedApps=com.whatsapp,org.telegram.messenger,com.google.android.gm
```

### Priority Filtering

```ini
[FromPhone][Filtering]
MinPriority=high  # Only show high-priority notifications
```

## Category Settings

Different behavior for different notification types:

```ini
[FromPhone][Categories][messaging]
Enabled=true
ShowContent=true
AllowReply=true
Sound=true
Priority=high

[FromPhone][Categories][email]
Enabled=true
ShowContent=true
Sound=true

[FromPhone][Categories][social]
Enabled=true
ShowContent=false  # Privacy: hide content
Sound=false

[FromPhone][Categories][promo]
Enabled=false  # Block promotional notifications
```

## Privacy Settings

### Lock Screen Behavior

```ini
[Privacy]
HideOnLockScreen=true      # Hide notification content when locked
HideDuringScreenShare=true # Hide during presentations
SensitiveApps=banking,authenticator,password
```

### Sync DND (Do Not Disturb)

```ini
[Privacy]
RespectPhoneDND=true  # Honor phone's DND mode
SyncDNDState=true     # Sync DND between devices
```

## Notification Actions

### Available Quick Actions

| Action | Description |
|--------|-------------|
| Reply | Send inline reply |
| Mark Read | Mark as read on phone |
| Dismiss | Dismiss on both devices |
| Mute App | Block future notifications from app |
| Open on Phone | Open app on phone |

### Configuration

```ini
[Actions]
ReplyEnabled=true
MarkReadEnabled=true
DismissEnabled=true
MuteAppEnabled=true
OpenOnPhoneEnabled=true
```

## Sounds

### Custom Notification Sounds

```ini
[Sounds]
Enabled=true
UsePhoneSound=false
DefaultSound=/usr/share/sounds/sanchala/notification-mirror.ogg
MessagingSound=/usr/share/sounds/sanchala/message.ogg
CallSound=/usr/share/sounds/sanchala/phone-ring.ogg
```

## Bidirectional Sync

Send desktop notifications to phone (disabled by default):

```ini
[ToPhone]
Enabled=false  # Enable if desired
Mode=blocklist
BlockedApps=plasmashell,kdeconnect
RateLimit=20   # Max notifications per minute
```

## Troubleshooting

### Notifications Not Appearing

1. **Check Permissions**: Phone → Settings → Apps → KDE Connect → Notification Access
2. **Check Plugin**: Ensure notifications plugin enabled on both devices
3. **Check Filter**: Verify app not in blocklist
4. **Restart**: Restart KDE Connect on both devices

### Can't Reply to Messages

1. Reply requires notification reply support on phone
2. Not all apps support inline reply
3. Check `allowReply=true` in config

### Duplicate Notifications

```ini
[Plugin][notifications]
deduplicate=true
ignoreOngoing=true
blockGroupSummary=true
```

### Too Many Notifications

1. Enable blocklist for noisy apps
2. Set minimum priority filter
3. Disable categories like `promo` and `news`

## Best Practices

1. **Start with blocklist**: Block known noisy apps
2. **Use categories**: Different rules for messaging vs promotions
3. **Enable privacy**: Hide content on lock screen
4. **Rate limit**: Prevent notification spam
5. **Test gradually**: Add apps to filters as needed
