#!/usr/bin/env python3
"""Sanchala Tracker Blocker"""
import sys, os, subprocess

class TrackerBlocker:
    def enable(self):
        # Add tracker blocking hosts
        subprocess.run(['sudo', 'sh', '-c', 'curl -s https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts >> /etc/hosts'])
    def disable(self):
        subprocess.run(['sudo', 'sh', '-c', 'head -n 10 /etc/hosts > /etc/hosts.tmp && mv /etc/hosts.tmp /etc/hosts'])
    def status(self):
        r = subprocess.run(['wc', '-l', '/etc/hosts'], capture_output=True, text=True)
        return f"Hosts entries: {r.stdout.strip()}"

if __name__ == "__main__":
    tb = TrackerBlocker()
    if len(sys.argv) < 2: print(tb.status())
    elif sys.argv[1] == "enable": tb.enable()
    elif sys.argv[1] == "disable": tb.disable()
