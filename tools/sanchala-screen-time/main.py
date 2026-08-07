#!/usr/bin/env python3
"""Sanchala Screen Time"""
import sys, os, json
from datetime import datetime, timedelta

class ScreenTime:
    def __init__(self):
        self.file = os.path.expanduser("~/.config/sanchala/screentime.json")
        os.makedirs(os.path.dirname(self.file), exist_ok=True)
    def log_session(self, minutes):
        data = self.load()
        today = datetime.now().strftime('%Y-%m-%d')
        data[today] = data.get(today, 0) + minutes
        self.save(data)
    def load(self):
        if os.path.exists(self.file):
            with open(self.file) as f: return json.load(f)
        return {}
    def save(self, data):
        with open(self.file, 'w') as f: json.dump(data, f)
    def report(self):
        data = self.load()
        for day, mins in sorted(data.items())[-7:]: print(f"{day}: {mins//60}h {mins%60}m")

if __name__ == "__main__":
    st = ScreenTime()
    if len(sys.argv) < 2: st.report()
    elif sys.argv[1] == "log" and len(sys.argv) >= 3: st.log_session(int(sys.argv[2]))
