#!/usr/bin/env python3
"""Sanchala Journal - Personal Journal"""
import sys, os, json
from datetime import datetime

class Journal:
    def __init__(self):
        self.dir = os.path.expanduser("~/.config/sanchala/journal")
        os.makedirs(self.dir, exist_ok=True)
    def add(self, text):
        entry = {'date': datetime.now().isoformat(), 'text': text}
        fname = os.path.join(self.dir, f"{datetime.now().strftime('%Y-%m-%d')}.json")
        entries = []
        if os.path.exists(fname):
            with open(fname) as f: entries = json.load(f)
        entries.append(entry)
        with open(fname, 'w') as f: json.dump(entries, f, indent=2)
    def list_entries(self, date=None):
        if date: fname = os.path.join(self.dir, f"{date}.json")
        else: fname = os.path.join(self.dir, f"{datetime.now().strftime('%Y-%m-%d')}.json")
        if os.path.exists(fname):
            with open(fname) as f: return json.load(f)
        return []

if __name__ == "__main__":
    j = Journal()
    if len(sys.argv) < 2: [print(f"[{e['date']}] {e['text']}") for e in j.list_entries()]
    elif sys.argv[1] == "add" and len(sys.argv)>=3: j.add(' '.join(sys.argv[2:])); print("Added")
    elif sys.argv[1] == "list": [print(f"[{e['date']}] {e['text']}") for e in j.list_entries(sys.argv[2] if len(sys.argv)>2 else None)]
