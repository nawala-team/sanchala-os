#!/bin/bash
# ============================================
# SANCHALA OS - Game Mode Start Script
# ============================================
# Runs when game mode is activated
# ============================================

# Disable power saving features
if [[ -f /sys/module/snd_hda_intel/parameters/power_save ]]; then
    echo 0 | sudo tee /sys/module/snd_hda_intel/parameters/power_save &>/dev/null || true
fi

# Increase file descriptor limits for the session
ulimit -n 1048576 2>/dev/null || true

# Set swappiness low for gaming
echo 10 | sudo tee /proc/sys/vm/swappiness &>/dev/null || true

# Disable kernel same-page merging
echo 0 | sudo tee /sys/kernel/mm/ksm/run &>/dev/null || true

# Enable transparent huge pages for performance
echo always | sudo tee /sys/kernel/mm/transparent_hugepage/enabled &>/dev/null || true

# Network optimizations
sudo sysctl -w net.core.netdev_budget=600 &>/dev/null || true

# Log
echo "[$(date)] Game mode started" >> /tmp/sanchala-gaming.log
