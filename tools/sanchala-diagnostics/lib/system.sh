#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0
# Sanchala Diagnostics - System monitoring library

get_cpu_usage() {
    local stat1=$(cat /proc/stat | head -1)
    sleep 1
    local stat2=$(cat /proc/stat | head -1)
    local idle1=$(echo "$stat1" | awk '{print $5}')
    local total1=$(echo "$stat1" | awk '{print $2+$3+$4+$5+$6+$7+$8}')
    local idle2=$(echo "$stat2" | awk '{print $5}')
    local total2=$(echo "$stat2" | awk '{print $2+$3+$4+$5+$6+$7+$8}')
    local idle_delta=$((idle2 - idle1))
    local total_delta=$((total2 - total1))
    [[ $total_delta -gt 0 ]] && echo $((100 * (total_delta - idle_delta) / total_delta)) || echo 0
}

draw_progress_bar() {
    local label="$1" value="$2" max="$3" width=40
    local percent=$((value * 100 / max))
    local filled=$((value * width / max))
    [[ $filled -gt $width ]] && filled=$width
    local empty=$((width - filled))
    local color="$GREEN"
    [[ $percent -gt 60 ]] && color="$YELLOW"
    [[ $percent -gt 85 ]] && color="$RED"
    printf "%-12s [" "$label"
    printf "${color}%${filled}s${NC}" | tr ' ' '█'
    printf "%${empty}s" | tr ' ' '░'
    printf "] %3d%%\n" "$percent"
}

cmd_overview() {
    local json="${1:-false}"
    [[ "$json" == "true" ]] && { generate_json_overview; return; }

    echo -e "${BOLD}${CYAN}"
    echo "╔══════════════════════════════════════════════════════════════════╗"
    echo "║              SANCHALA OS - SYSTEM DIAGNOSTICS                    ║"
    echo "╚══════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"

    print_header "SYSTEM IDENTITY"
    print_metric "Hostname" "$(hostname 2>/dev/null || echo unknown)"
    print_metric "OS" "$(grep PRETTY_NAME /etc/os-release 2>/dev/null | cut -d'"' -f2 || echo 'Sanchala OS')"
    print_metric "Kernel" "$(uname -r)"
    print_metric "Architecture" "$(uname -m)"
    print_metric "Uptime" "$(uptime -p 2>/dev/null | sed 's/up //' || echo unknown)"

    print_header "CPU"
    print_metric "Model" "$(grep 'model name' /proc/cpuinfo 2>/dev/null | head -1 | cut -d':' -f2 | xargs)"
    print_metric "Cores" "$(nproc 2>/dev/null)"
    print_metric "Load Average" "$(cat /proc/loadavg | awk '{print $1, $2, $3}')"

    print_header "MEMORY"
    print_metric "Total" "$(free -h | awk '/^Mem:/ {print $2}')"
    print_metric "Used" "$(free -h | awk '/^Mem:/ {print $3}')"
    print_metric "Available" "$(free -h | awk '/^Mem:/ {print $7}')"
    draw_progress_bar "Memory" "$(free | awk '/^Mem:/ {printf "%.0f", $3/$2*100}')" 100

    print_header "STORAGE"
    df -h 2>/dev/null | awk 'NR==1 || /^\// {printf "%-15s %8s %8s %8s %6s\n", $1, $2, $3, $4, $5}' | head -6

    print_header "TOP PROCESSES (by CPU)"
    ps aux --sort=-%cpu 2>/dev/null | awk 'NR==1 || NR<=6 {printf "%-12s %5s %5s %s\n", $1, $3, $4, $11}' | head -7
    echo ""
}

cmd_summary() {
    echo -e "${BOLD}System Health Summary${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    local load1=$(cat /proc/loadavg | awk '{print $1}')
    local cores=$(nproc 2>/dev/null || echo 1)
    local lp=$(echo "$load1 $cores" | awk '{printf "%.0f", ($1/$2)*100}')
    local ls="✓"; [[ $lp -gt 80 ]] && ls="⚠"; [[ $lp -gt 95 ]] && ls="✗"
    printf "CPU Load:     %s %3d%%\n" "$ls" "$lp"
    local mp=$(free | awk '/^Mem:/ {printf "%.0f", $3/$2*100}')
    local ms="✓"; [[ $mp -gt 80 ]] && ms="⚠"; [[ $mp -gt 95 ]] && ms="✗"
    printf "Memory:       %s %3d%%\n" "$ms" "$mp"
    local dp=$(df / | awk 'NR==2 {gsub(/%/,""); print $5}')
    local ds="✓"; [[ $dp -gt 80 ]] && ds="⚠"; [[ $dp -gt 95 ]] && ds="✗"
    printf "Root Disk:    %s %3d%%\n" "$ds" "$dp"
    ip route 2>/dev/null | grep -q default && printf "Network:      ✓ Connected\n" || printf "Network:      ✗ Disconnected\n"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

cmd_report() {
    local export_file="$1"
    if [[ -n "$export_file" ]]; then
        { echo "# Sanchala OS System Report"; echo "Generated: $(date)"; echo ""; cmd_overview false; } > "$export_file"
        print_success "Report saved to $export_file"
    else
        cmd_overview false
    fi
}

generate_json_overview() {
    cat << EOF
{"timestamp":"$(date -Iseconds)","hostname":"$(hostname)","kernel":"$(uname -r)","cpu":{"cores":$(nproc)},"memory":{"total":$(free -b|awk '/Mem:/{print $2}'),"used":$(free -b|awk '/Mem:/{print $3}')}}
EOF
}
