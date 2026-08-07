#!/bin/bash
# ============================================
# SANCHALA Gaming - Controller & Help Functions
# ============================================

# Controller status
controller_status() {
    echo -e "${CYAN}=== Controller Configuration ===${NC}"
    
    echo -e "\n${GREEN}Connected Controllers:${NC}"
    for js in /dev/input/js*; do
        if [[ -e "$js" ]]; then
            name=$(cat "/sys/class/input/$(basename "$js")/device/name" 2>/dev/null || echo "Unknown")
            echo "  $js: $name"
        fi
    done
    
    pgrep -x steam &>/dev/null && echo -e "\n${GREEN}Steam Input:${NC} Available"
    
    echo -e "\n${GREEN}Controller Drivers:${NC}"
    lsmod | grep -q xpadneo && echo "  ✓ xpadneo (Xbox Wireless)"
    lsmod | grep -q hid_nintendo && echo "  ✓ hid-nintendo (Switch Pro/Joy-Con)"
    lsmod | grep -q hid_playstation && echo "  ✓ hid-playstation (DualSense)"
    
    [[ -f /usr/lib/udev/rules.d/60-steam-input.rules ]] && echo -e "\n${GREEN}Steam udev rules:${NC} Installed"
}

# Overlay help
overlay_help() {
    cat << 'EOF'
=== MangoHud Configuration ===

Launch with overlay:
  MANGOHUD=1 game_command
  mangohud game_command

Config: ~/.config/MangoHud/MangoHud.conf

Presets:
  MANGOHUD_CONFIG=preset=0  # FPS only
  MANGOHUD_CONFIG=preset=2  # Default
  MANGOHUD_CONFIG=preset=4  # Detailed

Toggle: Right Shift + F12

=== VkBasalt Configuration ===

Launch: ENABLE_VKBASALT=1 game_command
Config: ~/.config/vkBasalt/vkBasalt.conf

Effects: cas, fxaa, smaa, lut
EOF
}

# Main help
show_help() {
    cat << EOF
${CYAN}SANCHALA Gaming Manager v${VERSION}${NC}

Usage: sanchala-gaming <command> [options]

${GREEN}Game Mode:${NC}
  start              Start game mode
  stop               Stop game mode
  status             Show status
  toggle             Toggle on/off

${GREEN}Launch:${NC}
  launch <cmd>       Launch with optimizations
  gamescope <w> <h> <cmd>  Launch with Gamescope

${GREEN}Proton/Wine:${NC}
  proton-config <appid>    Configure Proton prefix
  proton-ge                Install Proton-GE
  wine-prefix <name>       Create Wine prefix

${GREEN}Config:${NC}
  controllers        Show controller info
  gpu                Show GPU info
  steam-optimize     Optimize Steam
  overlay            Performance overlay help

${GREEN}Examples:${NC}
  sanchala-gaming start
  MANGOHUD=1 sanchala-gaming launch game
  sanchala-gaming proton-config 1234567

EOF
}
