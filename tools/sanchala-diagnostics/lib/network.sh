#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0
# Sanchala Diagnostics - Network diagnostics library

cmd_network() {
    print_header "NETWORK INTERFACES"
    ip -c addr show 2>/dev/null || ifconfig 2>/dev/null
    
    print_header "ROUTING TABLE"
    ip route 2>/dev/null | head -10
    
    print_header "DNS SERVERS"
    grep "^nameserver" /etc/resolv.conf 2>/dev/null || resolvectl status 2>/dev/null | grep "DNS Server"
}

cmd_connections() {
    print_header "ACTIVE CONNECTIONS"
    if command -v ss &>/dev/null; then
        ss -tunapw 2>/dev/null | head -30
    else
        netstat -tunapw 2>/dev/null | head -30
    fi
}

cmd_ports() {
    print_header "LISTENING PORTS"
    if command -v ss &>/dev/null; then
        ss -tlnp 2>/dev/null
    else
        netstat -tlnp 2>/dev/null
    fi
}

cmd_ping() {
    local host="${1:-8.8.8.8}"
    local count="${2:-5}"
    print_header "PING TEST - $host"
    ping -c "$count" "$host" 2>/dev/null || print_error "Unable to reach $host"
}

cmd_traceroute() {
    local host="${1:-8.8.8.8}"
    print_header "TRACEROUTE - $host"
    if command -v traceroute &>/dev/null; then
        traceroute -m 15 "$host" 2>/dev/null
    elif command -v mtr &>/dev/null; then
        mtr -r -c 3 "$host" 2>/dev/null
    else
        print_error "traceroute/mtr not found"
    fi
}

cmd_dns() {
    print_header "DNS CONFIGURATION"
    cat /etc/resolv.conf 2>/dev/null
    
    print_header "DNS RESOLUTION TEST"
    for domain in google.com cloudflare.com sanchala.id; do
        local result=$(dig +short "$domain" A 2>/dev/null | head -1)
        if [[ -n "$result" ]]; then
            print_success "$domain → $result"
        else
            print_error "$domain → FAILED"
        fi
    done
}

cmd_bandwidth() {
    print_header "NETWORK BANDWIDTH"
    if command -v vnstat &>/dev/null; then
        vnstat 2>/dev/null
    else
        cat /proc/net/dev 2>/dev/null | awk 'NR>2 {
            iface=$1; gsub(/:/, "", iface)
            rx=$2; tx=$10
            if (rx > 0 || tx > 0) printf "%-12s RX: %10d bytes  TX: %10d bytes\n", iface, rx, tx
        }'
    fi
}

cmd_speed_test() {
    print_header "INTERNET SPEED TEST"
    if command -v speedtest-cli &>/dev/null; then
        speedtest-cli --simple 2>/dev/null
    elif command -v curl &>/dev/null; then
        echo "Download test (10MB file)..."
        local start=$(date +%s.%N)
        curl -so /dev/null http://speedtest.tele2.net/10MB.zip 2>/dev/null
        local end=$(date +%s.%N)
        local time=$(echo "$end - $start" | bc)
        local speed=$(echo "10 / $time" | bc)
        print_metric "Download" "~${speed} MB/s"
    else
        print_error "No speed test tool available"
    fi
}
