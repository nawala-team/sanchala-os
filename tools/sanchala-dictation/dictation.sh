#!/bin/bash
# Sanchala Dictation - Voice-to-Text & Note Taking
VERSION="2.0.0"
TOOL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$TOOL_DIR/lib/core.sh" 2>/dev/null || source "$TOOL_DIR/lib/functions.sh"
CONFIG_DIR="$HOME/.config/sanchala/dictation"
DATA_DIR="$CONFIG_DIR/data"
NOTES_DIR="$DATA_DIR/notes"
RECORDINGS_DIR="$DATA_DIR/recordings"
mkdir -p "$NOTES_DIR" "$RECORDINGS_DIR"

RED='\033[0;31m' GREEN='\033[0;32m' YELLOW='\033[1;33m'
CYAN='\033[0;36m' WHITE='\033[1;37m' NC='\033[0m' BOLD='\033[1m'

print_header() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}${BOLD}   🎤 Sanchala Dictation v$VERSION     ${NC}${CYAN}║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════╝${NC}\n"
}

check_voice() {
    command -v termux-speech-to-text &>/dev/null && echo "termux" && return
    command -v whisper &>/dev/null && echo "whisper" && return
    echo "none"
}

speech_to_text() {
    local engine=$(check_voice)
    case "$engine" in
        termux) termux-speech-to-text 2>/dev/null ;;
        whisper) [[ -f "$1" ]] && whisper "$1" --model tiny -o txt 2>/dev/null ;;
        *) echo -e "${YELLOW}No speech engine. Install termux-api${NC}" >&2 ;;
    esac
}

quick_note() {
    print_header
    echo -e "${BOLD}Quick Voice Note${NC}\n"
    echo -e "${CYAN}Listening...${NC}"
    local text=$(speech_to_text)
    if [[ -n "$text" ]]; then
        local file="$NOTES_DIR/voice_$(date +%Y%m%d_%H%M%S).txt"
        echo -e "Date: $(date)\n\n$text" > "$file"
        echo -e "${GREEN}✓ Saved: $file${NC}\n$text"
    fi
    read -p "Press Enter..."
}

create_note() {
    print_header
    read -p "Note title: " title
    local file="$NOTES_DIR/${title// /_}_$(date +%Y%m%d_%H%M%S).txt"
    echo -e "${CYAN}Enter content (Ctrl+D to save):${NC}"
    echo -e "Title: $title\nDate: $(date)\n" > "$file"
    cat >> "$file"
    echo -e "\n${GREEN}✓ Saved: $file${NC}"
    read -p "Press Enter..."
}

list_notes() {
    print_header
    echo -e "${BOLD}Your Notes${NC}\n"
    local i=1
    for f in $(ls -t "$NOTES_DIR"/*.txt 2>/dev/null | head -20); do
        printf "${WHITE}%2d)${NC} %s\n" $i "$(basename "$f")"
        ((i++))
    done
    [[ $i -eq 1 ]] && echo -e "${YELLOW}No notes found${NC}"
    echo -e "\n${CYAN}[v]iew [d]elete [b]ack${NC}"
    read -p "Choice: " cmd
    case $cmd in
        v) read -p "Number: " n
           local f=$(ls -t "$NOTES_DIR"/*.txt 2>/dev/null | sed -n "${n}p")
           [[ -f "$f" ]] && cat "$f"
           read -p "Press Enter..." ;;
        d) read -p "Number: " n
           local f=$(ls -t "$NOTES_DIR"/*.txt 2>/dev/null | sed -n "${n}p")
           [[ -f "$f" ]] && rm "$f" && echo -e "${GREEN}Deleted${NC}"
           read -p "Press Enter..." ;;
    esac
}

search_notes() {
    print_header
    read -p "Search: " term
    [[ -z "$term" ]] && return
    echo -e "\n${CYAN}Results:${NC}"
    grep -ril "$term" "$NOTES_DIR" 2>/dev/null | while read f; do
        echo "- $(basename "$f")"
        grep -i -m1 "$term" "$f" | head -c 60
        echo
    done
    read -p "Press Enter..."
}

record_audio() {
    local out="$RECORDINGS_DIR/rec_$(date +%Y%m%d_%H%M%S).wav"
    echo -e "${RED}● Recording...${NC} Ctrl+C to stop"
    if command -v termux-microphone-record &>/dev/null; then
        termux-microphone-record -f "$out" -l 0
    elif command -v arecord &>/dev/null; then
        arecord -f cd "$out"
    else
        echo -e "${YELLOW}No recorder available${NC}"
        return
    fi
    echo -e "${GREEN}✓ Saved: $out${NC}"
}

export_notes() {
    local out="$DATA_DIR/export_$(date +%Y%m%d).txt"
    for f in "$NOTES_DIR"/*.txt; do
        echo "=== $(basename "$f") ===" >> "$out"
        cat "$f" >> "$out"
        echo -e "\n" >> "$out"
    done
    echo -e "${GREEN}✓ Exported: $out${NC}"
    read -p "Press Enter..."
}

stats() {
    print_header
    echo -e "${BOLD}Statistics${NC}\n"
    echo -e "Notes: $(ls -1 "$NOTES_DIR"/*.txt 2>/dev/null | wc -l)"
    echo -e "Recordings: $(ls -1 "$RECORDINGS_DIR"/*.wav 2>/dev/null | wc -l)"
    echo -e "Total words: $(cat "$NOTES_DIR"/*.txt 2>/dev/null | wc -w)"
    read -p "Press Enter..."
}

main_menu() {
    while true; do
        print_header
        local v=$(check_voice)
        [[ "$v" != "none" ]] && echo -e "${GREEN}✓ Voice: $v${NC}\n"
        echo -e "  ${WHITE}1)${NC} 🎤 Quick Dictation"
        echo -e "  ${WHITE}2)${NC} 📝 Create Note"
        echo -e "  ${WHITE}3)${NC} 📋 List Notes"
        echo -e "  ${WHITE}4)${NC} 🔍 Search"
        echo -e "  ${WHITE}5)${NC} 🎙️  Record Audio"
        echo -e "  ${WHITE}6)${NC} 📤 Export"
        echo -e "  ${WHITE}7)${NC} 📊 Stats"
        echo -e "  ${WHITE}0)${NC} Exit"
        echo
        read -p "Choice: " c
        case $c in
            1) quick_note ;; 2) create_note ;; 3) list_notes ;;
            4) search_notes ;; 5) record_audio; read -p "Enter..." ;;
            6) export_notes ;; 7) stats ;; 0) exit 0 ;;
        esac
    done
}

case "$1" in
    -h|--help) echo "Sanchala Dictation v$VERSION"; echo "Usage: $0 [-d|-n|-l|-s]" ;;
    -d) quick_note ;; -n) create_note ;; -l) list_notes ;; -s) search_notes ;;
    *) main_menu ;;
esac
