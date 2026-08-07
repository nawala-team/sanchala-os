#!/usr/bin/env python3
"""Sanchala Region Settings"""
import sys, os, subprocess

class RegionSettings:
    def get_timezone(self):
        return subprocess.run(['timedatectl', 'show', '-p', 'Timezone', '--value'], capture_output=True, text=True).stdout.strip()
    def set_timezone(self, tz): subprocess.run(['sudo', 'timedatectl', 'set-timezone', tz])
    def list_timezones(self): return subprocess.run(['timedatectl', 'list-timezones'], capture_output=True, text=True).stdout

if __name__ == "__main__":
    rs = RegionSettings()
    if len(sys.argv) < 2: print(f"Timezone: {rs.get_timezone()}")
    elif sys.argv[1] == "set" and len(sys.argv) >= 3: rs.set_timezone(sys.argv[2])
    elif sys.argv[1] == "list": print(rs.list_timezones())
