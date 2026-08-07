# Tips & Tricks System

Contextual tips that help users discover Sanchala OS features.

## Overview

The tips system shows relevant suggestions based on:
- User experience level (first login, first week)
- Current application context
- System state (idle, settings page)
- Scheduled intervals

## Tip Categories

| Category | Description |
|----------|-------------|
| `getting_started` | Essential first steps |
| `productivity` | Workflow improvements |
| `security` | Security features |
| `privacy` | Privacy controls |
| `customization` | Personalization |
| `keyboard` | Keyboard shortcuts |
| `advanced` | Power user features |

## Context Triggers

| Context | When Triggered |
|---------|----------------|
| `first_login` | First session after setup |
| `first_week` | First 7 days of use |
| `app_open:APP_ID` | When specific app opens |
| `settings_page:PAGE` | When viewing settings |
| `idle` | After 5 minutes idle |
| `scheduled:daily` | Once per day |
| `scheduled:weekly` | Once per week |

## Tip Definition Format

```toml
[[tips]]
id = "clipboard-history"
title = "Clipboard History"
content = "Press Super+V to see clipboard history."
category = "productivity"
context = ["first_week"]
priority = 7
icon = "edit-paste"
action = { label = "Try It", type = "run_command", target = "qdbus ... " }
learn_more_url = "https://docs.sanchala.id/clipboard"
```

## Tip Actions

```toml
# Open application
action = { label = "Open", type = "open_app", target = "app.id" }

# Open settings
action = { label = "Settings", type = "open_settings", target = "page" }

# Open URL
action = { label = "Learn More", type = "open_url", target = "https://..." }

# Run command
action = { label = "Try", type = "run_command", target = "command" }

# Start tour
action = { label = "Take Tour", type = "start_tour", target = "tour_id" }
```

## User Preferences

Stored in `~/.config/sanchala/welcome/tips.toml`:

```toml
[tips]
enabled = true
frequency = "daily"  # daily, weekly, on_idle
categories = ["all"]  # or specific categories

[dismissed]
forever = ["tip-id-1", "tip-id-2"]
temporary = ["tip-id-3"]
```

## CLI Usage

```bash
# Show current contextual tip
sanchala-welcome --tips

# List all tips
sanchala-welcome --tips --all

# Filter by category
sanchala-welcome --tips --category=keyboard

# Dismiss tip
sanchala-welcome --tips --dismiss=tip-id
sanchala-welcome --tips --dismiss-forever=tip-id
```

## D-Bus API

```bash
# Get next tip for context
dbus-send --session --dest=id.sanchala.Welcome1 \
  /id/sanchala/Welcome1 \
  id.sanchala.Welcome1.GetNextTip string:"first_login"

# Dismiss tip
dbus-send ... id.sanchala.Welcome1.DismissTip \
  string:"tip-id" boolean:false
```

## Notification Integration

Tips appear as system notifications with:
- Icon based on tip category
- Title and content
- Action button (if defined)
- "Don't show again" option

## Priority System

Tips with higher priority (1-10) are shown first:
- 10: Critical first-use tips
- 7-9: Important features
- 4-6: Nice-to-know
- 1-3: Advanced features

---

**Document Version:** 1.0
