#!/usr/bin/env bash
# Sanchala Scheduler - Task Templates

cmd_list_templates() {
    echo -e "${BOLD}Available Task Templates${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "  daily-backup       Daily backup at 3 AM"
    echo "  weekly-cleanup     Cleanup on Sundays"
    echo "  hourly-sync        Cloud sync every hour"
    echo "  boot-optimize      Optimize on boot"
    echo "  temp-cleanup       Clean temp files daily"
    echo "  screenshot-clean   Clean old screenshots"
    echo ""
    echo "Use: sanchala-scheduler from-template <name>"
}

cmd_from_template() {
    local tpl="$1"
    [[ -z "$tpl" ]] && { cmd_list_templates; exit 1; }
    ensure_dirs
    
    case "$tpl" in
        daily-backup)
            quick_backup "03:00"
            ;;
        weekly-cleanup)
            quick_cleanup
            ;;
        hourly-sync)
            create_template_task "hourly-sync" \
                "Hourly Cloud Sync" \
                "/usr/bin/sanchala-cloud sync --quiet" \
                "*:00"
            ;;
        boot-optimize)
            create_template_task "boot-optimize" \
                "Boot Optimization" \
                "/usr/bin/sanchala-boot-optimize --quick" \
                "" "2min"
            ;;
        temp-cleanup)
            create_template_task "temp-cleanup" \
                "Temp Files Cleanup" \
                "find /tmp -user \$USER -atime +7 -delete 2>/dev/null; find ~/.cache -atime +30 -type f -delete 2>/dev/null || true" \
                "*-*-* 05:30:00"
            ;;
        screenshot-clean)
            create_template_task "screenshot-clean" \
                "Old Screenshots Cleanup" \
                "find ~/Pictures/Screenshots -mtime +30 -delete 2>/dev/null || true" \
                "Sun *-*-* 06:00:00"
            ;;
        *)
            print_error "Unknown template: $tpl"
            cmd_list_templates
            exit 1
            ;;
    esac
}

create_template_task() {
    local name="$1" desc="$2" cmd="$3" calendar="${4:-}" boot="${5:-}"
    
    cat > "$SYSTEMD_USER_DIR/sanchala-task-${name}.service" << EOF
[Unit]
Description=$desc

[Service]
Type=oneshot
ExecStart=/bin/bash -c '$cmd'
StandardOutput=append:$LOG_DIR/${name}.log
StandardError=append:$LOG_DIR/${name}.log
EOF

    cat > "$SYSTEMD_USER_DIR/sanchala-task-${name}.timer" << EOF
[Unit]
Description=$desc Timer

[Timer]
$([ -n "$calendar" ] && echo "OnCalendar=$calendar")
$([ -n "$boot" ] && echo "OnBootSec=$boot")
Persistent=true

[Install]
WantedBy=timers.target
EOF

    systemctl --user daemon-reload
    systemctl --user enable --now "sanchala-task-${name}.timer" 2>/dev/null || true
    print_success "Template '$name' task created"
}
