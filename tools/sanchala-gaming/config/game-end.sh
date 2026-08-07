#!/bin/bash
# ============================================
# SANCHALA OS - Game Mode End Script
# ============================================
# Runs when game mode is deactivated
# ============================================

# Restore power saving
if [[ -f /sys/module/snd_hda_intel/parameters/power_save ]]; then
    echo 1 | sudo tee /sys/module/snd_hda_intel/parameters/power_save &>/dev/null || true
fi

# Restore swappiness
echo 60 | sudo tee /proc/sys/vm/swappiness &>/dev/null || true

# Re-enable KSM
echo 1 | sudo tee /sys/kernel/mm/ksm/run &>/dev/null || true

# Restore THP to madvise
echo madvise | sudo tee /sys/kernel/mm/transparent_hugepage/enabled &>/dev/null || true

# Log
echo "[$(date)] Game mode stopped" >> /tmp/sanchala-gaming.log
