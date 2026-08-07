#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0
# Sanchala Diagnostics - Hardware information library

cmd_hardware() {
    print_header "HARDWARE OVERVIEW"
    
    # System info
    if [[ -f /sys/class/dmi/id/product_name ]]; then
        print_metric "System" "$(cat /sys/class/dmi/id/product_name 2>/dev/null)"
        print_metric "Vendor" "$(cat /sys/class/dmi/id/sys_vendor 2>/dev/null)"
        print_metric "BIOS" "$(cat /sys/class/dmi/id/bios_version 2>/dev/null)"
    fi
    
    # CPU
    print_metric "CPU" "$(grep 'model name' /proc/cpuinfo | head -1 | cut -d':' -f2 | xargs)"
    print_metric "Cores/Threads" "$(nproc) / $(grep -c '^processor' /proc/cpuinfo)"
    
    # Memory
    print_metric "Memory" "$(free -h | awk '/^Mem:/ {print $2}')"
    
    # Graphics
    if command -v lspci &>/dev/null; then
        local gpu=$(lspci 2>/dev/null | grep -i "vga\|3d\|display" | head -1 | cut -d':' -f3 | xargs)
        print_metric "Graphics" "$gpu"
    fi
    
    # Storage
    local total_storage=$(lsblk -b -d -o SIZE 2>/dev/null | tail -n +2 | awk '{sum+=$1} END {printf "%.0f GB", sum/1024/1024/1024}')
    print_metric "Storage" "$total_storage"
}

cmd_pci() {
    print_header "PCI DEVICES"
    if command -v lspci &>/dev/null; then
        lspci -v 2>/dev/null | head -60
    else
        print_error "lspci not found. Install with: sudo pacman -S pciutils"
    fi
}

cmd_usb() {
    print_header "USB DEVICES"
    if command -v lsusb &>/dev/null; then
        lsusb -v 2>/dev/null | grep -E "^Bus|idVendor|idProduct|iProduct|iManufacturer" | head -40
    else
        print_error "lsusb not found. Install with: sudo pacman -S usbutils"
    fi
}

cmd_sensors() {
    print_header "TEMPERATURE & SENSORS"
    if command -v sensors &>/dev/null; then
        sensors 2>/dev/null
    else
        # Fallback to sysfs
        echo "CPU Temperature:"
        for f in /sys/class/thermal/thermal_zone*/temp; do
            [[ -f "$f" ]] && echo "  $(dirname $f | xargs basename): $(awk '{printf "%.1f°C", $1/1000}' "$f")"
        done
        
        echo ""
        echo "Fan speeds:"
        for f in /sys/class/hwmon/hwmon*/fan*_input; do
            [[ -f "$f" ]] && echo "  $(basename $f): $(cat $f) RPM"
        done
    fi
}

cmd_battery() {
    print_header "BATTERY STATUS"
    local bat_path="/sys/class/power_supply/BAT0"
    
    if [[ -d "$bat_path" ]]; then
        print_metric "Status" "$(cat $bat_path/status 2>/dev/null)"
        print_metric "Capacity" "$(cat $bat_path/capacity 2>/dev/null)%"
        print_metric "Technology" "$(cat $bat_path/technology 2>/dev/null)"
        
        local energy_now=$(cat $bat_path/energy_now 2>/dev/null || cat $bat_path/charge_now 2>/dev/null)
        local energy_full=$(cat $bat_path/energy_full 2>/dev/null || cat $bat_path/charge_full 2>/dev/null)
        local energy_design=$(cat $bat_path/energy_full_design 2>/dev/null || cat $bat_path/charge_full_design 2>/dev/null)
        
        if [[ -n "$energy_full" && -n "$energy_design" && "$energy_design" -gt 0 ]]; then
            local health=$(echo "$energy_full $energy_design" | awk '{printf "%.1f", ($1/$2)*100}')
            print_metric "Health" "${health}%"
        fi
        
        # Draw battery bar
        local capacity=$(cat $bat_path/capacity 2>/dev/null || echo 0)
        draw_progress_bar "Battery" "$capacity" 100
    else
        print_info "No battery detected (desktop system)"
    fi
}

cmd_display() {
    print_header "DISPLAY INFORMATION"
    
    if command -v xrandr &>/dev/null && [[ -n "$DISPLAY" ]]; then
        xrandr --query 2>/dev/null | head -20
    else
        # Fallback to DRM info
        for card in /sys/class/drm/card*; do
            [[ -d "$card" ]] || continue
            echo "Card: $(basename $card)"
            [[ -f "$card/device/vendor" ]] && print_metric "  Vendor" "$(cat $card/device/vendor)"
        done
    fi
    
    if command -v lspci &>/dev/null; then
        echo ""
        print_header "GRAPHICS CARDS"
        lspci 2>/dev/null | grep -iE "vga|3d|display"
    fi
}

cmd_audio() {
    print_header "AUDIO DEVICES"
    
    if command -v pactl &>/dev/null; then
        echo "PulseAudio Sinks:"
        pactl list sinks short 2>/dev/null
        echo ""
        echo "PulseAudio Sources:"
        pactl list sources short 2>/dev/null
    elif command -v wpctl &>/dev/null; then
        echo "PipeWire Devices:"
        wpctl status 2>/dev/null | head -30
    fi
    
    echo ""
    print_header "ALSA DEVICES"
    cat /proc/asound/cards 2>/dev/null || aplay -l 2>/dev/null | head -15
}

cmd_logs() {
    local service="${1:-}"
    print_header "SYSTEM LOGS"
    if [[ -n "$service" ]]; then
        journalctl -u "$service" --no-pager -n 50 2>/dev/null || print_error "Service $service not found"
    else
        journalctl --no-pager -n 30 -p err 2>/dev/null || dmesg | tail -30
    fi
}
