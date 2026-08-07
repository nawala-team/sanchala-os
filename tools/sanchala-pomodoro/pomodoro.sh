#!/bin/bash
# Sanchala Pomodoro - Focus Timer & Productivity
VERSION="2.0.0"
CONFIG_DIR="$HOME/.config/sanchala/pomodoro"
STATS_FILE="$CONFIG_DIR/stats.json"
mkdir -p "$CONFIG_DIR"
[[ ! -f "$STATS_FILE" ]] && echo '{"total":0,"today":0,"streak":0}' > "$STATS_FILE"

RED='\033[0;31m' GREEN='\033[0;32m' YELLOW='\033[1;33m'
CYAN='\033[0;36m' WHITE='\033[1;37m' NC='\033[0m' BOLD='\033[1m'
WORK=25 SHORT=5 LONG=15

print_header() {
    clear
    echo -e "${RED}╔══════════════════════════════════════════╗${NC}"
    echo -e "${RED}║${NC}${BOLD}    🍅 Sanchala Pomodoro v$VERSION     ${NC}${RED}║${NC}"
    echo -e "${RED}╚══════════════════════════════════════════╝${NC}\n"
}

notify() { echo -e "\n${GREEN}🔔 $1${NC}"; command -v termux-notification &>/dev/null && termux-notification -t "Pomodoro" -c "$1"; }

countdown() {
    local secs=$1 label="$2" start=$1
    while [[ $secs -gt 0 ]]; do
        local pct=$((100-(secs*100/start)))
        printf "\r${CYAN}$label${NC} %02d:%02d [%3d%%] " $((secs/60)) $((secs%60)) $pct
        sleep 1; ((secs--))
    done
    echo
}

update_stats() {
    local t=$(grep -o '"total":[0-9]*' "$STATS_FILE"|cut -d: -f2)
    echo "{\"total\":$((t+1)),\"today\":1,\"streak\":1}" > "$STATS_FILE"
}

start_pomodoro() {
    print_header
    read -p "Task: " task; task=${task:-"Focus"}
    countdown $((WORK*60)) "🍅 $task"
    notify "Session done! Break time."
    update_stats
    countdown $((SHORT*60)) "☕ Break"
    notify "Break over!"
    read -p "Press Enter..."
}

quick_timer() {
    print_header
    read -p "Minutes: " m; [[ ! "$m" =~ ^[0-9]+$ ]] && return
    countdown $((m*60)) "⏱️ Timer"
    notify "Timer done!"
    read -p "Press Enter..."
}

show_stats() {
    print_header
    echo -e "${BOLD}Stats${NC}\n"
    cat "$STATS_FILE" | tr ',' '\n' | tr -d '{}\"'
    read -p $'\nPress Enter...'
}

main_menu() {
    while true; do
        print_header
        echo -e "  ${WHITE}1)${NC} 🍅 Start Pomodoro"
        echo -e "  ${WHITE}2)${NC} ⏱️  Quick Timer"
        echo -e "  ${WHITE}3)${NC} 📊 Statistics"
        echo -e "  ${WHITE}0)${NC} Exit\n"
        read -p "Choice: " c
        case $c in 1) start_pomodoro;; 2) quick_timer;; 3) show_stats;; 0) exit 0;; esac
    done
}
[[ "$1" == "-s" ]] && start_pomodoro || [[ "$1" == "-t" ]] && { countdown $(($2*60)) "Timer"; } || main_menu
