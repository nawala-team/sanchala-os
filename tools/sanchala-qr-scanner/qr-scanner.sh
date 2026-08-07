#!/bin/bash
# Sanchala QR Scanner - QR Code Generator & Scanner
VERSION="2.0.0"
CONFIG_DIR="$HOME/.config/sanchala/qr-scanner"
HISTORY_DIR="$CONFIG_DIR/history"
mkdir -p "$HISTORY_DIR"

CYAN='\033[0;36m' GREEN='\033[0;32m' YELLOW='\033[1;33m'
WHITE='\033[1;37m' NC='\033[0m' BOLD='\033[1m'

print_header() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}${BOLD}    📱 Sanchala QR Scanner v$VERSION    ${NC}${CYAN}║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════╝${NC}\n"
}

generate_qr() {
    print_header
    echo -e "${BOLD}Generate QR Code${NC}\n"
    echo "1) Text/URL  2) WiFi  3) Contact  4) Email"
    read -p "Type: " type
    local data=""
    case $type in
        1) read -p "Text/URL: " data;;
        2) read -p "SSID: " ssid; read -p "Password: " pass; read -p "Type (WPA/WEP): " enc
           data="WIFI:T:$enc;S:$ssid;P:$pass;;";;
        3) read -p "Name: " name; read -p "Phone: " phone; read -p "Email: " email
           data="MECARD:N:$name;TEL:$phone;EMAIL:$email;;";;
        4) read -p "Email: " email; read -p "Subject: " subj
           data="mailto:$email?subject=$subj";;
    esac
    
    [[ -z "$data" ]] && return
    local outfile="$HISTORY_DIR/qr_$(date +%Y%m%d_%H%M%S).png"
    
    if command -v qrencode &>/dev/null; then
        qrencode -o "$outfile" -s 10 "$data"
        echo -e "${GREEN}✓ Saved: $outfile${NC}"
        command -v termux-open &>/dev/null && termux-open "$outfile"
    else
        # ASCII fallback
        echo -e "\n${CYAN}QR Code (ASCII):${NC}"
        if command -v qrencode &>/dev/null; then
            qrencode -t ANSI "$data"
        else
            echo -e "${YELLOW}Install: pkg install libqrencode${NC}"
        fi
    fi
    read -p "Press Enter..."
}

scan_qr() {
    print_header
    echo -e "${BOLD}Scan QR Code${NC}\n"
    
    if command -v termux-camera-photo &>/dev/null; then
        local photo="/tmp/qr_scan_$$.jpg"
        echo -e "${CYAN}Taking photo...${NC}"
        termux-camera-photo -c 0 "$photo"
        if command -v zbarimg &>/dev/null; then
            local result=$(zbarimg -q "$photo" 2>/dev/null)
            echo -e "\n${GREEN}Result:${NC} $result"
            echo "$result" >> "$HISTORY_DIR/scans.log"
        else
            echo -e "${YELLOW}Install: pkg install zbar${NC}"
        fi
        rm -f "$photo"
    elif command -v zbarcam &>/dev/null; then
        echo -e "${CYAN}Point camera at QR code...${NC}"
        zbarcam --raw
    else
        echo -e "${YELLOW}No camera support. Install termux-api or zbar${NC}"
    fi
    read -p "Press Enter..."
}

scan_image() {
    print_header
    echo -e "${BOLD}Scan Image File${NC}\n"
    read -p "Image path: " img
    [[ ! -f "$img" ]] && echo -e "${YELLOW}File not found${NC}" && read -p "Enter..." && return
    
    if command -v zbarimg &>/dev/null; then
        local result=$(zbarimg -q "$img" 2>/dev/null)
        echo -e "${GREEN}Result:${NC} $result"
    else
        echo -e "${YELLOW}Install: pkg install zbar${NC}"
    fi
    read -p "Press Enter..."
}

show_history() {
    print_header
    echo -e "${BOLD}History${NC}\n"
    echo -e "${CYAN}Generated:${NC}"
    ls -lt "$HISTORY_DIR"/*.png 2>/dev/null | head -5
    echo -e "\n${CYAN}Scanned:${NC}"
    tail -10 "$HISTORY_DIR/scans.log" 2>/dev/null
    read -p "Press Enter..."
}

main_menu() {
    while true; do
        print_header
        echo -e "  ${WHITE}1)${NC} 📝 Generate QR Code"
        echo -e "  ${WHITE}2)${NC} 📷 Scan with Camera"
        echo -e "  ${WHITE}3)${NC} 🖼️  Scan Image File"
        echo -e "  ${WHITE}4)${NC} 📜 History"
        echo -e "  ${WHITE}0)${NC} Exit\n"
        read -p "Choice: " c
        case $c in 1) generate_qr;; 2) scan_qr;; 3) scan_image;; 4) show_history;; 0) exit 0;; esac
    done
}
main_menu
