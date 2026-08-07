#!/bin/bash
# Sanchala PDF Tools - PDF Manipulation Suite
VERSION="2.0.0"
CONFIG_DIR="$HOME/.config/sanchala/pdf-tools"
OUTPUT_DIR="$CONFIG_DIR/output"
mkdir -p "$OUTPUT_DIR"

CYAN='\033[0;36m' GREEN='\033[0;32m' YELLOW='\033[1;33m'
WHITE='\033[1;37m' RED='\033[0;31m' NC='\033[0m' BOLD='\033[1m'

print_header() {
    clear
    echo -e "${RED}╔══════════════════════════════════════════╗${NC}"
    echo -e "${RED}║${NC}${BOLD}     📄 Sanchala PDF Tools v$VERSION     ${NC}${RED}║${NC}"
    echo -e "${RED}╚══════════════════════════════════════════╝${NC}\n"
}

check_deps() {
    local missing=""
    command -v pdftk &>/dev/null || missing+="pdftk "
    command -v gs &>/dev/null || missing+="ghostscript "
    command -v pdftotext &>/dev/null || missing+="poppler "
    [[ -n "$missing" ]] && echo -e "${YELLOW}Optional: $missing${NC}\n"
}

merge_pdfs() {
    print_header
    echo -e "${BOLD}Merge PDFs${NC}\n"
    echo "Enter PDF files (empty to finish):"
    local files=()
    while true; do
        read -p "File: " f
        [[ -z "$f" ]] && break
        [[ -f "$f" ]] && files+=("$f") || echo -e "${RED}Not found${NC}"
    done
    
    [[ ${#files[@]} -lt 2 ]] && echo -e "${YELLOW}Need at least 2 files${NC}" && read -p "Enter..." && return
    
    local out="$OUTPUT_DIR/merged_$(date +%Y%m%d_%H%M%S).pdf"
    if command -v pdftk &>/dev/null; then
        pdftk "${files[@]}" cat output "$out"
    elif command -v gs &>/dev/null; then
        gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile="$out" "${files[@]}"
    else
        echo -e "${RED}No PDF tools available${NC}"
        read -p "Enter..." && return
    fi
    echo -e "${GREEN}✓ Merged: $out${NC}"
    read -p "Press Enter..."
}

split_pdf() {
    print_header
    echo -e "${BOLD}Split PDF${NC}\n"
    read -p "PDF file: " pdf
    [[ ! -f "$pdf" ]] && echo -e "${RED}Not found${NC}" && read -p "Enter..." && return
    
    read -p "Pages (e.g., 1-3,5,7-9): " pages
    local out="$OUTPUT_DIR/split_$(date +%Y%m%d_%H%M%S).pdf"
    
    if command -v pdftk &>/dev/null; then
        pdftk "$pdf" cat $pages output "$out"
    elif command -v gs &>/dev/null; then
        gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -dFirstPage=${pages%%-*} -dLastPage=${pages##*-} -sOutputFile="$out" "$pdf"
    fi
    echo -e "${GREEN}✓ Created: $out${NC}"
    read -p "Press Enter..."
}

compress_pdf() {
    print_header
    echo -e "${BOLD}Compress PDF${NC}\n"
    read -p "PDF file: " pdf
    [[ ! -f "$pdf" ]] && echo -e "${RED}Not found${NC}" && read -p "Enter..." && return
    
    local out="$OUTPUT_DIR/compressed_$(basename "$pdf")"
    if command -v gs &>/dev/null; then
        gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook \
           -dNOPAUSE -dQUIET -dBATCH -sOutputFile="$out" "$pdf"
        local orig=$(stat -c%s "$pdf" 2>/dev/null || stat -f%z "$pdf" 2>/dev/null)
        local new=$(stat -c%s "$out" 2>/dev/null || stat -f%z "$out" 2>/dev/null)
        echo -e "${GREEN}✓ Compressed: $out${NC}"
        echo -e "Original: $((orig/1024))KB → New: $((new/1024))KB"
    else
        echo -e "${RED}Requires ghostscript${NC}"
    fi
    read -p "Press Enter..."
}

pdf_to_text() {
    print_header
    echo -e "${BOLD}PDF to Text${NC}\n"
    read -p "PDF file: " pdf
    [[ ! -f "$pdf" ]] && echo -e "${RED}Not found${NC}" && read -p "Enter..." && return
    
    local out="$OUTPUT_DIR/$(basename "${pdf%.pdf}").txt"
    if command -v pdftotext &>/dev/null; then
        pdftotext "$pdf" "$out"
        echo -e "${GREEN}✓ Extracted: $out${NC}"
    else
        echo -e "${RED}Requires poppler-utils${NC}"
    fi
    read -p "Press Enter..."
}

pdf_info() {
    print_header
    echo -e "${BOLD}PDF Information${NC}\n"
    read -p "PDF file: " pdf
    [[ ! -f "$pdf" ]] && echo -e "${RED}Not found${NC}" && read -p "Enter..." && return
    
    if command -v pdfinfo &>/dev/null; then
        pdfinfo "$pdf"
    elif command -v pdftk &>/dev/null; then
        pdftk "$pdf" dump_data | grep -E "^(Title|Author|Pages|Creator)"
    else
        local size=$(stat -c%s "$pdf" 2>/dev/null || stat -f%z "$pdf" 2>/dev/null)
        echo "File: $(basename "$pdf")"
        echo "Size: $((size/1024))KB"
    fi
    read -p $'\nPress Enter...'
}

rotate_pdf() {
    print_header
    echo -e "${BOLD}Rotate PDF${NC}\n"
    read -p "PDF file: " pdf
    [[ ! -f "$pdf" ]] && echo -e "${RED}Not found${NC}" && read -p "Enter..." && return
    
    echo "1) 90° CW  2) 180°  3) 90° CCW"
    read -p "Rotation: " r
    local rot=("" "east" "south" "west")
    local out="$OUTPUT_DIR/rotated_$(basename "$pdf")"
    
    if command -v pdftk &>/dev/null; then
        pdftk "$pdf" cat 1-end${rot[$r]} output "$out"
        echo -e "${GREEN}✓ Rotated: $out${NC}"
    fi
    read -p "Press Enter..."
}

main_menu() {
    while true; do
        print_header
        check_deps
        echo -e "  ${WHITE}1)${NC} 📎 Merge PDFs"
        echo -e "  ${WHITE}2)${NC} ✂️  Split PDF"
        echo -e "  ${WHITE}3)${NC} 🗜️  Compress PDF"
        echo -e "  ${WHITE}4)${NC} 📝 PDF to Text"
        echo -e "  ${WHITE}5)${NC} ℹ️  PDF Info"
        echo -e "  ${WHITE}6)${NC} 🔄 Rotate PDF"
        echo -e "  ${WHITE}0)${NC} Exit\n"
        read -p "Choice: " c
        case $c in 1) merge_pdfs;; 2) split_pdf;; 3) compress_pdf;; 4) pdf_to_text;; 5) pdf_info;; 6) rotate_pdf;; 0) exit 0;; esac
    done
}
main_menu
