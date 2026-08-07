#!/bin/bash
# ============================================
# SANCHALA Gaming - Launch Functions
# ============================================

# Launch game with optimizations
game_launch() {
    local game_cmd="$*"
    
    if [[ -z "$game_cmd" ]]; then
        log ERROR "No game command specified"
        echo "Usage: sanchala-gaming launch <game_command>"
        exit 1
    fi
    
    log INFO "Launching game: $game_cmd"
    
    local launch_cmd=""
    
    # Add gamemode
    command -v gamemoderun &>/dev/null && launch_cmd="gamemoderun"
    
    # Add MangoHud
    [[ "${MANGOHUD:-0}" == "1" ]] && command -v mangohud &>/dev/null && launch_cmd="$launch_cmd mangohud"
    
    if [[ -n "$launch_cmd" ]]; then
        exec $launch_cmd $game_cmd
    else
        exec $game_cmd
    fi
}

# Launch with Gamescope
launch_gamescope() {
    local width="${1:-1920}"
    local height="${2:-1080}"
    shift 2 || true
    local game_cmd="$*"
    
    if ! command -v gamescope &>/dev/null; then
        log ERROR "Gamescope not installed"
        exit 1
    fi
    
    log INFO "Launching with Gamescope: ${width}x${height}"
    
    exec gamescope -w "$width" -h "$height" -W "$width" -H "$height" \
        -f --adaptive-sync --expose-wayland -- gamemoderun $game_cmd
}

# Configure Proton for a game
proton_configure() {
    local steam_appid="$1"
    
    if [[ -z "$steam_appid" ]]; then
        echo "Usage: sanchala-gaming proton-config <steam_appid>"
        exit 1
    fi
    
    local prefix_path="$HOME/.local/share/Steam/steamapps/compatdata/$steam_appid/pfx"
    
    if [[ ! -d "$prefix_path" ]]; then
        log ERROR "Proton prefix not found for AppID: $steam_appid"
        log INFO "Launch the game at least once first"
        exit 1
    fi
    
    echo -e "${CYAN}=== Proton Configuration for AppID: $steam_appid ===${NC}"
    echo "Prefix: $prefix_path"
    
    if command -v protontricks &>/dev/null; then
        protontricks "$steam_appid"
    else
        log WARN "Install protontricks: sudo pacman -S protontricks"
    fi
}

# Install Proton-GE
proton_ge_install() {
    log INFO "Installing/Updating Proton-GE..."
    
    if command -v protonup-qt &>/dev/null; then
        protonup-qt
        return
    fi
    
    local install_dir="$HOME/.local/share/Steam/compatibilitytools.d"
    mkdir -p "$install_dir"
    
    local latest_url=$(curl -s https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest | \
        grep "browser_download_url.*tar.gz" | cut -d '"' -f 4 | head -1)
    
    if [[ -n "$latest_url" ]]; then
        local filename=$(basename "$latest_url")
        log INFO "Downloading: $filename"
        
        curl -L "$latest_url" -o "/tmp/$filename"
        tar -xzf "/tmp/$filename" -C "$install_dir"
        rm "/tmp/$filename"
        
        log INFO "Proton-GE installed. Restart Steam to use it."
    else
        log ERROR "Could not fetch latest Proton-GE release"
        exit 1
    fi
}

# Create Wine prefix
wine_create_prefix() {
    local prefix_name="${1:-default}"
    local arch="${2:-win64}"
    local prefix_path="$HOME/.wine_prefixes/$prefix_name"
    
    log INFO "Creating Wine prefix: $prefix_path (arch: $arch)"
    
    mkdir -p "$prefix_path"
    export WINEPREFIX="$prefix_path"
    export WINEARCH="$arch"
    
    wineboot --init
    
    if command -v winetricks &>/dev/null; then
        echo -e "${CYAN}Installing common components...${NC}"
        winetricks -q vcrun2019 dxvk corefonts
    fi
    
    log INFO "Wine prefix created: $prefix_path"
    echo -e "${GREEN}Wine prefix ready at: $prefix_path${NC}"
}

# Steam optimization
steam_optimize() {
    local steam_dir="$HOME/.local/share/Steam"
    
    [[ ! -d "$steam_dir" ]] && { log ERROR "Steam not installed"; exit 1; }
    
    echo -e "${CYAN}=== Steam Optimization ===${NC}"
    
    mkdir -p "$HOME/.cache/mesa_shader_cache" "$HOME/.cache/nvidia/GLCache"
    
    cat > "$USER_CONFIG_DIR/steam-env.conf" << 'EOF'
# Steam Environment Variables
export STEAM_RUNTIME_PREFER_HOST_LIBRARIES=0
export PROTON_ENABLE_NVAPI=1
export DXVK_ASYNC=1
export VKD3D_SHADER_CACHE_PATH="$HOME/.cache/vkd3d-proton"
export WINE_FULLSCREEN_FSR=1
export WINE_FULLSCREEN_FSR_STRENGTH=2
export PROTON_NO_ESYNC=0
export PROTON_NO_FSYNC=0
EOF
    
    log INFO "Steam environment saved to: $USER_CONFIG_DIR/steam-env.conf"
    echo -e "${GREEN}✓ Steam optimized${NC}"
}
