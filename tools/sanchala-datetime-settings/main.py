#!/usr/bin/env python3
"""Sanchala DateTime Settings - Date & Time Configuration"""
import sys, os, subprocess
from datetime import datetime

class DateTimeSettings:
    def get_current(self):
        return datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    
    def get_timezone(self):
        return subprocess.run(['timedatectl', 'show', '-p', 'Timezone', '--value'], capture_output=True, text=True).stdout.strip()
    
    def set_timezone(self, tz):
        subprocess.run(['sudo', 'timedatectl', 'set-timezone', tz])
    
    def list_timezones(self):
        return subprocess.run(['timedatectl', 'list-timezones'], capture_output=True, text=True).stdout
    
    def set_ntp(self, enabled):
        subprocess.run(['sudo', 'timedatectl', 'set-ntp', 'true' if enabled else 'false'])
    
    def set_time(self, time_str):
        subprocess.run(['sudo', 'timedatectl', 'set-time', time_str])
    
    def status(self):
        return subprocess.run(['timedatectl'], capture_output=True, text=True).stdout

if __name__ == "__main__":
    dt = DateTimeSettings()
    if len(sys.argv) < 2:
        print(dt.status())
    elif sys.argv[1] == "timezone" and len(sys.argv) >= 3: dt.set_timezone(sys.argv[2]); print(f"Set to {sys.argv[2]}")
    elif sys.argv[1] == "timezones": print(dt.list_timezones())
    elif sys.argv[1] == "ntp": dt.set_ntp(sys.argv[2].lower() == 'on' if len(sys.argv) > 2 else True)
    elif sys.argv[1] == "set" and len(sys.argv) >= 3: dt.set_time(sys.argv[2])
