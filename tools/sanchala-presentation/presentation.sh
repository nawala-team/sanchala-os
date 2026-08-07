#!/bin/bash
# Sanchala Presentation - Slide Presentation Tool
VERSION="2.0.0"
CONFIG_DIR="$HOME/.config/sanchala/presentation"
PRESENTATIONS_DIR="$CONFIG_DIR/presentations"
mkdir -p "$PRESENTATIONS_DIR"

CYAN='\033[0;36m' GREEN='\033[0;32m' YELLOW='\033[1;33m'
WHITE='\033[1;37m' BLUE='\033[0;34m' MAGENTA='\033[0;35m' NC='\033[0m' BOLD='\033[1m'

print_header() {
    clear
    echo -e "${MAGENTA}╔══════════════════════════════════════════╗${NC}"
    echo -e "${MAGENTA}║${NC}${BOLD}   📽️  Sanchala Presentation v$VERSION  ${NC}${MAGENTA}║${NC}"
    echo -e "${MAGENTA}╚══════════════════════════════════════════╝${NC}\n"
}

create_presentation() {
    print_header
    echo -e "${BOLD}Create Presentation${NC}\n"
    read -p "Title: " title
    read -p "Author: " author
    
    local dir="$PRESENTATIONS_DIR/${title// /_}"
    mkdir -p "$dir"
    echo -e "title: $title\nauthor: $author\ndate: $(date +%Y-%m-%d)" > "$dir/meta.txt"
    
    echo -e "\n${CYAN}Add slides (empty title to finish)${NC}\n"
    local n=1
    while true; do
        read -p "Slide $n title: " stitle
        [[ -z "$stitle" ]] && break
        
        local slide="$dir/slide_$(printf '%02d' $n).md"
        echo "# $stitle" > "$slide"
        echo -e "\n${CYAN}Content (Ctrl+D):${NC}"
        cat >> "$slide"
        ((n++))
    done
    
    echo -e "${GREEN}✓ Created with $((n-1)) slides${NC}"
    read -p "Press Enter..."
}

render_slide() {
    local file="$1" num="$2" total="$3"
    clear
    local width=60
    
    # Top border
    echo -e "${MAGENTA}╔$(printf '═%.0s' $(seq 1 $width))╗${NC}"
    
    # Content
    local title=$(head -1 "$file" | sed 's/^# //')
    local padding=$(( (width - ${#title}) / 2 ))
    echo -e "${MAGENTA}║${NC}${BOLD}$(printf ' %.0s' $(seq 1 $padding))$title$(printf ' %.0s' $(seq 1 $((width - padding - ${#title}))))${NC}${MAGENTA}║${NC}"
    echo -e "${MAGENTA}║$(printf ' %.0s' $(seq 1 $width))║${NC}"
    
    # Body
    tail -n +2 "$file" | while IFS= read -r line; do
        local pline="  $line"
        printf "${MAGENTA}║${NC} %-$((width-2))s ${MAGENTA}║${NC}\n" "${pline:0:$((width-2))}"
    done
    
    # Padding
    for i in {1..5}; do
        echo -e "${MAGENTA}║$(printf ' %.0s' $(seq 1 $width))║${NC}"
    done
    
    # Bottom border with slide number
    echo -e "${MAGENTA}╠$(printf '═%.0s' $(seq 1 $width))╣${NC}"
    local nav="  ← prev | $num/$total | next →  "
    local navpad=$(( (width - ${#nav}) / 2 ))
    echo -e "${MAGENTA}║${NC}$(printf ' %.0s' $(seq 1 $navpad))${CYAN}$nav${NC}$(printf ' %.0s' $(seq 1 $((width - navpad - ${#nav}))))${MAGENTA}║${NC}"
    echo -e "${MAGENTA}╚$(printf '═%.0s' $(seq 1 $width))╝${NC}"
}

present() {
    local dir="$1"
    local slides=($(ls "$dir"/slide_*.md 2>/dev/null | sort))
    local total=${#slides[@]}
    local current=0
    
    [[ $total -eq 0 ]] && echo -e "${YELLOW}No slides${NC}" && return
    
    while true; do
        render_slide "${slides[$current]}" $((current+1)) $total
        echo -e "\n${CYAN}[n]ext [p]rev [q]uit [g]oto${NC}"
        read -rsn1 key
        case $key in
            n|"") [[ $current -lt $((total-1)) ]] && ((current++));;
            p) [[ $current -gt 0 ]] && ((current--));;
            g) read -p "Slide #: " n; [[ $n -ge 1 && $n -le $total ]] && current=$((n-1));;
            q) break;;
        esac
    done
}

list_presentations() {
    print_header
    echo -e "${BOLD}Your Presentations${NC}\n"
    local i=1
    for d in "$PRESENTATIONS_DIR"/*/; do
        [[ -d "$d" ]] || continue
        local name=$(basename "$d")
        local slides=$(ls "$d"/slide_*.md 2>/dev/null | wc -l)
        local author=$(grep "author:" "$d/meta.txt" 2>/dev/null | cut -d: -f2)
        echo -e "${WHITE}$i)${NC} $name ${CYAN}($slides slides)${NC}$author"
        ((i++))
    done
    [[ $i -eq 1 ]] && echo -e "${YELLOW}No presentations${NC}"
    
    echo -e "\n${CYAN}[p]resent [e]dit [d]elete [b]ack${NC}"
    read -p "Choice: " cmd
    case $cmd in
        p) read -p "Number: " n
           local d=$(ls -d "$PRESENTATIONS_DIR"/*/ 2>/dev/null | sed -n "${n}p")
           [[ -d "$d" ]] && present "$d";;
        e) read -p "Number: " n
           local d=$(ls -d "$PRESENTATIONS_DIR"/*/ 2>/dev/null | sed -n "${n}p")
           [[ -d "$d" ]] && ${EDITOR:-nano} "$d"/*.md;;
        d) read -p "Number: " n
           local d=$(ls -d "$PRESENTATIONS_DIR"/*/ 2>/dev/null | sed -n "${n}p")
           [[ -d "$d" ]] && rm -rf "$d" && echo -e "${GREEN}Deleted${NC}";;
    esac
    read -p "Press Enter..."
}

export_presentation() {
    print_header
    echo -e "${BOLD}Export Presentation${NC}\n"
    local i=1
    for d in "$PRESENTATIONS_DIR"/*/; do
        [[ -d "$d" ]] || continue
        echo -e "${WHITE}$i)${NC} $(basename "$d")"
        ((i++))
    done
    
    read -p "Number: " n
    local d=$(ls -d "$PRESENTATIONS_DIR"/*/ 2>/dev/null | sed -n "${n}p")
    [[ ! -d "$d" ]] && return
    
    local out="$CONFIG_DIR/$(basename "$d").md"
    local title=$(grep "title:" "$d/meta.txt" 2>/dev/null | cut -d: -f2)
    echo "# $title" > "$out"
    echo "---" >> "$out"
    
    for slide in "$d"/slide_*.md; do
        cat "$slide" >> "$out"
        echo -e "\n---\n" >> "$out"
    done
    
    echo -e "${GREEN}✓ Exported: $out${NC}"
    read -p "Press Enter..."
}

main_menu() {
    while true; do
        print_header
        echo -e "  ${WHITE}1)${NC} ➕ Create Presentation"
        echo -e "  ${WHITE}2)${NC} 📋 List & Present"
        echo -e "  ${WHITE}3)${NC} 📤 Export to Markdown"
        echo -e "  ${WHITE}0)${NC} Exit\n"
        read -p "Choice: " c
        case $c in 1) create_presentation;; 2) list_presentations;; 3) export_presentation;; 0) exit 0;; esac
    done
}
main_menu
