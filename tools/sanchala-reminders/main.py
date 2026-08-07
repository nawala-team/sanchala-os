#!/usr/bin/env python3
"""Sanchala Reminders"""
import sys, os, json
from datetime import datetime

class Reminders:
    def __init__(self):
        self.file = os.path.expanduser("~/.config/sanchala/reminders.json")
        os.makedirs(os.path.dirname(self.file), exist_ok=True)
    def add(self, text, time):
        data = self.load()
        data.append({"text": text, "time": time, "created": datetime.now().isoformat()})
        self.save(data)
    def load(self):
        if os.path.exists(self.file):
            with open(self.file) as f: return json.load(f)
        return []
    def save(self, data):
        with open(self.file, 'w') as f: json.dump(data, f, indent=2)
    def list(self): return self.load()

if __name__ == "__main__":
    r = Reminders()
    if len(sys.argv) < 2:
        for rem in r.list(): print(f"  {rem['time']}: {rem['text']}")
    elif sys.argv[1] == "add" and len(sys.argv) >= 4: r.add(sys.argv[2], sys.argv[3])
