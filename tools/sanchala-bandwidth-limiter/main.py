#!/usr/bin/env python3
"""Sanchala Bandwidth Limiter - Network Speed Control"""
import sys, os, subprocess, json, re

class BandwidthLimiter:
    def __init__(self):
        self.config = os.path.expanduser("~/.config/sanchala/bandwidth.json")
        os.makedirs(os.path.dirname(self.config), exist_ok=True)
    
    def _validate_interface(self, interface):
        """Validate network interface name"""
        return bool(re.match(r'^[a-zA-Z0-9_-]+
, interface)) and len(interface) <= 15
    
    def _validate_rate(self, rate):
        """Validate rate is numeric"""
        try:
            return float(rate) > 0
        except:
            return False
    
    def limit_app(self, app, download_kbps, upload_kbps):
        # Using trickle for app-level limiting
        if not self._validate_rate(download_kbps) or not self._validate_rate(upload_kbps):
            return None
        cmd = f"trickle -d {download_kbps} -u {upload_kbps} {app}"
        return cmd
    
    def limit_interface(self, interface, rate):
        if not self._validate_interface(interface) or not self._validate_rate(rate):
            print("Invalid interface or rate")
            return False
        # Remove existing qdisc first
        subprocess.run(['sudo', 'tc', 'qdisc', 'del', 'dev', interface, 'root'], 
                      stderr=subprocess.DEVNULL)
        # Add new rate limit
        result = subprocess.run(['sudo', 'tc', 'qdisc', 'add', 'dev', interface, 'root', 
                                'tbf', 'rate', f'{rate}mbit', 'burst', '32kbit', 'latency', '400ms'])
        return result.returncode == 0
    
    def remove_limit(self, interface):
        if not self._validate_interface(interface):
            return False
        subprocess.run(['sudo', 'tc', 'qdisc', 'del', 'dev', interface, 'root'],
                      stderr=subprocess.DEVNULL)
        return True
    
    def show_status(self, interface):
        if not self._validate_interface(interface):
            return "Invalid interface"
        result = subprocess.run(['tc', 'qdisc', 'show', 'dev', interface], 
                               capture_output=True, text=True)
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
        if bl.limit_interface(sys.argv[2], sys.argv[3]):
            print(f"Limited {sys.argv[2]} to {sys.argv[3]} Mbps")
        else:
            print("Failed to apply limit")
    elif sys.argv[1] == "remove" and len(sys.argv) >= 3:
        bl.remove_limit(sys.argv[2])
        print(f"Removed limit from {sys.argv[2]}")
    elif sys.argv[1] == "status" and len(sys.argv) >= 3:
        print(bl.show_status(sys.argv[2]))
    elif sys.argv[1] == "app" and len(sys.argv) >= 5:
        cmd = bl.limit_app(sys.argv[2], sys.argv[3], sys.argv[4])
        if cmd:
            print(f"Run with: {cmd}")
        else:
            print("Invalid parameters")
