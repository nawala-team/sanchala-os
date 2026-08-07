#!/usr/bin/env python3
"""Sanchala Network Monitor"""
import sys, os, subprocess

class NetworkMonitor:
    def get_usage(self):
        result = subprocess.run(['vnstat', '-s'], capture_output=True, text=True)
        return result.stdout
    
    def live_monitor(self):
        subprocess.run(['iftop'])
    
    def connections(self):
        result = subprocess.run(['ss', '-tuln'], capture_output=True, text=True)
        return result.stdout
    
    def speed_test(self):
        subprocess.run(['speedtest-cli'])

if __name__ == "__main__":
    nm = NetworkMonitor()
    if len(sys.argv) < 2: print(nm.get_usage())
    elif sys.argv[1] == "live": nm.live_monitor()
    elif sys.argv[1] == "connections": print(nm.connections())
    elif sys.argv[1] == "speed": nm.speed_test()
