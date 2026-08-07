# 📅 Sanchala Scheduler

User-friendly task automation for Sanchala OS. Schedule backups, cleanups, and custom tasks with ease.

## Features

- **GUI Integration** - KDE System Settings module
- **Systemd-based** - Reliable timer execution
- **Quick Setup** - One-command scheduling for common tasks
- **Templates** - Pre-configured task templates
- **Backup Integration** - Seamless scheduled backups

## Quick Start

### Schedule Automatic Backups
```bash
sanchala-scheduler quick backup
```

### Schedule Weekly Cleanup
```bash
sanchala-scheduler quick cleanup
```

### Create Custom Task
```bash
sanchala-scheduler add my-task
```

### List Scheduled Tasks
```bash
sanchala-scheduler list
```

## GUI Access

Open System Settings → System → Task Scheduler

Or run:
```bash
kcmshell6 kcm_sanchala_scheduler
```

## Commands

| Command | Description |
|---------|-------------|
| `list` | Show all scheduled tasks |
| `add <name>` | Create new task interactively |
| `remove <name>` | Remove a task |
| `enable <name>` | Enable a task |
| `disable <name>` | Disable a task |
| `run <name>` | Run task immediately |
| `status [name]` | Show task status |
| `quick backup` | Schedule automatic backups |
| `quick cleanup` | Schedule weekly cleanup |
| `templates` | List available templates |
| `from-template <tpl>` | Create from template |

## Schedule Formats

The scheduler uses systemd calendar format:

| Format | Meaning |
|--------|---------|
| `*-*-* 03:00:00` | Daily at 3 AM |
| `Sun *-*-* 04:00:00` | Sundays at 4 AM |
| `*-*-01 00:00:00` | First of each month |
| `*:00` | Every hour |
| `*:0/30` | Every 30 minutes |

## System Maintenance

Built-in maintenance tasks (enabled by default):

- **SSD TRIM** - Weekly, optimizes SSD performance
- **Cache Cleanup** - Monthly, removes old packages
- **Journal Rotation** - Weekly, manages log size
- **Update Check** - Daily, notifies of updates

Check maintenance status:
```bash
sanchala-scheduler maintenance status
```

## Configuration

User config: `~/.config/sanchala/scheduler/`
System config: `/etc/sanchala/scheduler/`

## Templates

Available templates:
- `daily-backup` - Daily backup at 3 AM
- `weekly-cleanup` - Cleanup on Sundays
- `hourly-sync` - Cloud sync every hour
- `boot-optimize` - Optimize on boot
- `temp-cleanup` - Clean temp files daily

Use template:
```bash
sanchala-scheduler from-template daily-backup
```

## See Also

- `sanchala-backup` - Backup management
- `sanchala-cleaner` - System cleanup
- `systemctl --user list-timers` - View systemd timers
