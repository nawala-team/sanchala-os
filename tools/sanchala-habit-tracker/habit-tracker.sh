#!/bin/bash
# Sanchala Habit Tracker - Build Better Habits
VERSION="2.0.0"
CONFIG_DIR="$HOME/.config/sanchala/habits"
HABITS_FILE="$CONFIG_DIR/habits.json"
LOG_FILE="$CONFIG_DIR/log.json"
mkdir -p "$CONFIG_DIR"

CYAN='\033[0;36m' GREEN='\033[0;32m' YELLOW='\033[1;33m'
WHITE='\033[1;37m' RED='\033[0;31m' NC='\033[0m' BOLD='\033[1m'

print_header() {
    clear
    echo -e "${GREEN}╔══════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║${NC}${BOLD}   ✅ Sanchala Habit Tracker v$VERSION  ${NC}${GREEN}║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════╝${NC}\n"
}

add_habit() {
    print_header
    read -p "Habit name: " name
    read -p "Frequency (daily/weekly): " freq
    read -p "Goal (times per period): " goal
    echo "{\"name\":\"$name\",\"freq\":\"$freq\",\"goal\":$goal,\"created\":\"$(date -Iseconds)\"}" >> "$HABITS_FILE"
    echo -e "${GREEN}✓ Habit added${NC}"
    read -p "Press Enter..."
}

log_habit() {
    print_header
    echo -e "${BOLD}Log Today's Habits${NC}\n"
    local today=$(date +%Y-%m-%d)
    local i=1
    
    while read habit; do
        local name=$(echo "$habit" | grep -o '"name":"[^"]*"' | cut -d'"' -f4)
        local done=$(grep "$today.*$name" "$LOG_FILE" 2>/dev/null | wc -l)
        [[ $done -gt 0 ]] && echo -e "${GREEN}✓${NC} $i) $name" || echo -e "${WHITE}○${NC} $i) $name"
        ((i++))
    done < "$HABITS_FILE" 2>/dev/null
    
    echo
    read -p "Complete habit #: " n
    local habit=$(sed -n "${n}p" "$HABITS_FILE" 2>/dev/null)
    local name=$(echo "$habit" | grep -o '"name":"[^"]*"' | cut -d'"' -f4)
    [[ -n "$name" ]] && echo "{\"date\":\"$today\",\"habit\":\"$name\",\"time\":\"$(date +%H:%M)\"}" >> "$LOG_FILE"
    echo -e "${GREEN}✓ Logged${NC}"
    read -p "Press Enter..."
}

show_progress() {
    print_header
    echo -e "${BOLD}Weekly Progress${NC}\n"
    
    while read habit; do
        local name=$(echo "$habit" | grep -o '"name":"[^"]*"' | cut -d'"' -f4)
        local goal=$(echo "$habit" | grep -o '"goal":[0-9]*' | cut -d: -f2)
        echo -e "${CYAN}$name${NC} (Goal: $goal/week)"
        
        local bar=""
        for i in {6..0}; do
            local d=$(date -d "$i days ago" +%Y-%m-%d 2>/dev/null || date -v-${i}d +%Y-%m-%d 2>/dev/null)
            local done=$(grep "$d.*$name" "$LOG_FILE" 2>/dev/null | wc -l)
            [[ $done -gt 0 ]] && bar+="${GREEN}█${NC}" || bar+="${RED}░${NC}"
        done
        echo -e "  $bar (last 7 days)\n"
    done < "$HABITS_FILE" 2>/dev/null
    
    read -p "Press Enter..."
}

show_streaks() {
    print_header
    echo -e "${BOLD}Current Streaks${NC}\n"
    
    while read habit; do
        local name=$(echo "$habit" | grep -o '"name":"[^"]*"' | cut -d'"' -f4)
        local streak=0
        for i in {0..30}; do
            local d=$(date -d "$i days ago" +%Y-%m-%d 2>/dev/null || date -v-${i}d +%Y-%m-%d 2>/dev/null)
            local done=$(grep "$d.*$name" "$LOG_FILE" 2>/dev/null | wc -l)
            [[ $done -gt 0 ]] && ((streak++)) || break
        done
        echo -e "${CYAN}$name:${NC} ${YELLOW}$streak days 🔥${NC}"
    done < "$HABITS_FILE" 2>/dev/null
    
    read -p $'\nPress Enter...'
}

list_habits() {
    print_header
    echo -e "${BOLD}Your Habits${NC}\n"
    local i=1
    while read habit; do
        local name=$(echo "$habit" | grep -o '"name":"[^"]*"' | cut -d'"' -f4)
        local freq=$(echo "$habit" | grep -o '"freq":"[^"]*"' | cut -d'"' -f4)
        echo -e "${WHITE}$i)${NC} $name ${CYAN}($freq)${NC}"
        ((i++))
    done < "$HABITS_FILE" 2>/dev/null
    
    echo -e "\n${CYAN}[d]elete [b]ack${NC}"
    read -p "Choice: " cmd
    [[ "$cmd" == "d" ]] && { read -p "Number: " n; sed -i "${n}d" "$HABITS_FILE" 2>/dev/null; echo -e "${GREEN}Deleted${NC}"; }
    read -p "Press Enter..."
}

main_menu() {
    while true; do
        print_header
        local today=$(date +%Y-%m-%d)
        local logged=$(grep "$today" "$LOG_FILE" 2>/dev/null | wc -l)
        echo -e "${YELLOW}Today: $logged habits logged${NC}\n"
        
        echo -e "  ${WHITE}1)${NC} ✅ Log Habits"
        echo -e "  ${WHITE}2)${NC} ➕ Add Habit"
        echo -e "  ${WHITE}3)${NC} 📊 Progress"
        echo -e "  ${WHITE}4)${NC} 🔥 Streaks"
        echo -e "  ${WHITE}5)${NC} 📋 List Habits"
        echo -e "  ${WHITE}0)${NC} Exit\n"
        read -p "Choice: " c
        case $c in 1) log_habit;; 2) add_habit;; 3) show_progress;; 4) show_streaks;; 5) list_habits;; 0) exit 0;; esac
    done
}
main_menu
