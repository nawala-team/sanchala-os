#!/usr/bin/env bash
# Sanchala Scheduler - Quick Schedule Functions

cmd_quick_schedule() {
    local type="$1"; shift || true
    case "$type" in
        backup) quick_backup "$@" ;;
        cleanup) quick_cleanup "$@" ;;
        update) quick_update "$@" ;;
        *) print_error "Unknown: $type (backup/cleanup/update)"; exit 1 ;;
    esac
}

quick_backup() {
    local time="${1:-03:00}"
    ensure_dirs
    
    cat > "$SYSTEMD_USER_DIR/sanchala-task-auto-backup.service" << EOF
[Unit]
Description=Sanchala Automatic Backup

[Service]
Type=oneshot
ExecStart=/usr/bin/sanchala-backup create "Scheduled backup"
StandardOutput=append:$LOG_DIR/auto-backup.log
EOF

    cat > "$SYSTEMD_USER_DIR/sanchala-task-auto-backup.timer" << EOF
[Unit]
Description=Daily Backup Timer

[Timer]
OnCalendar=*-*-* ${time}:00
Persistent=true
RandomizedDelaySec=300

[Install]
WantedBy=timers.target
EOF

    systemctl --user daemon-reload
    systemctl --user enable --now sanchala-task-auto-backup.timer 2>/dev/null || true
    print_success "Backup scheduled daily at $time"
}

quick_cleanup() {
    ensure_dirs
    
    cat > "$SYSTEMD_USER_DIR/sanchala-task-auto-cleanup.service" << EOF
[Unit]
Description=Sanchala Automatic Cleanup

[Service]
Type=oneshot
ExecStart=/usr/bin/sanchala-cleaner auto
StandardOutput=append:$LOG_DIR/auto-cleanup.log
EOF

    cat > "$SYSTEMD_USER_DIR/sanchala-task-auto-cleanup.timer" << EOF
[Unit]
Description=Weekly Cleanup Timer

[Timer]
OnCalendar=Sun *-*-* 04:00:00
Persistent=true

[Install]
WantedBy=timers.target
EOF

    systemctl --user daemon-reload
    systemctl --user enable --now sanchala-task-auto-cleanup.timer 2>/dev/null || true
    print_success "Cleanup scheduled weekly on Sundays"
}

quick_update() {
    if [[ $EUID -ne 0 ]]; then
        print_warning "System updates need sudo. Creating user reminder instead."
        ensure_dirs
        cat > "$SYSTEMD_USER_DIR/sanchala-task-update-check.service" << EOF
[Unit]
Description=Check for Updates

[Service]
Type=oneshot
ExecStart=/usr/bin/sanchala-updater check --notify
EOF
        cat > "$SYSTEMD_USER_DIR/sanchala-task-update-check.timer" << EOF
[Unit]
Description=Weekly Update Check

[Timer]
OnCalendar=Wed *-*-* 10:00:00
Persistent=true

[Install]
WantedBy=timers.target
EOF
        systemctl --user daemon-reload
        systemctl --user enable --now sanchala-task-update-check.timer 2>/dev/null || true
        print_success "Update check scheduled weekly"
        return
    fi
    
    cat > "/etc/systemd/system/sanchala-auto-update.service" << EOF
[Unit]
Description=Sanchala Automatic Update
After=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/bin/sanchala-updater check-apply --security-only
EOF

    cat > "/etc/systemd/system/sanchala-auto-update.timer" << EOF
[Unit]
Description=Weekly Update Timer

[Timer]
OnCalendar=Wed *-*-* 05:00:00
Persistent=true

[Install]
WantedBy=timers.target
EOF

    systemctl daemon-reload
    systemctl enable --now sanchala-auto-update.timer
    print_success "Auto-update scheduled weekly"
}

cmd_maintenance() {
    local subcmd="${1:-list}"
    case "$subcmd" in
        list)
            echo -e "${BOLD}System Maintenance Timers${NC}"
            systemctl list-timers 'sanchala-*' --no-pager 2>/dev/null || echo "None"
            ;;
        status)
            echo -e "${BOLD}Maintenance Status${NC}\n"
            for t in trim cleanup backup update-cache; do
                local s=$(systemctl is-active "sanchala-${t}.timer" 2>/dev/null || echo "inactive")
                printf "  %s sanchala-%-15s\n" "$([[ $s == active ]] && echo ● || echo ○)" "$t"
            done
            ;;
    esac
}
