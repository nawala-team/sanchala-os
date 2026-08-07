#!/bin/bash
# Sanchala Unit Converter - Universal Unit Conversion
VERSION="2.0.0"
CONFIG_DIR="$HOME/.config/sanchala/unit-converter"
mkdir -p "$CONFIG_DIR"

CYAN='\033[0;36m' GREEN='\033[0;32m' YELLOW='\033[1;33m'
WHITE='\033[1;37m' NC='\033[0m' BOLD='\033[1m'

print_header() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}${BOLD}   📐 Sanchala Unit Converter v$VERSION ${NC}${CYAN}║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════╝${NC}\n"
}

calc() { echo "scale=6; $1" | bc 2>/dev/null; }

convert_length() {
    print_header
    echo -e "${BOLD}Length Conversion${NC}\n"
    echo "1)m→ft 2)ft→m 3)km→mi 4)mi→km 5)in→cm 6)cm→in"
    read -p "Type: " t; read -p "Value: " v
    case $t in
        1) echo -e "${GREEN}$v m = $(calc "$v*3.28084") ft${NC}";;
        2) echo -e "${GREEN}$v ft = $(calc "$v/3.28084") m${NC}";;
        3) echo -e "${GREEN}$v km = $(calc "$v*0.621371") mi${NC}";;
        4) echo -e "${GREEN}$v mi = $(calc "$v*1.60934") km${NC}";;
        5) echo -e "${GREEN}$v in = $(calc "$v*2.54") cm${NC}";;
        6) echo -e "${GREEN}$v cm = $(calc "$v/2.54") in${NC}";;
    esac
    read -p "Press Enter..."
}

convert_weight() {
    print_header
    echo -e "${BOLD}Weight Conversion${NC}\n"
    echo "1)kg→lb 2)lb→kg 3)g→oz 4)oz→g"
    read -p "Type: " t; read -p "Value: " v
    case $t in
        1) echo -e "${GREEN}$v kg = $(calc "$v*2.20462") lb${NC}";;
        2) echo -e "${GREEN}$v lb = $(calc "$v/2.20462") kg${NC}";;
        3) echo -e "${GREEN}$v g = $(calc "$v*0.035274") oz${NC}";;
        4) echo -e "${GREEN}$v oz = $(calc "$v/0.035274") g${NC}";;
    esac
    read -p "Press Enter..."
}

convert_temp() {
    print_header
    echo -e "${BOLD}Temperature Conversion${NC}\n"
    echo "1)C→F 2)F→C 3)C→K 4)K→C"
    read -p "Type: " t; read -p "Value: " v
    case $t in
        1) echo -e "${GREEN}$v°C = $(calc "$v*9/5+32")°F${NC}";;
        2) echo -e "${GREEN}$v°F = $(calc "($v-32)*5/9")°C${NC}";;
        3) echo -e "${GREEN}$v°C = $(calc "$v+273.15")K${NC}";;
        4) echo -e "${GREEN}$v K = $(calc "$v-273.15")°C${NC}";;
    esac
    read -p "Press Enter..."
}

convert_volume() {
    print_header
    echo -e "${BOLD}Volume Conversion${NC}\n"
    echo "1)L→gal 2)gal→L 3)ml→floz 4)floz→ml"
    read -p "Type: " t; read -p "Value: " v
    case $t in
        1) echo -e "${GREEN}$v L = $(calc "$v*0.264172") gal${NC}";;
        2) echo -e "${GREEN}$v gal = $(calc "$v*3.78541") L${NC}";;
        3) echo -e "${GREEN}$v ml = $(calc "$v*0.033814") fl oz${NC}";;
        4) echo -e "${GREEN}$v fl oz = $(calc "$v*29.5735") ml${NC}";;
    esac
    read -p "Press Enter..."
}

convert_data() {
    print_header
    echo -e "${BOLD}Data Conversion${NC}\n"
    echo "1)MB→GB 2)GB→MB 3)GB→TB 4)TB→GB 5)KB→MB"
    read -p "Type: " t; read -p "Value: " v
    case $t in
        1) echo -e "${GREEN}$v MB = $(calc "$v/1024") GB${NC}";;
        2) echo -e "${GREEN}$v GB = $(calc "$v*1024") MB${NC}";;
        3) echo -e "${GREEN}$v GB = $(calc "$v/1024") TB${NC}";;
        4) echo -e "${GREEN}$v TB = $(calc "$v*1024") GB${NC}";;
        5) echo -e "${GREEN}$v KB = $(calc "$v/1024") MB${NC}";;
    esac
    read -p "Press Enter..."
}

convert_time() {
    print_header
    echo -e "${BOLD}Time Conversion${NC}\n"
    echo "1)hr→min 2)min→sec 3)day→hr 4)week→day"
    read -p "Type: " t; read -p "Value: " v
    case $t in
        1) echo -e "${GREEN}$v hr = $(calc "$v*60") min${NC}";;
        2) echo -e "${GREEN}$v min = $(calc "$v*60") sec${NC}";;
        3) echo -e "${GREEN}$v day = $(calc "$v*24") hr${NC}";;
        4) echo -e "${GREEN}$v week = $(calc "$v*7") days${NC}";;
    esac
    read -p "Press Enter..."
}

currency_convert() {
    print_header
    echo -e "${BOLD}Currency (approximate)${NC}\n"
    read -p "Amount: " amt
    read -p "From (USD/EUR/GBP/INR): " from
    read -p "To: " to
    # Simple API call
    local rate=$(curl -s "https://api.exchangerate-api.com/v4/latest/$from" 2>/dev/null | grep -o "\"$to\":[0-9.]*" | cut -d: -f2)
    [[ -n "$rate" ]] && echo -e "${GREEN}$amt $from = $(calc "$amt*$rate") $to${NC}" || echo -e "${YELLOW}Couldn't fetch rate${NC}"
    read -p "Press Enter..."
}

main_menu() {
    while true; do
        print_header
        echo -e "  ${WHITE}1)${NC} 📏 Length"
        echo -e "  ${WHITE}2)${NC} ⚖️  Weight"
        echo -e "  ${WHITE}3)${NC} 🌡️  Temperature"
        echo -e "  ${WHITE}4)${NC} 🧪 Volume"
        echo -e "  ${WHITE}5)${NC} 💾 Data Size"
        echo -e "  ${WHITE}6)${NC} ⏱️  Time"
        echo -e "  ${WHITE}7)${NC} 💰 Currency"
        echo -e "  ${WHITE}0)${NC} Exit\n"
        read -p "Choice: " c
        case $c in
            1) convert_length;; 2) convert_weight;; 3) convert_temp;;
            4) convert_volume;; 5) convert_data;; 6) convert_time;;
            7) currency_convert;; 0) exit 0;;
        esac
    done
}
main_menu
