#!/bin/bash
# Sanchala Expense Tracker - Personal Finance Manager
VERSION="2.0.0"
CONFIG_DIR="$HOME/.config/sanchala/expenses"
EXPENSES_FILE="$CONFIG_DIR/expenses.json"
BUDGET_FILE="$CONFIG_DIR/budget.json"
mkdir -p "$CONFIG_DIR"

CYAN='\033[0;36m' GREEN='\033[0;32m' YELLOW='\033[1;33m'
WHITE='\033[1;37m' RED='\033[0;31m' NC='\033[0m' BOLD='\033[1m'

print_header() {
    clear
    echo -e "${GREEN}╔══════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║${NC}${BOLD}   💰 Sanchala Expense Tracker v$VERSION ${NC}${GREEN}║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════╝${NC}\n"
}

add_expense() {
    print_header
    echo -e "${BOLD}Add Expense${NC}\n"
    read -p "Amount: " amount
    read -p "Category (food/transport/bills/shopping/other): " category
    read -p "Description: " desc
    read -p "Date (YYYY-MM-DD, Enter=today): " date
    date=${date:-$(date +%Y-%m-%d)}
    
    echo "{\"amount\":$amount,\"category\":\"$category\",\"desc\":\"$desc\",\"date\":\"$date\"}" >> "$EXPENSES_FILE"
    echo -e "${GREEN}✓ Expense added${NC}"
    read -p "Press Enter..."
}

add_income() {
    print_header
    echo -e "${BOLD}Add Income${NC}\n"
    read -p "Amount: " amount
    read -p "Source: " source
    read -p "Date (Enter=today): " date
    date=${date:-$(date +%Y-%m-%d)}
    
    echo "{\"amount\":-$amount,\"category\":\"income\",\"desc\":\"$source\",\"date\":\"$date\"}" >> "$EXPENSES_FILE"
    echo -e "${GREEN}✓ Income added${NC}"
    read -p "Press Enter..."
}

view_summary() {
    print_header
    echo -e "${BOLD}Monthly Summary${NC}\n"
    local month=$(date +%Y-%m)
    local total=0 income=0
    
    while read line; do
        [[ "$line" != *"$month"* ]] && continue
        local amt=$(echo "$line" | grep -o '"amount":[0-9.-]*' | cut -d: -f2)
        local cat=$(echo "$line" | grep -o '"category":"[^"]*"' | cut -d'"' -f4)
        if [[ "$cat" == "income" ]]; then
            income=$(echo "$income - $amt" | bc)
        else
            total=$(echo "$total + $amt" | bc)
        fi
    done < "$EXPENSES_FILE" 2>/dev/null
    
    echo -e "${GREEN}Income:${NC}   \$$income"
    echo -e "${RED}Expenses:${NC} \$$total"
    echo -e "${CYAN}Balance:${NC}  \$$(echo "$income - $total" | bc)"
    
    echo -e "\n${BOLD}By Category:${NC}"
    for cat in food transport bills shopping other; do
        local sum=0
        while read line; do
            [[ "$line" != *"$month"* ]] && continue
            [[ "$line" != *"\"$cat\""* ]] && continue
            local amt=$(echo "$line" | grep -o '"amount":[0-9.]*' | cut -d: -f2)
            sum=$(echo "$sum + $amt" | bc)
        done < "$EXPENSES_FILE" 2>/dev/null
        [[ "$sum" != "0" ]] && printf "  ${CYAN}%-12s${NC} \$%s\n" "$cat" "$sum"
    done
    read -p $'\nPress Enter...'
}

list_expenses() {
    print_header
    echo -e "${BOLD}Recent Expenses${NC}\n"
    tail -20 "$EXPENSES_FILE" 2>/dev/null | while read line; do
        local amt=$(echo "$line" | grep -o '"amount":[0-9.-]*' | cut -d: -f2)
        local cat=$(echo "$line" | grep -o '"category":"[^"]*"' | cut -d'"' -f4)
        local desc=$(echo "$line" | grep -o '"desc":"[^"]*"' | cut -d'"' -f4)
        local date=$(echo "$line" | grep -o '"date":"[^"]*"' | cut -d'"' -f4)
        [[ "$cat" == "income" ]] && echo -e "${GREEN}+\$$amt${NC} $desc ($date)" || echo -e "${RED}-\$$amt${NC} $cat: $desc ($date)"
    done
    read -p $'\nPress Enter...'
}

set_budget() {
    print_header
    echo -e "${BOLD}Set Monthly Budget${NC}\n"
    read -p "Total budget: " total
    echo "{\"total\":$total,\"month\":\"$(date +%Y-%m)\"}" > "$BUDGET_FILE"
    echo -e "${GREEN}✓ Budget set${NC}"
    read -p "Press Enter..."
}

main_menu() {
    while true; do
        print_header
        echo -e "  ${WHITE}1)${NC} ➕ Add Expense"
        echo -e "  ${WHITE}2)${NC} 💵 Add Income"
        echo -e "  ${WHITE}3)${NC} 📊 Summary"
        echo -e "  ${WHITE}4)${NC} 📋 List Expenses"
        echo -e "  ${WHITE}5)${NC} 🎯 Set Budget"
        echo -e "  ${WHITE}0)${NC} Exit\n"
        read -p "Choice: " c
        case $c in 1) add_expense;; 2) add_income;; 3) view_summary;; 4) list_expenses;; 5) set_budget;; 0) exit 0;; esac
    done
}
main_menu
