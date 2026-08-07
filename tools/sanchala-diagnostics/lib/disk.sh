#!/bin/bash
# Sanchala Disk Diagnostics

check_disk_health() {
    echo "=== Disk Health ==="
    for dev in /dev/sd? /dev/nvme?n?; do
        [ -b "$dev" ] || continue
        echo "Device: $dev"
        sudo smartctl -H "$dev" 2>/dev/null | grep -i "health\|result"
    done
}

check_disk_usage() {
    echo "=== Disk Usage ==="
    df -h | grep -E '^/dev'
}

check_io_stats() {
    echo "=== I/O Stats ==="
    iostat -x 1 3 2>/dev/null || echo "iostat not available"
}

case "$1" in
    health) check_disk_health ;;
    usage) check_disk_usage ;;
    io) check_io_stats ;;
    *) check_disk_usage ;;
esac
