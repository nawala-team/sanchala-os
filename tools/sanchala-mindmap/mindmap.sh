#!/bin/bash
# Sanchala Mindmap - Visual Mind Mapping Tool
VERSION="2.0.0"
CONFIG_DIR="$HOME/.config/sanchala/mindmap"
MAPS_DIR="$CONFIG_DIR/maps"
mkdir -p "$MAPS_DIR"

CYAN='\033[0;36m' GREEN='\033[0;32m' YELLOW='\033[1;33m'
WHITE='\033[1;37m' MAGENTA='\033[0;35m' NC='\033[0m' BOLD='\033[1m'

print_header() {
    clear
    echo -e "${MAGENTA}╔══════════════════════════════════════════╗${NC}"
    echo -e "${MAGENTA}║${NC}${BOLD}     🧠 Sanchala Mindmap v$VERSION      ${NC}${MAGENTA}║${NC}"
    echo -e "${MAGENTA}╚══════════════════════════════════════════╝${NC}\n"
}

create_map() {
    print_header
    echo -e "${BOLD}Create Mind Map${NC}\n"
    read -p "Map name: " name
    local file="$MAPS_DIR/${name// /_}.map"
    read -p "Central topic: " central
    echo "$central" > "$file"
    echo -e "${GREEN}✓ Created: $file${NC}"
    edit_map "$file"
}

edit_map() {
    local file="$1"
    [[ ! -f "$file" ]] && return
    while true; do
        print_header
        echo -e "${BOLD}$(basename "${file%.map}")${NC}\n"
        display_map "$file"
        echo -e "\n${CYAN}[a]dd node [d]elete [r]ename [b]ack${NC}"
        read -p "Choice: " cmd
        case $cmd in
            a) read -p "Parent (or Enter for root): " parent
               read -p "New node: " node
               if [[ -z "$parent" ]]; then
                   echo "  $node" >> "$file"
               else
                   sed -i "/$parent/a\\    $node" "$file"
               fi;;
            d) read -p "Node to delete: " node
               sed -i "/$node/d" "$file";;
            r) read -p "Old name: " old; read -p "New name: " new
               sed -i "s/$old/$new/g" "$file";;
            b) break;;
        esac
    done
}

display_map() {
    local file="$1"
    local root=$(head -1 "$file")
    echo -e "${MAGENTA}◉ $root${NC}"
    tail -n +2 "$file" | while read line; do
        local indent=$(echo "$line" | sed 's/[^ ].*//' | wc -c)
        local text=$(echo "$line" | sed 's/^ *//')
        local prefix=$(printf '│   %.0s' $(seq 1 $((indent/2-1))))
        echo -e "${CYAN}$prefix├── $text${NC}"
    done
}

list_maps() {
    print_header
    echo -e "${BOLD}Your Mind Maps${NC}\n"
    local i=1
    for f in "$MAPS_DIR"/*.map; do
        [[ -f "$f" ]] || continue
        local name=$(basename "${f%.map}")
        local root=$(head -1 "$f")
        echo -e "${WHITE}$i)${NC} $name - ${CYAN}$root${NC}"
        ((i++))
    done
    [[ $i -eq 1 ]] && echo -e "${YELLOW}No maps yet${NC}"
    echo -e "\n${CYAN}[o]pen [d]elete [e]xport [b]ack${NC}"
    read -p "Choice: " cmd
    case $cmd in
        o) read -p "Number: " n
           local f=$(ls "$MAPS_DIR"/*.map 2>/dev/null | sed -n "${n}p")
           [[ -f "$f" ]] && edit_map "$f";;
        d) read -p "Number: " n
           local f=$(ls "$MAPS_DIR"/*.map 2>/dev/null | sed -n "${n}p")
           [[ -f "$f" ]] && rm "$f" && echo -e "${GREEN}Deleted${NC}";;
        e) read -p "Number: " n
           local f=$(ls "$MAPS_DIR"/*.map 2>/dev/null | sed -n "${n}p")
           [[ -f "$f" ]] && export_map "$f";;
    esac
    read -p "Press Enter..."
}

export_map() {
    local file="$1"
    local out="${file%.map}.md"
    local root=$(head -1 "$file")
    echo "# $root" > "$out"
    tail -n +2 "$file" | while read line; do
        local indent=$(echo "$line" | sed 's/[^ ].*//' | wc -c)
        local text=$(echo "$line" | sed 's/^ *//')
        local md=$(printf '  %.0s' $(seq 1 $((indent/2))))
        echo "${md}- $text" >> "$out"
    done
    echo -e "${GREEN}✓ Exported: $out${NC}"
}

main_menu() {
    while true; do
        print_header
        echo -e "  ${WHITE}1)${NC} ➕ Create Mind Map"
        echo -e "  ${WHITE}2)${NC} 📋 List Maps"
        echo -e "  ${WHITE}3)${NC} 📖 Quick View"
        echo -e "  ${WHITE}0)${NC} Exit\n"
        read -p "Choice: " c
        case $c in
            1) create_map;;
            2) list_maps;;
            3) read -p "Map #: " n
               local f=$(ls "$MAPS_DIR"/*.map 2>/dev/null | sed -n "${n}p")
               [[ -f "$f" ]] && display_map "$f" && read -p "Enter...";;
            0) exit 0;;
        esac
    done
}
main_menu
