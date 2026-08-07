#!/bin/bash
# Sanchala Flowchart - ASCII Flowchart Creator
VERSION="2.0.0"
CONFIG_DIR="$HOME/.config/sanchala/flowchart"
CHARTS_DIR="$CONFIG_DIR/charts"
mkdir -p "$CHARTS_DIR"

CYAN='\033[0;36m' GREEN='\033[0;32m' YELLOW='\033[1;33m'
WHITE='\033[1;37m' BLUE='\033[0;34m' NC='\033[0m' BOLD='\033[1m'

print_header() {
    clear
    echo -e "${BLUE}╔══════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}${BOLD}    📊 Sanchala Flowchart v$VERSION     ${NC}${BLUE}║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════╝${NC}\n"
}

draw_box() {
    local text="$1" type="${2:-process}"
    local len=${#text}
    case $type in
        start|end)
            echo "    ╭$(printf '─%.0s' $(seq 1 $((len+2))))╮"
            echo "    │ $text │"
            echo "    ╰$(printf '─%.0s' $(seq 1 $((len+2))))╯";;
        process)
            echo "    ┌$(printf '─%.0s' $(seq 1 $((len+2))))┐"
            echo "    │ $text │"
            echo "    └$(printf '─%.0s' $(seq 1 $((len+2))))┘";;
        decision)
            echo "       ◇"
            echo "      ╱ ╲"
            echo "     ╱$text╲"
            echo "     ╲   ╱"
            echo "      ╲ ╱";;
        io)
            echo "    ╱$(printf '─%.0s' $(seq 1 $((len+2))))╲"
            echo "   ╱  $text  ╲"
            echo "   ╲$(printf '─%.0s' $(seq 1 $((len+4))))╱";;
    esac
}

draw_arrow() { echo "        │"; echo "        ▼"; }

create_flowchart() {
    print_header
    echo -e "${BOLD}Create Flowchart${NC}\n"
    read -p "Chart name: " name
    local file="$CHARTS_DIR/${name// /_}.fc"
    > "$file"
    
    echo -e "\n${CYAN}Add nodes: [s]tart [p]rocess [d]ecision [i]o [e]nd [done]${NC}\n"
    while true; do
        read -p "Type: " type
        [[ "$type" == "done" ]] && break
        read -p "Text: " text
        echo "$type:$text" >> "$file"
    done
    echo -e "${GREEN}✓ Saved: $file${NC}"
    read -p "Press Enter..."
}

render_flowchart() {
    local file="$1"
    echo -e "\n${BOLD}$(basename "${file%.fc}")${NC}\n"
    local first=true
    while IFS=: read -r type text; do
        [[ "$first" != "true" ]] && draw_arrow
        first=false
        case $type in
            s) draw_box "$text" "start";;
            p) draw_box "$text" "process";;
            d) draw_box "$text" "decision";;
            i) draw_box "$text" "io";;
            e) draw_box "$text" "end";;
        esac
    done < "$file"
}

list_charts() {
    print_header
    echo -e "${BOLD}Your Flowcharts${NC}\n"
    local i=1
    for f in "$CHARTS_DIR"/*.fc; do
        [[ -f "$f" ]] || continue
        echo -e "${WHITE}$i)${NC} $(basename "${f%.fc}")"
        ((i++))
    done
    [[ $i -eq 1 ]] && echo -e "${YELLOW}No charts${NC}"
    
    echo -e "\n${CYAN}[v]iew [e]xport [d]elete [b]ack${NC}"
    read -p "Choice: " cmd
    case $cmd in
        v) read -p "Number: " n
           local f=$(ls "$CHARTS_DIR"/*.fc 2>/dev/null | sed -n "${n}p")
           [[ -f "$f" ]] && { render_flowchart "$f"; read -p "Enter..."; };;
        e) read -p "Number: " n
           local f=$(ls "$CHARTS_DIR"/*.fc 2>/dev/null | sed -n "${n}p")
           [[ -f "$f" ]] && { render_flowchart "$f" > "${f%.fc}.txt"; echo -e "${GREEN}Exported${NC}"; };;
        d) read -p "Number: " n
           local f=$(ls "$CHARTS_DIR"/*.fc 2>/dev/null | sed -n "${n}p")
           [[ -f "$f" ]] && rm "$f";;
    esac
    read -p "Press Enter..."
}

quick_flowchart() {
    print_header
    echo -e "${BOLD}Quick Flowchart Templates${NC}\n"
    echo "1) Simple Process  2) Decision Flow  3) Loop"
    read -p "Template: " t
    
    case $t in
        1) draw_box "Start" "start"; draw_arrow
           draw_box "Process" "process"; draw_arrow
           draw_box "End" "end";;
        2) draw_box "Start" "start"; draw_arrow
           draw_box "?" "decision"; draw_arrow
           echo "    Yes ←──┤├──→ No"; draw_arrow
           draw_box "End" "end";;
        3) draw_box "Init" "start"; draw_arrow
           draw_box "Condition?" "decision"
           echo "    │ Yes"; draw_arrow
           draw_box "Process" "process"
           echo "    └────────┘";;
    esac
    read -p $'\nPress Enter...'
}

main_menu() {
    while true; do
        print_header
        echo -e "  ${WHITE}1)${NC} ➕ Create Flowchart"
        echo -e "  ${WHITE}2)${NC} 📋 List Charts"
        echo -e "  ${WHITE}3)${NC} ⚡ Quick Templates"
        echo -e "  ${WHITE}0)${NC} Exit\n"
        read -p "Choice: " c
        case $c in 1) create_flowchart;; 2) list_charts;; 3) quick_flowchart;; 0) exit 0;; esac
    done
}
main_menu
