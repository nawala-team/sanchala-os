# ============================================
# SANCHALA OS - Proton/Wine Default Settings
# ============================================
# Applied via environment variables
# Source: /etc/profile.d/sanchala-gaming.sh
# ============================================

# Enable FSync (better than ESync, requires kernel support)
export PROTON_NO_FSYNC=0

# Enable ESync as fallback
export PROTON_NO_ESYNC=0

# DXVK async shader compilation (reduces stuttering)
export DXVK_ASYNC=1

# DXVK state cache
export DXVK_STATE_CACHE_PATH="${XDG_CACHE_HOME:-$HOME/.cache}/dxvk"

# VKD3D (DX12) shader cache
export VKD3D_SHADER_CACHE_PATH="${XDG_CACHE_HOME:-$HOME/.cache}/vkd3d-proton"

# Mesa shader cache
export MESA_SHADER_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/mesa_shader_cache"

# NVIDIA shader cache
export __GL_SHADER_DISK_CACHE_PATH="${XDG_CACHE_HOME:-$HOME/.cache}/nvidia/GLCache"

# Enable FSR by default (can be overridden per-game)
# export WINE_FULLSCREEN_FSR=1
# export WINE_FULLSCREEN_FSR_STRENGTH=2

# Enable NVIDIA features (DLSS, etc.)
export PROTON_ENABLE_NVAPI=1
export PROTON_HIDE_NVIDIA_GPU=0

# Wine debugging (0 = off for performance)
export WINEDEBUG=-all

# Disable Proton logging by default (enable per-game if needed)
export PROTON_LOG=0

# Large Address Aware (for 32-bit games)
export WINE_LARGE_ADDRESS_AWARE=1

# Use native file dialogs
export PROTON_USE_NATIVE_FILE_DIALOGS=1
