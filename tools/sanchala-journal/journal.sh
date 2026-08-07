#!/bin/bash
# Sanchala Journal - Personal Diary & Journal
VERSION="2.0.0"
CONFIG_DIR="$HOME/.config/sanchala/journal"
ENTRIES_DIR="$CONFIG_DIR/entries"
mkdir -p "$ENTRIES_DIR"

CYAN='\033[0;36m' GREEN='\033[0;32m' YELLOW='\033[1;33m'
WHITE='\033[1;37m' MAGENTA='\033[0;35m' NC='\033[0m' BOLD='\033[1m'

print_header() {
    clear
    echo -e "${MAGENTA}╔══════════════════════════════════════════╗${NC}"
    echo -e "${MAGENTA}║${NC}${BOLD}     📔 Sanchala Journal v$VERSION      ${NC}${MAGENTA}║${NC}"
    echo -e "${MAGENTA}╚══════════════════════════════════════════╝${NC}\n"
}

new_entry() {
    print_header
    local date=$(date +%Y-%m-%d)
    local file="$ENTRIES_DIR/$date.md"
    echo -e "${BOLD}Journal Entry - $date${NC}\n"
    
    read -p "Mood (😊😐😢😤): " mood
    read -p "Title: " title
    
    echo -e "# $date - $title\n" > "$file"
    echo -e "**Mood:** $mood\n" >> "$file"
    echo -e "---\n" >> "$file"
    
    echo -e "${CYAN}Write your thoughts (Ctrl+D to save):${NC}\n"
    cat >> "$file"
    
    echo -e "\n---\n*Written at $(date +%H:%M)*" >> "$file"
    echo -e "\n${GREEN}✓ Entry saved${NC}"
    read -p "Press Enter..."
}

list_entries() {
    print_header
    echo -e "${BOLD}Journal Entries${NC}\n"
    local i=1
    for f in $(ls -t "$ENTRIES_DIR"/*.md 2>/dev/null | head -20); do
        local date=$(basename "${f%.md}")
        local title=$(grep "^# " "$f" | head -1 | sed 's/^# //')
        local mood=$(grep "Mood:" "$f" | head -1 | sed 's/.*Mood:\*\* //')
        echo -e "${WHITE}$i)${NC} $date $mood"
        echo -e "   ${CYAN}$title${NC}"
        ((i++))
    done
    [[ $i -eq 1 ]] && echo -e "${YELLOW}No entries${NC}"
    
    echo -e "\n${CYAN}[v]iew [e]dit [d]elete [b]ack${NC}"
    read -p "Choice: " cmd
    case $cmd in
        v) read -p "Number: " n
           local f=$(ls -t "$ENTRIES_DIR"/*.md 2>/dev/null | sed -n "${n}p")
           [[ -f "$f" ]] && { print_header; cat "$f"; read -p "Enter..."; };;
        e) read -p "Number: " n
           local f=$(ls -t "$ENTRIES_DIR"/*.md 2>/dev/null | sed -n "${n}p")
           [[ -f "$f" ]] && ${EDITOR:-nano} "$f";;
        d) read -p "Number: " n
           local f=$(ls -t "$ENTRIES_DIR"/*.md 2>/dev/null | sed -n "${n}p")
           [[ -f "$f" ]] && rm "$f" && echo -e "${GREEN}Deleted${NC}";;
    esac
}

search_entries() {
    print_header
    read -p "Search: " term
    echo -e "\n${CYAN}Results:${NC}\n"
    grep -ril "$term" "$ENTRIES_DIR" 2>/dev/null | while read f; do
        echo -e "${WHITE}$(basename "${f%.md}")${NC}"
        grep -i -m1 "$term" "$f" | head -c 60
        echo -e "\n"
    done
    read -p "Press Enter..."
}

stats() {
    print_header
    echo -e "${BOLD}Journal Statistics${NC}\n"
    local total=$(ls -1 "$ENTRIES_DIR"/*.md 2>/dev/null | wc -l)
    local words=$(cat "$ENTRIES_DIR"/*.md 2>/dev/null | wc -w)
    local streak=0
    local today=$(date +%Y-%m-%d)
    
    echo -e "${CYAN}📝 Total entries:${NC} $total"
    echo -e "${CYAN}📊 Total words:${NC}   $words"
    echo -e "${CYAN}📅 First entry:${NC}  $(ls -t "$ENTRIES_DIR"/*.md 2>/dev/null | tail -1 | xargs basename 2>/dev/null | sed 's/.md//')"
    
    echo -e "\n${BOLD}Recent Activity:${NC}"
    for i in {0..6}; do
        local d=$(date -d "$i days ago" +%Y-%m-%d 2>/dev/null || date -v-${i}d +%Y-%m-%d 2>/dev/null)
        [[ -f "$ENTRIES_DIR/$d.md" ]] && echo -e "${GREEN}✓${NC} $d" || echo -e "${YELLOW}○${NC} $d"
    done
    read -p $'\nPress Enter...'
}

main_menu() {
    while true; do
        print_header
        local today=$(date +%Y-%m-%d)
        [[ -f "$ENTRIES_DIR/$today.md" ]] && echo -e "${GREEN}✓ Today's entry exists${NC}\n"
        
        echo -e "  ${WHITE}1)${NC} ✏️  New Entry"
        echo -e "  ${WHITE}2)${NC} 📖 List Entries"
        echo -e "  ${WHITE}3)${NC} 🔍 Search"
        echo -e "  ${WHITE}4)${NC} 📊 Statistics"
        echo -e "  ${WHITE}0)${NC} Exit\n"
        read -p "Choice: " c
        case $c in 1) new_entry;; 2) list_entries;; 3) search_entries;; 4) stats;; 0) exit 0;; esac
    done
}
main_menu
