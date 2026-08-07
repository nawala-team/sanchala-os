#!/usr/bin/env bash
# Sanchala Scheduler - Task Management Functions

cmd_list_tasks() {
    local json="${1:-false}"
    ensure_dirs
    
    echo -e "${BOLD}Scheduled Tasks${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    printf "%-20s %-12s %-25s\n" "NAME" "STATUS" "SCHEDULE"
    echo "───────────────────────────────────────────────────────"
    
    local has_tasks=false
    for timer in "$SYSTEMD_USER_DIR"/sanchala-task-*.timer; do
        [[ -f "$timer" ]] || continue
        has_tasks=true
        
        local name=$(basename "$timer" .timer | sed 's/sanchala-task-//')
        local status=$(systemctl --user is-enabled "$(basename "$timer")" 2>/dev/null || echo "disabled")
        local schedule=$(grep "OnCalendar=" "$timer" 2>/dev/null | head -1 | cut -d= -f2 || echo "N/A")
        
        local icon="○"; [[ "$status" == "enabled" ]] && icon="●"
        printf "  %s %-18s %-10s %s\n" "$icon" "$name" "$status" "$schedule"
    done
    
    [[ "$has_tasks" == "false" ]] && echo "  No tasks. Use 'sanchala-scheduler add' to create one."
    echo ""
}

cmd_add_task() {
    local name="$1"
    ensure_dirs
    
    [[ -z "$name" ]] && { print_error "Task name required"; exit 1; }
    [[ "$name" =~ ^[a-zA-Z0-9_-]+$ ]] || { print_error "Invalid name"; exit 1; }
    
    local timer_file="$SYSTEMD_USER_DIR/sanchala-task-${name}.timer"
    local service_file="$SYSTEMD_USER_DIR/sanchala-task-${name}.service"
    
    [[ -f "$timer_file" ]] && { print_error "Task '$name' exists"; exit 1; }
    
    echo -e "${BOLD}Create Task: $name${NC}\n"
    read -rp "Command to run: " task_command
    [[ -z "$task_command" ]] && { print_error "Command required"; exit 1; }
    
    read -rp "Description: " description
    description="${description:-Task: $name}"
    
    echo -e "\nSchedule: 1)Daily 2)Weekly 3)Hourly 4)On boot"
    read -rp "Choice [1-4]: " stype
    
    local on_calendar="" on_boot=""
    case "$stype" in
        1) read -rp "Time (HH:MM): " t; on_calendar="*-*-* ${t}:00" ;;
        2) read -rp "Day (Mon-Sun): " d; read -rp "Time: " t; on_calendar="${d} *-*-* ${t}:00" ;;
        3) on_calendar="*:00" ;;
        4) on_boot="2min" ;;
        *) print_error "Invalid"; exit 1 ;;
    esac
    
    cat > "$service_file" << EOF
[Unit]
Description=$description

[Service]
Type=oneshot
ExecStart=/bin/bash -c '$task_command'
StandardOutput=append:$LOG_DIR/${name}.log
StandardError=append:$LOG_DIR/${name}.log
EOF

    cat > "$timer_file" << EOF
[Unit]
Description=Timer for $description

[Timer]
$([ -n "$on_calendar" ] && echo "OnCalendar=$on_calendar")
$([ -n "$on_boot" ] && echo "OnBootSec=$on_boot")
Persistent=true

[Install]
WantedBy=timers.target
EOF

    systemctl --user daemon-reload
    systemctl --user enable --now "sanchala-task-${name}.timer" 2>/dev/null || true
    print_success "Task '$name' created"
}

cmd_remove_task() {
    local name="$1"
    [[ -z "$name" ]] && { print_error "Task name required"; exit 1; }
    
    systemctl --user disable --now "sanchala-task-${name}.timer" 2>/dev/null || true
    rm -f "$SYSTEMD_USER_DIR/sanchala-task-${name}".{timer,service}
    rm -f "$TASKS_DIR/${name}.toml"
    systemctl --user daemon-reload
    print_success "Task '$name' removed"
}

cmd_enable_task() {
    local name="$1"
    [[ -z "$name" ]] && { print_error "Task name required"; exit 1; }
    systemctl --user enable --now "sanchala-task-${name}.timer" 2>/dev/null && \
        print_success "Task '$name' enabled"
}

cmd_disable_task() {
    local name="$1"
    [[ -z "$name" ]] && { print_error "Task name required"; exit 1; }
    systemctl --user disable --now "sanchala-task-${name}.timer" 2>/dev/null && \
        print_success "Task '$name' disabled"
}

cmd_run_task() {
    local name="$1"
    [[ -z "$name" ]] && { print_error "Task name required"; exit 1; }
    print_info "Running '$name'..."
    systemctl --user start "sanchala-task-${name}.service" && print_success "Done"
}

cmd_status_task() {
    local name="${1:-}"
    if [[ -z "$name" ]]; then
        systemctl --user list-timers 'sanchala-task-*' --no-pager 2>/dev/null
    else
        systemctl --user status "sanchala-task-${name}.timer" --no-pager 2>/dev/null
    fi
}
