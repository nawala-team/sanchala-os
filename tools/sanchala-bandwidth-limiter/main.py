#!/usr/bin/env python3
"""Sanchala Bandwidth Limiter - Network Speed Control"""
import sys, os, subprocess, json

class BandwidthLimiter:
    def __init__(self):
        self.config = os.path.expanduser("~/.config/sanchala/bandwidth.json")
        os.makedirs(os.path.dirname(self.config), exist_ok=True)
    
    def limit_app(self, app, download_kbps, upload_kbps):
        # Using trickle for app-level limiting
        cmd = f"trickle -d {download_kbps} -u {upload_kbps} {app}"
        return cmd
    
    def limit_interface(self, interface, rate):
        # Using tc for interface-level limiting
        cmds = [
            f"sudo tc qdisc del dev {interface} root 2>/dev/null",
            f"sudo tc qdisc add dev {interface} root tbf rate {rate}mbit burst 32kbit latency 400ms"
        ]
        for cmd in cmds:
            subprocess.run(cmd, shell=True)
        return True
    
    def remove_limit(self, interface):
        subprocess.run(f"sudo tc qdisc del dev {interface} root", shell=True)
        return True
    
    def show_status(self, interface):
        result = subprocess.run(f"tc qdisc show dev {interface}", shell=True, capture_output=True, text=True)
        return result.stdout

if __name__ == "__main__":
    bl = BandwidthLimiter()
    if len(sys.argv) < 2:
        print("Sanchala Bandwidth Limiter")
        print("Usage: sanchala-bandwidth-limiter limit INTERFACE RATE_MBPS")
        print("       sanchala-bandwidth-limiter remove INTERFACE")
        print("       sanchala-bandwidth-limiter status INTERFACE")
        print("       sanchala-bandwidth-limiter app 'COMMAND' DOWN_KBPS UP_KBPS")
    elif sys.argv[1] == "limit" and len(sys.argv) >= 4:
        bl.limit_interface(sys.argv[2], sys.argv[3])
        print(f"Limited {sys.argv[2]} to {sys.argv[3]} Mbps")
    elif sys.argv[1] == "remove" and len(sys.argv) >= 3:
        bl.remove_limit(sys.argv[2])
        print(f"Removed limit from {sys.argv[2]}")
    elif sys.argv[1] == "status" and len(sys.argv) >= 3:
        print(bl.show_status(sys.argv[2]))
    elif sys.argv[1] == "app" and len(sys.argv) >= 5:
        cmd = bl.limit_app(sys.argv[2], sys.argv[3], sys.argv[4])
        print(f"Run with: {cmd}")
