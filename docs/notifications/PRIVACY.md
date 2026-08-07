# Notification Privacy Guide

> Protecting sensitive information in notifications

## Overview

Sanchala OS provides comprehensive privacy controls for notifications, ensuring sensitive information stays protected.

## Privacy Features

### Lock Screen Privacy

Control what's visible on the lock screen:

```ini
# ~/.config/plasmanotifyrc
[Privacy]
HideContentOnLockScreen=true      # Hide message content
ShowSourceOnLockScreen=true       # Show app name only
HideSensitiveOnLockScreen=true    # Hide sensitive categories entirely
```

### Sensitive Categories

These categories are treated as sensitive by default:

- `messaging` - Chat/IM apps
- `email` - Email clients
- `banking` - Financial apps
- `health` - Health/medical apps

```ini
SensitiveCategories=messaging,email,banking,health
```

### Per-App Privacy

```ini
[Applications][telegram-desktop]
HideOnLockScreen=true
ShowMessagePreview=false

[Applications][banking-app]
HideOnLockScreen=true
Sensitive=true
```

## Screen Sharing Protection

Automatically hide notification content during screen sharing:

```ini
[Privacy]
ShowScreenShareIndicator=true
HidePreviewsDuringScreenShare=true
```

When screen sharing is active:
- Notification popups show app name only
- Content is replaced with "Notification hidden"
- Sensitive notifications are blocked entirely

## History Privacy

```ini
# ~/.config/sanchala/notification-history.conf
[Privacy]
ExcludeApps=banking-app,health-app
ExcludeCategories=banking,health
RedactSensitive=true
ClearOnLogout=false
EncryptStorage=true
```

## Focus Mode Privacy

Share your focus status without revealing details:

```ini
[Work][Status]
ShareWithContacts=true
StatusMessage=Busy             # Generic message
# NOT: "In meeting with Client X"
```

## Best Practices

1. **Enable lock screen privacy** for all messaging apps
2. **Mark financial apps** as sensitive
3. **Enable screen share protection** before presentations
4. **Use generic focus status** messages
5. **Encrypt notification history** for maximum privacy
