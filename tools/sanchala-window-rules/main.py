#!/usr/bin/env python3
"""Sanchala Window Rules"""
import sys, os, json

class WindowRules:
    def __init__(self):
        self.file = os.path.expanduser('~/.config/sanchala/window-rules.json')
        os.makedirs(os.path.dirname(self.file), exist_ok=True)
    def add(self, app, workspace):
        rules = self.load()
        rules[app] = {'workspace': workspace}
        self.save(rules)
    def load(self):
        if os.path.exists(self.file):
            with open(self.file) as f: return json.load(f)
        return {}
    def save(self, rules):
        with open(self.file, 'w') as f: json.dump(rules, f, indent=2)

if __name__ == "__main__":
    wr = WindowRules()
    if len(sys.argv) < 2: print(wr.load())
    elif sys.argv[1] == "add" and len(sys.argv) >= 4: wr.add(sys.argv[2], sys.argv[3])
