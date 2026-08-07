#!/bin/bash
# Sanchala Meetings - Video Conference & Meeting Manager
VERSION="2.0.0"
CONFIG_DIR="$HOME/.config/sanchala/meetings"
MEETINGS_FILE="$CONFIG_DIR/meetings.json"
mkdir -p "$CONFIG_DIR"

CYAN='\033[0;36m' GREEN='\033[0;32m' YELLOW='\033[1;33m'
WHITE='\033[1;37m' RED='\033[0;31m' NC='\033[0m' BOLD='\033[1m'

print_header() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}${BOLD}    📹 Sanchala Meetings v$VERSION     ${NC}${CYAN}║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════╝${NC}\n"
}

schedule_meeting() {
    print_header
    echo -e "${BOLD}Schedule Meeting${NC}\n"
    read -p "Title: " title
    read -p "Date (YYYY-MM-DD): " date
    read -p "Time (HH:MM): " time
    read -p "Duration (minutes): " duration
    read -p "Platform (zoom/meet/teams): " platform
    read -p "Link (optional): " link
    read -p "Attendees: " attendees
    
    local id=$(date +%s)
    echo "{\"id\":\"$id\",\"title\":\"$title\",\"date\":\"$date\",\"time\":\"$time\",\"duration\":\"$duration\",\"platform\":\"$platform\",\"link\":\"$link\",\"attendees\":\"$attendees\"}" >> "$MEETINGS_FILE"
    echo -e "\n${GREEN}✓ Meeting scheduled${NC}"
    read -p "Press Enter..."
}

list_meetings() {
    print_header
    echo -e "${BOLD}Upcoming Meetings${NC}\n"
    if [[ -f "$MEETINGS_FILE" ]]; then
        local i=1
        while read line; do
            local title=$(echo "$line"|grep -o '"title":"[^"]*"'|cut -d'"' -f4)
            local date=$(echo "$line"|grep -o '"date":"[^"]*"'|cut -d'"' -f4)
            local time=$(echo "$line"|grep -o '"time":"[^"]*"'|cut -d'"' -f4)
            local platform=$(echo "$line"|grep -o '"platform":"[^"]*"'|cut -d'"' -f4)
            echo -e "${WHITE}$i)${NC} $title"
            echo -e "   ${CYAN}$date $time${NC} - $platform\n"
            ((i++))
        done < "$MEETINGS_FILE"
    else
        echo -e "${YELLOW}No meetings scheduled${NC}"
    fi
    read -p "Press Enter..."
}

join_meeting() {
    print_header
    echo -e "${BOLD}Join Meeting${NC}\n"
    echo "1) Enter meeting link"
    echo "2) Join from scheduled"
    read -p "Choice: " c
    case $c in
        1) read -p "Meeting URL: " url
           [[ -n "$url" ]] && xdg-open "$url" 2>/dev/null || termux-open-url "$url" 2>/dev/null
           ;;
        2) list_meetings
           read -p "Meeting #: " n
           local link=$(sed -n "${n}p" "$MEETINGS_FILE" 2>/dev/null | grep -o '"link":"[^"]*"'|cut -d'"' -f4)
           [[ -n "$link" ]] && { xdg-open "$link" 2>/dev/null || termux-open-url "$link" 2>/dev/null; }
           ;;
    esac
}

quick_meet() {
    print_header
    echo -e "${BOLD}Quick Meeting${NC}\n"
    echo "1) Google Meet"
    echo "2) Zoom"
    echo "3) Microsoft Teams"
    echo "4) Jitsi (Free)"
    read -p "Platform: " p
    case $p in
        1) xdg-open "https://meet.google.com/new" 2>/dev/null || termux-open-url "https://meet.google.com/new";;
        2) xdg-open "https://zoom.us/start" 2>/dev/null || termux-open-url "https://zoom.us/start";;
        3) xdg-open "https://teams.microsoft.com" 2>/dev/null || termux-open-url "https://teams.microsoft.com";;
        4) local room="sanchala-$(date +%s)"
           xdg-open "https://meet.jit.si/$room" 2>/dev/null || termux-open-url "https://meet.jit.si/$room"
           echo -e "${GREEN}Room: $room${NC}";;
    esac
    read -p "Press Enter..."
}

main_menu() {
    while true; do
        print_header
        echo -e "  ${WHITE}1)${NC} 📅 Schedule Meeting"
        echo -e "  ${WHITE}2)${NC} 📋 List Meetings"
        echo -e "  ${WHITE}3)${NC} 🚀 Join Meeting"
        echo -e "  ${WHITE}4)${NC} ⚡ Quick Meet"
        echo -e "  ${WHITE}0)${NC} Exit\n"
        read -p "Choice: " c
        case $c in 1) schedule_meeting;; 2) list_meetings;; 3) join_meeting;; 4) quick_meet;; 0) exit 0;; esac
    done
}
main_menu
