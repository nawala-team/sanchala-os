#!/bin/bash
# ============================================
# SANCHALA Gaming - Core Functions
# ============================================

# Get current GPU info
gpu_info() {
    echo -e "${CYAN}=== GPU Information ===${NC}"
    
    # NVIDIA
    if command -v nvidia-smi &>/dev/null; then
        echo -e "${GREEN}NVIDIA GPU Detected:${NC}"
        nvidia-smi --query-gpu=name,driver_version,memory.total --format=csv,noheader 2>/dev/null || echo "  Unable to query"
    fi
    
    # AMD/Intel via DRM
    if [[ -d /sys/class/drm ]]; then
        for card in /sys/class/drm/card*/device/vendor; do
            [[ -f "$card" ]] || continue
            vendor=$(cat "$card" 2>/dev/null)
            card_path=$(dirname "$card")
            
            case "$vendor" in
                "0x1002")
                    echo -e "${GREEN}AMD GPU Detected:${NC}"
                    [[ -f "$card_path/product_name" ]] && cat "$card_path/product_name"
                    ;;
                "0x8086")
                    echo -e "${GREEN}Intel GPU Detected:${NC}"
                    ;;
            esac
        done
    fi
    
    # Vulkan
    if command -v vulkaninfo &>/dev/null; then
        echo -e "\n${CYAN}Vulkan Devices:${NC}"
        vulkaninfo --summary 2>/dev/null | grep -E "(deviceName|driverVersion)" | head -10 || true
    fi
}

# Start game mode
gamemode_start() {
    log INFO "Starting Game Mode..."
    
    # Start gamemode daemon
    if ! pgrep -x gamemoded &>/dev/null; then
        gamemoded -d 2>/dev/null &
        sleep 1
    fi
    
    # CPU governor to performance
    if [[ -w /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor ]]; then
        for gov in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
            echo "performance" | sudo tee "$gov" &>/dev/null || true
        done
        log INFO "CPU governor set to performance"
    fi
    
    # Suspend KDE compositor
    command -v qdbus &>/dev/null && qdbus org.kde.KWin /Compositor suspend 2>/dev/null || true
    
    # AMD GPU high performance
    for card in /sys/class/drm/card*/device/power_dpm_force_performance_level; do
        [[ -w "$card" ]] && echo "high" | sudo tee "$card" &>/dev/null || true
    done
    
    # NVIDIA performance mode
    command -v nvidia-settings &>/dev/null && nvidia-settings -a "[gpu:0]/GpuPowerMizerMode=1" &>/dev/null || true
    
    # Stop indexers
    systemctl --user stop tracker-miner-fs-3.service baloo.service 2>/dev/null || true
    
    # Inhibit screensaver
    command -v xdg-screensaver &>/dev/null && xdg-screensaver suspend "$$" &>/dev/null || true
    
    log INFO "Game Mode activated!"
    echo -e "${GREEN}🎮 Game Mode is now ACTIVE${NC}"
    
    [[ -x "/usr/share/sanchala-gaming/scripts/game-start.sh" ]] && /usr/share/sanchala-gaming/scripts/game-start.sh
}

# Stop game mode
gamemode_stop() {
    log INFO "Stopping Game Mode..."
    
    # Restore CPU governor
    for gov in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
        [[ -w "$gov" ]] && echo "schedutil" | sudo tee "$gov" &>/dev/null || true
    done
    
    # Resume compositor
    command -v qdbus &>/dev/null && qdbus org.kde.KWin /Compositor resume 2>/dev/null || true
    
    # Reset GPU power
    for card in /sys/class/drm/card*/device/power_dpm_force_performance_level; do
        [[ -w "$card" ]] && echo "auto" | sudo tee "$card" &>/dev/null || true
    done
    
    command -v nvidia-settings &>/dev/null && nvidia-settings -a "[gpu:0]/GpuPowerMizerMode=0" &>/dev/null || true
    
    # Restart indexers
    systemctl --user start tracker-miner-fs-3.service baloo.service 2>/dev/null || true
    
    log INFO "Game Mode deactivated"
    echo -e "${YELLOW}🎮 Game Mode is now INACTIVE${NC}"
    
    [[ -x "/usr/share/sanchala-gaming/scripts/game-end.sh" ]] && /usr/share/sanchala-gaming/scripts/game-end.sh
}

# Game mode status
gamemode_status() {
    echo -e "${CYAN}=== Game Mode Status ===${NC}"
    
    # Daemon
    if pgrep -x gamemoded &>/dev/null; then
        echo -e "GameMode Daemon: ${GREEN}Running${NC}"
        command -v gamemoded &>/dev/null && gamemoded -s 2>/dev/null || true
    else
        echo -e "GameMode Daemon: ${YELLOW}Not Running${NC}"
    fi
    
    # CPU Governor
    if [[ -f /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor ]]; then
        gov=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)
        [[ "$gov" == "performance" ]] && echo -e "CPU Governor: ${GREEN}$gov${NC}" || echo -e "CPU Governor: ${YELLOW}$gov${NC}"
    fi
    
    # GPU Level
    for card in /sys/class/drm/card*/device/power_dpm_force_performance_level; do
        [[ -f "$card" ]] && echo -e "GPU Performance: ${CYAN}$(cat "$card")${NC}" && break
    done
    
    # Compositor
    if command -v qdbus &>/dev/null; then
        comp=$(qdbus org.kde.KWin /Compositor active 2>/dev/null || echo "unknown")
        [[ "$comp" == "true" ]] && echo -e "Compositor: ${GREEN}Active${NC}" || echo -e "Compositor: ${YELLOW}Suspended${NC}"
    fi
}
