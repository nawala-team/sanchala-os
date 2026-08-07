#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0
# Sanchala Diagnostics - Process monitoring library

cmd_top() {
    if command -v btop &>/dev/null; then exec btop
    elif command -v htop &>/dev/null; then exec htop
    else exec top; fi
}

cmd_processes() {
    local sort_by="${1:-cpu}"
    print_header "PROCESS LIST (sorted by $sort_by)"
    case "$sort_by" in
        cpu)  ps aux --sort=-%cpu 2>/dev/null | head -20 ;;
        mem)  ps aux --sort=-%mem 2>/dev/null | head -20 ;;
        pid)  ps aux --sort=-pid 2>/dev/null | head -20 ;;
        *)    ps aux --sort=-%cpu 2>/dev/null | head -20 ;;
    esac
}

cmd_kill_process() {
    local pid="$1" signal="${2:-15}"
    [[ -z "$pid" ]] && { print_error "Usage: sanchala-diagnostics kill <PID> [SIGNAL]"; exit 1; }
    [[ ! -d "/proc/$pid" ]] && { print_error "Process $pid does not exist"; exit 1; }
    local proc_name=$(ps -p "$pid" -o comm= 2>/dev/null || echo "unknown")
    print_warning "Terminating process: $pid ($proc_name)"
    kill -"$signal" "$pid" 2>/dev/null && print_success "Signal $signal sent to process $pid" || { print_error "Failed"; exit 1; }
}

cmd_priority() {
    local pid="$1" nice_val="$2"
    [[ -z "$pid" || -z "$nice_val" ]] && { print_error "Usage: priority <PID> <NICE_VALUE> (-20 to 19)"; exit 1; }
    renice "$nice_val" -p "$pid" 2>/dev/null && print_success "Set priority of $pid to $nice_val" || { print_error "Failed (may need root)"; exit 1; }
}

cmd_cpu() {
    print_header "CPU INFORMATION"
    print_metric "Model" "$(grep 'model name' /proc/cpuinfo | head -1 | cut -d':' -f2 | xargs)"
    print_metric "Vendor" "$(grep 'vendor_id' /proc/cpuinfo | head -1 | cut -d':' -f2 | xargs)"
    print_metric "Cores" "$(nproc)"
    print_metric "Threads" "$(grep -c '^processor' /proc/cpuinfo)"
    print_metric "Cache" "$(grep 'cache size' /proc/cpuinfo | head -1 | cut -d':' -f2 | xargs)"
    local flags=$(grep 'flags' /proc/cpuinfo | head -1)
    local virt="None"; [[ "$flags" == *"vmx"* ]] && virt="Intel VT-x"; [[ "$flags" == *"svm"* ]] && virt="AMD-V"
    print_metric "Virtualization" "$virt"
    
    if [[ -d /sys/devices/system/cpu/cpu0/cpufreq ]]; then
        print_header "CPU FREQUENCIES"
        print_metric "Current" "$(awk '{printf "%.0f MHz", $1/1000}' /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq 2>/dev/null)"
        print_metric "Governor" "$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null)"
    fi
}

cmd_memory() {
    print_header "MEMORY INFORMATION"
    free -h 2>/dev/null
    echo ""
    print_metric "Buffers" "$(grep Buffers /proc/meminfo | awk '{print $2, $3}')"
    print_metric "Cached" "$(grep ^Cached /proc/meminfo | awk '{print $2, $3}')"
    print_metric "Slab" "$(grep Slab /proc/meminfo | awk '{print $2, $3}')"
    echo ""
    draw_progress_bar "Usage" "$(free | awk '/^Mem:/ {printf "%.0f", $3/$2*100}')" 100
    print_header "TOP MEMORY CONSUMERS"
    ps aux --sort=-%mem 2>/dev/null | awk 'NR==1 || NR<=6 {printf "%-12s %6s %s\n", $1, $4"%", $11}' | head -7
}

cmd_swap() {
    print_header "SWAP INFORMATION"
    free -h 2>/dev/null | grep -E "^(Mem|Swap):"
    echo ""
    [[ -f /proc/swaps ]] && cat /proc/swaps
    print_metric "Swappiness" "$(cat /proc/sys/vm/swappiness 2>/dev/null)"
}

cmd_load() {
    print_header "SYSTEM LOAD"
    local loadavg=$(cat /proc/loadavg)
    print_metric "1 min average" "$(echo $loadavg | awk '{print $1}')"
    print_metric "5 min average" "$(echo $loadavg | awk '{print $2}')"
    print_metric "15 min average" "$(echo $loadavg | awk '{print $3}')"
    print_metric "Running/Total" "$(echo $loadavg | awk '{print $4}')"
    print_metric "CPU Cores" "$(nproc)"
    local lp=$(echo "$(cat /proc/loadavg | awk '{print $1}') $(nproc)" | awk '{printf "%.0f", ($1/$2)*100}')
    echo ""
    draw_progress_bar "Load" "$lp" 100
    [[ $lp -gt 100 ]] && print_warning "System is overloaded!" || [[ $lp -gt 80 ]] && print_warning "Load is high" || print_success "Load is normal"
}
