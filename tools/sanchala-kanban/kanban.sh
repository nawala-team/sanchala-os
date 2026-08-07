#!/bin/bash
# Sanchala Kanban - Project Board Manager
VERSION="2.0.0"
CONFIG_DIR="$HOME/.config/sanchala/kanban"
BOARDS_DIR="$CONFIG_DIR/boards"
mkdir -p "$BOARDS_DIR"

CYAN='\033[0;36m' GREEN='\033[0;32m' YELLOW='\033[1;33m'
WHITE='\033[1;37m' RED='\033[0;31m' BLUE='\033[0;34m' NC='\033[0m' BOLD='\033[1m'

print_header() {
    clear
    echo -e "${BLUE}╔══════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}${BOLD}     📋 Sanchala Kanban v$VERSION       ${NC}${BLUE}║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════╝${NC}\n"
}

create_board() {
    print_header
    read -p "Board name: " name
    local dir="$BOARDS_DIR/${name// /_}"
    mkdir -p "$dir"/{todo,doing,done}
    echo -e "${GREEN}✓ Board created${NC}"
    read -p "Press Enter..."
}

show_board() {
    local board="$1"
    print_header
    echo -e "${BOLD}$(basename "$board")${NC}\n"
    printf "${RED}%-20s${NC} ${YELLOW}%-20s${NC} ${GREEN}%-20s${NC}\n" "TODO" "DOING" "DONE"
    echo "─────────────────────────────────────────────────────────────"
    
    local todo=($(ls "$board/todo" 2>/dev/null))
    local doing=($(ls "$board/doing" 2>/dev/null))
    local done=($(ls "$board/done" 2>/dev/null))
    local max=${#todo[@]}; [[ ${#doing[@]} -gt $max ]] && max=${#doing[@]}; [[ ${#done[@]} -gt $max ]] && max=${#done[@]}
    
    for ((i=0; i<max; i++)); do
        local t="${todo[$i]:-}"
        local d="${doing[$i]:-}"
        local dn="${done[$i]:-}"
        printf "${RED}%-20s${NC} ${YELLOW}%-20s${NC} ${GREEN}%-20s${NC}\n" "${t:0:18}" "${d:0:18}" "${dn:0:18}"
    done
}

manage_board() {
    local board="$1"
    while true; do
        show_board "$board"
        echo -e "\n${CYAN}[a]dd [m]ove [d]elete [v]iew [b]ack${NC}"
        read -p "Choice: " cmd
        case $cmd in
            a) read -p "Task: " task; read -p "Column (1=todo 2=doing 3=done): " col
               local cols=("todo" "doing" "done")
               touch "$board/${cols[$((col-1))]}/${task// /_}"
               echo -e "${GREEN}Added${NC}";;
            m) read -p "Task: " task; read -p "To (1=todo 2=doing 3=done): " col
               local cols=("todo" "doing" "done")
               local src=$(find "$board" -name "${task// /_}" 2>/dev/null | head -1)
               [[ -f "$src" ]] && mv "$src" "$board/${cols[$((col-1))]}/";;
            d) read -p "Task: " task
               find "$board" -name "${task// /_}" -delete 2>/dev/null;;
            v) read -p "Task: " task
               local f=$(find "$board" -name "${task// /_}" 2>/dev/null | head -1)
               [[ -f "$f" ]] && cat "$f"
               read -p "Enter...";;
            b) break;;
        esac
    done
}

list_boards() {
    print_header
    echo -e "${BOLD}Your Boards${NC}\n"
    local i=1
    for b in "$BOARDS_DIR"/*/; do
        [[ -d "$b" ]] || continue
        local name=$(basename "$b")
        local todo=$(ls "$b/todo" 2>/dev/null | wc -l)
        local doing=$(ls "$b/doing" 2>/dev/null | wc -l)
        local done=$(ls "$b/done" 2>/dev/null | wc -l)
        echo -e "${WHITE}$i)${NC} $name ${RED}[$todo]${NC} ${YELLOW}[$doing]${NC} ${GREEN}[$done]${NC}"
        ((i++))
    done
    [[ $i -eq 1 ]] && echo -e "${YELLOW}No boards${NC}"
    echo
    read -p "Open board #: " n
    local b=$(ls -d "$BOARDS_DIR"/*/ 2>/dev/null | sed -n "${n}p")
    [[ -d "$b" ]] && manage_board "$b"
}

main_menu() {
    while true; do
        print_header
        echo -e "  ${WHITE}1)${NC} ➕ Create Board"
        echo -e "  ${WHITE}2)${NC} 📋 List Boards"
        echo -e "  ${WHITE}0)${NC} Exit\n"
        read -p "Choice: " c
        case $c in 1) create_board;; 2) list_boards;; 0) exit 0;; esac
    done
}
main_menu
