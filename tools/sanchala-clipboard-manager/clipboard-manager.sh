#!/bin/bash
# Sanchala Clipboard Manager - Advanced Clipboard History
VERSION="2.0.0"
CONFIG_DIR="$HOME/.config/sanchala/clipboard"
HISTORY_FILE="$CONFIG_DIR/history.json"
SNIPPETS_FILE="$CONFIG_DIR/snippets.json"
mkdir -p "$CONFIG_DIR"

CYAN='\033[0;36m' GREEN='\033[0;32m' YELLOW='\033[1;33m'
WHITE='\033[1;37m' NC='\033[0m' BOLD='\033[1m'

print_header() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}${BOLD}  📋 Sanchala Clipboard Manager v$VERSION${NC}${CYAN}║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════╝${NC}\n"
}

get_clipboard() {
    if command -v termux-clipboard-get &>/dev/null; then
        termux-clipboard-get 2>/dev/null
    elif command -v xclip &>/dev/null; then
        xclip -selection clipboard -o 2>/dev/null
    elif command -v pbpaste &>/dev/null; then
        pbpaste 2>/dev/null
    fi
}

set_clipboard() {
    local text="$1"
    if command -v termux-clipboard-set &>/dev/null; then
        echo -n "$text" | termux-clipboard-set
    elif command -v xclip &>/dev/null; then
        echo -n "$text" | xclip -selection clipboard
    elif command -v pbcopy &>/dev/null; then
        echo -n "$text" | pbcopy
    fi
}

save_to_history() {
    local text="$1"
    local escaped=$(echo "$text" | head -c 500 | tr '\n' ' ' | sed 's/"/\\"/g')
    echo "{\"text\":\"$escaped\",\"time\":\"$(date -Iseconds)\"}" >> "$HISTORY_FILE"
    # Keep last 100 entries
    tail -100 "$HISTORY_FILE" > "$HISTORY_FILE.tmp" && mv "$HISTORY_FILE.tmp" "$HISTORY_FILE"
}

copy_text() {
    print_header
    echo -e "${BOLD}Copy to Clipboard${NC}\n"
    echo -e "${CYAN}Enter text (Ctrl+D to finish):${NC}"
    local text=$(cat)
    set_clipboard "$text"
    save_to_history "$text"
    echo -e "\n${GREEN}✓ Copied to clipboard${NC}"
    read -p "Press Enter..."
}

show_current() {
    print_header
    echo -e "${BOLD}Current Clipboard${NC}\n"
    local content=$(get_clipboard)
    echo -e "${CYAN}$content${NC}"
    read -p $'\nPress Enter...'
}

show_history() {
    print_header
    echo -e "${BOLD}Clipboard History${NC}\n"
    local i=1
    tac "$HISTORY_FILE" 2>/dev/null | head -20 | while read line; do
        local text=$(echo "$line" | grep -o '"text":"[^"]*"' | cut -d'"' -f4)
        local time=$(echo "$line" | grep -o '"time":"[^"]*"' | cut -d'"' -f4 | cut -dT -f2 | cut -d+ -f1)
        printf "${WHITE}%2d)${NC} ${CYAN}%s${NC} %s\n" $i "$time" "${text:0:50}"
        ((i++))
    done
    
    echo -e "\n${CYAN}[c]opy [d]elete [b]ack${NC}"
    read -p "Choice: " cmd
    case $cmd in
        c) read -p "Number: " n
           local text=$(tac "$HISTORY_FILE" 2>/dev/null | sed -n "${n}p" | grep -o '"text":"[^"]*"' | cut -d'"' -f4)
           [[ -n "$text" ]] && set_clipboard "$text" && echo -e "${GREEN}Copied${NC}";;
        d) read -p "Number: " n
           local total=$(wc -l < "$HISTORY_FILE")
           sed -i "$((total-n+1))d" "$HISTORY_FILE" 2>/dev/null;;
    esac
    read -p "Press Enter..."
}

add_snippet() {
    print_header
    echo -e "${BOLD}Add Snippet${NC}\n"
    read -p "Name: " name
    echo -e "${CYAN}Content (Ctrl+D):${NC}"
    local content=$(cat | sed 's/"/\\"/g' | tr '\n' '\\n')
    echo "{\"name\":\"$name\",\"content\":\"$content\"}" >> "$SNIPPETS_FILE"
    echo -e "\n${GREEN}✓ Snippet saved${NC}"
    read -p "Press Enter..."
}

list_snippets() {
    print_header
    echo -e "${BOLD}Saved Snippets${NC}\n"
    local i=1
    while read line; do
        local name=$(echo "$line" | grep -o '"name":"[^"]*"' | cut -d'"' -f4)
        echo -e "${WHITE}$i)${NC} $name"
        ((i++))
    done < "$SNIPPETS_FILE" 2>/dev/null
    
    echo -e "\n${CYAN}[c]opy [d]elete [b]ack${NC}"
    read -p "Choice: " cmd
    case $cmd in
        c) read -p "Number: " n
           local content=$(sed -n "${n}p" "$SNIPPETS_FILE" 2>/dev/null | grep -o '"content":"[^"]*"' | cut -d'"' -f4)
           [[ -n "$content" ]] && set_clipboard "$(echo -e "$content")" && echo -e "${GREEN}Copied${NC}";;
        d) read -p "Number: " n; sed -i "${n}d" "$SNIPPETS_FILE" 2>/dev/null;;
    esac
    read -p "Press Enter..."
}

clear_history() {
    read -p "Clear all history? (y/N): " confirm
    [[ "$confirm" =~ ^[Yy]$ ]] && > "$HISTORY_FILE" && echo -e "${GREEN}Cleared${NC}"
    read -p "Press Enter..."
}

main_menu() {
    while true; do
        print_header
        echo -e "  ${WHITE}1)${NC} 📋 Show Current"
        echo -e "  ${WHITE}2)${NC} 📝 Copy Text"
        echo -e "  ${WHITE}3)${NC} 📜 History"
        echo -e "  ${WHITE}4)${NC} ⭐ Snippets"
        echo -e "  ${WHITE}5)${NC} ➕ Add Snippet"
        echo -e "  ${WHITE}6)${NC} 🗑️  Clear History"
        echo -e "  ${WHITE}0)${NC} Exit\n"
        read -p "Choice: " c
        case $c in 1) show_current;; 2) copy_text;; 3) show_history;; 4) list_snippets;; 5) add_snippet;; 6) clear_history;; 0) exit 0;; esac
    done
}
main_menu
