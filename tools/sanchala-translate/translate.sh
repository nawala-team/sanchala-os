#!/bin/bash
# Sanchala Translate - Multi-language Translation Tool
VERSION="2.0.0"
CONFIG_DIR="$HOME/.config/sanchala/translate"
HISTORY_FILE="$CONFIG_DIR/history.json"
mkdir -p "$CONFIG_DIR"

RED='\033[0;31m' GREEN='\033[0;32m' YELLOW='\033[1;33m'
CYAN='\033[0;36m' WHITE='\033[1;37m' NC='\033[0m' BOLD='\033[1m'

declare -A LANGS=(
    [en]="English" [es]="Spanish" [fr]="French" [de]="German"
    [it]="Italian" [pt]="Portuguese" [zh]="Chinese" [ja]="Japanese"
    [ko]="Korean" [ar]="Arabic" [hi]="Hindi" [ru]="Russian"
    [nl]="Dutch" [pl]="Polish" [tr]="Turkish" [vi]="Vietnamese"
    [th]="Thai" [id]="Indonesian" [sv]="Swedish" [da]="Danish"
)

print_header() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}${BOLD}    🌐 Sanchala Translate v$VERSION    ${NC}${CYAN}║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════╝${NC}\n"
}

list_languages() {
    print_header
    echo -e "${BOLD}Supported Languages${NC}\n"
    for k in $(echo "${!LANGS[@]}" | tr ' ' '\n' | sort); do
        printf "${CYAN}%-4s${NC} %s\n" "$k" "${LANGS[$k]}"
    done | column
    read -p $'\nPress Enter...'
}

translate_text() {
    local text="$1" from="${2:-auto}" to="${3:-en}"
    
    # Try translate-shell first
    if command -v trans &>/dev/null; then
        trans -b "$from:$to" "$text" 2>/dev/null
        return
    fi
    
    # Fallback to API
    local encoded=$(python3 -c "import urllib.parse; print(urllib.parse.quote('''$text'''))" 2>/dev/null)
    [[ -z "$encoded" ]] && encoded="$text"
    
    local result=$(curl -s "https://api.mymemory.translated.net/get?q=$encoded&langpair=$from|$to" 2>/dev/null)
    echo "$result" | grep -o '"translatedText":"[^"]*"' | cut -d'"' -f4
}

quick_translate() {
    print_header
    echo -e "${BOLD}Quick Translate${NC}\n"
    read -p "Text: " text
    [[ -z "$text" ]] && return
    read -p "To language (en): " to
    to=${to:-en}
    
    echo -e "\n${CYAN}Translating...${NC}"
    local result=$(translate_text "$text" "auto" "$to")
    echo -e "\n${GREEN}Result:${NC} $result"
    
    # Save to history
    echo "{\"text\":\"$text\",\"result\":\"$result\",\"to\":\"$to\",\"date\":\"$(date -Iseconds)\"}" >> "$HISTORY_FILE"
    
    read -p $'\nPress Enter...'
}

interactive_translate() {
    print_header
    echo -e "${BOLD}Interactive Translation${NC}\n"
    
    read -p "From language (auto): " from
    from=${from:-auto}
    read -p "To language (en): " to
    to=${to:-en}
    
    echo -e "\n${CYAN}Enter text (Ctrl+D when done):${NC}"
    local text=$(cat)
    
    echo -e "\n${CYAN}Translating...${NC}\n"
    local result=$(translate_text "$text" "$from" "$to")
    
    echo -e "${GREEN}═══ Translation ═══${NC}"
    echo "$result"
    echo -e "${GREEN}═══════════════════${NC}"
    
    read -p $'\nPress Enter...'
}

detect_language() {
    print_header
    echo -e "${BOLD}Detect Language${NC}\n"
    read -p "Text: " text
    [[ -z "$text" ]] && return
    
    if command -v trans &>/dev/null; then
        local detected=$(trans -id "$text" 2>/dev/null | grep -i "language" | head -1)
        echo -e "\n${GREEN}$detected${NC}"
    else
        echo -e "${YELLOW}Requires translate-shell (trans)${NC}"
    fi
    read -p $'\nPress Enter...'
}

translate_file() {
    print_header
    echo -e "${BOLD}Translate File${NC}\n"
    read -p "File path: " filepath
    [[ ! -f "$filepath" ]] && echo -e "${RED}File not found${NC}" && read -p "Enter..." && return
    
    read -p "To language (en): " to
    to=${to:-en}
    
    local outfile="${filepath%.*}_${to}.txt"
    echo -e "${CYAN}Translating...${NC}"
    
    while IFS= read -r line; do
        [[ -n "$line" ]] && translate_text "$line" "auto" "$to" >> "$outfile" || echo >> "$outfile"
    done < "$filepath"
    
    echo -e "${GREEN}✓ Saved: $outfile${NC}"
    read -p "Press Enter..."
}

show_history() {
    print_header
    echo -e "${BOLD}Translation History${NC}\n"
    
    if [[ -f "$HISTORY_FILE" ]]; then
        tail -20 "$HISTORY_FILE" | while read line; do
            local text=$(echo "$line" | grep -o '"text":"[^"]*"' | cut -d'"' -f4)
            local result=$(echo "$line" | grep -o '"result":"[^"]*"' | cut -d'"' -f4)
            echo -e "${CYAN}→${NC} ${text:0:30}..."
            echo -e "  ${GREEN}${result:0:40}...${NC}\n"
        done
    else
        echo -e "${YELLOW}No history yet${NC}"
    fi
    read -p "Press Enter..."
}

batch_translate() {
    print_header
    echo -e "${BOLD}Batch Translation${NC}\n"
    read -p "To language: " to
    [[ -z "$to" ]] && return
    
    echo -e "${CYAN}Enter phrases (one per line, empty to finish):${NC}\n"
    while true; do
        read -p "> " phrase
        [[ -z "$phrase" ]] && break
        local result=$(translate_text "$phrase" "auto" "$to")
        echo -e "${GREEN}  → $result${NC}\n"
    done
    read -p "Press Enter..."
}

main_menu() {
    while true; do
        print_header
        echo -e "  ${WHITE}1)${NC} 🔤 Quick Translate"
        echo -e "  ${WHITE}2)${NC} 📝 Interactive Mode"
        echo -e "  ${WHITE}3)${NC} 🔍 Detect Language"
        echo -e "  ${WHITE}4)${NC} 📄 Translate File"
        echo -e "  ${WHITE}5)${NC} 📚 Batch Translate"
        echo -e "  ${WHITE}6)${NC} 🌐 List Languages"
        echo -e "  ${WHITE}7)${NC} 📜 History"
        echo -e "  ${WHITE}0)${NC} Exit"
        echo
        read -p "Choice: " c
        case $c in
            1) quick_translate ;; 2) interactive_translate ;;
            3) detect_language ;; 4) translate_file ;;
            5) batch_translate ;; 6) list_languages ;;
            7) show_history ;; 0) exit 0 ;;
        esac
    done
}

case "$1" in
    -h|--help) echo "Sanchala Translate v$VERSION"; echo "Usage: $0 [-t text] [-l]" ;;
    -t) shift; translate_text "$@" ;;
    -l) for k in "${!LANGS[@]}"; do echo "$k: ${LANGS[$k]}"; done | sort ;;
    *) main_menu ;;
esac
