# SMS & Calls Integration

## Overview

Sanchala OS lets you send/receive SMS and handle phone calls directly from your desktop, similar to Apple's iPhone-Mac integration.

## Features

- **SMS Messaging**: Full conversation view on desktop
- **Quick Reply**: Reply to messages from notifications
- **Caller ID**: See who's calling with contact lookup
- **Call Actions**: Answer, reject, or send quick message
- **Media Pause**: Automatically pause music on incoming calls
- **Call History**: View recent calls on desktop

## Requirements

- Android phone with KDE Connect installed
- KDE Connect SMS app permissions granted
- Phone and desktop on same network (or Bluetooth)

## Setup

### 1. Grant Permissions on Phone

Open KDE Connect app → Settings → Connected device → Plugins:

- **SMS**: Enable + grant SMS permissions
- **Phone**: Enable + grant phone/contacts permissions

### 2. Verify Connection

```bash
# Check device is connected
sanchala-sync kdc status

# Should show "paired and reachable"
```

### 3. Open SMS App

- Application Menu → KDE Connect SMS
- Or run: `kdeconnect-sms`

## SMS Usage

### From Desktop App

1. Open KDE Connect SMS from menu
2. Select conversation or start new
3. Type message and send

### From Notification

When SMS arrives:
1. Click notification to open full app
2. Or use inline reply if available
3. Quick actions: Reply, Mark Read, Dismiss

### From Command Line

```bash
# Send SMS
sanchala-sync kdc sms <device_id> "+1234567890" "Your message here"

# Using kdeconnect directly
kdeconnect-cli --send-sms "Hello!" --destination "+1234567890" -d <device_id>
```

## Call Handling

### Incoming Calls

When a call comes in:

```
┌─────────────────────────────────────┐
│  📞 Incoming Call                   │
│                                     │
│  👤 John Doe                        │
│  +1 (234) 567-8900                  │
│                                     │
│  [Reject]  [Message]  [Answer*]     │
└─────────────────────────────────────┘
* Answer requires phone action
```

### Quick Reject Messages

Pre-configured messages for quick rejection:

- "I'll call you back"
- "In a meeting"  
- "Can't talk right now"
- "What's up?"

Customize in `~/.config/sanchala/sync/sms-calls.conf`:

```ini
[Calls]
RejectMessages=I'll call you back,In a meeting,Can't talk now,Text me
```

### Media Pause

Music/video automatically pauses on incoming call:

```ini
[Plugin][pausemusic]
pauseOnIncoming=true
pauseOnOutgoing=true
resumeAfterCall=true
```

## Configuration

### SMS Settings

`~/.config/sanchala/sync/sms-calls.conf`:

```ini
[SMS]
Enabled=true
SyncConversations=true
SyncInterval=15
MaxConversations=100
QuickReply=true
SuggestedReplies=true

[SMS][Notifications]
ShowPreview=true
Sound=true
GroupByConversation=true
```

### Call Settings

```ini
[Calls]
Enabled=true
ShowIncoming=true
CallerIDLookup=true
RingDesktop=true
RingDuration=30
MuteOnCall=true
PauseMediaOnCall=true
LogCalls=true
```

### Privacy Settings

```ini
[Privacy]
HideCallerOnLock=true
HideMessageOnLock=true
EncryptStorage=true
```

## Notification Examples

### New SMS

```
┌─────────────────────────────────┐
│ 💬 Jane Smith                   │
│ Hey, are you free for lunch?    │
│                                 │
│ [Reply]  [Mark Read]  [Dismiss] │
└─────────────────────────────────┘
```

### Missed Call

```
┌─────────────────────────────────┐
│ 📵 Missed Call                  │
│ John Doe • 2 minutes ago        │
│                                 │
│ [Call Back]  [Message]          │
└─────────────────────────────────┘
```

## Troubleshooting

### SMS Not Syncing

1. Check SMS plugin enabled on phone
2. Grant SMS permissions in Android settings
3. Verify device connected: `sanchala-sync kdc status`
4. Try refreshing in KDE Connect SMS app

### Calls Not Showing

1. Enable Phone plugin on phone
2. Grant phone/contacts permissions
3. Check telephony plugin in desktop config
4. Restart KDE Connect daemon

### Can't Send SMS

1. Verify send permission on phone
2. Check phone has cellular signal
3. Test with short message first
4. Check destination number format

### Contact Names Not Showing

1. Enable contacts plugin
2. Grant contacts permission on phone
3. Wait for contact sync (can take a few minutes)
4. Check `~/.local/share/kdeconnect/contacts/`
