# Notification Rules Guide

> Intelligent notification filtering and prioritization

## Overview

Notification rules allow you to automatically filter, prioritize, and organize notifications based on various conditions.

## Rule Structure

```ini
[Rule][RuleName]
Enabled=true
Priority=500          # Higher = evaluated first
Description=What this rule does
Conditions=condition1 AND condition2
Action=show|silence|critical|collapse
```

## Condition Syntax

### App Conditions
```
app:telegram*           # App name matches pattern
app.count.lastMinute>5  # Notifications in last minute
app.isUnknown           # Unknown/new application
```

### Category Conditions
```
category:security       # Specific category
category:messaging      # Messaging apps
```

### Content Conditions
```
title:*urgent*          # Title contains "urgent"
body:*password*         # Body contains "password"
body:*sale*             # Marketing detection
```

### Time Conditions
```
time:09:00-17:00        # Between 9 AM and 5 PM
day:Mon,Tue,Wed         # Specific days
day.isWeekday           # Monday-Friday
day.isWeekend           # Saturday-Sunday
```

### Priority Conditions
```
priority:critical       # Critical priority
priority:high           # High priority
priority:normal         # Normal priority
priority:low            # Low priority
```

## Actions

| Action | Description |
|--------|-------------|
| `show` | Show notification normally |
| `silence` | Don't show popup, add to history |
| `critical` | Treat as critical (bypass DND) |
| `collapse` | Group into summary notification |
| `hide` | Don't show at all |

## Built-in Rules

### Security Alerts (Critical)
```ini
[Rule][Critical-Security]
Enabled=true
Priority=1000
Conditions=category:security
Action=critical
BypassDND=true
```

### Marketing Filter
```ini
[Rule][Filter-Marketing]
Enabled=true
Priority=100
Conditions=body:*sale* OR body:*discount* OR body:*% off*
Action=silence
AddToHistory=false
```

### Anti-Spam
```ini
[Rule][AntiSpam]
Enabled=true
Priority=50
Conditions=app.count.lastMinute > 10
Action=collapse
CollapseTemplate={count} notifications from {app}
```

### Work Hours Priority
```ini
[Rule][WorkHours]
Enabled=true
Conditions=time:09:00-17:00 AND day.isWeekday
Prioritize=work,email,calendar
Deprioritize=gaming,social
```

## Creating Custom Rules

### Example: VIP Contact Rule
```ini
[Rule][VIP-Boss]
Enabled=true
Priority=900
Description=Boss messages always get through
Conditions=app:slack AND body:*@boss*
Action=show
BypassDND=true
PlaySound=urgent
```

### Example: Quiet Browser
```ini
[Rule][Quiet-Browser]
Enabled=true
Priority=200
Conditions=app:*browser*
MaxPerSource=2
CollapseAfter=2
```
