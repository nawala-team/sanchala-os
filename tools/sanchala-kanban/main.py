#!/usr/bin/env python3
"""Sanchala Kanban - Task Board"""
import sys, os, json

class Kanban:
    def __init__(self):
        self.file = os.path.expanduser("~/.config/sanchala/kanban.json")
        os.makedirs(os.path.dirname(self.file), exist_ok=True)
    def load(self):
        if os.path.exists(self.file):
            with open(self.file) as f: return json.load(f)
        return {'todo': [], 'doing': [], 'done': []}
    def save(self, data):
        with open(self.file, 'w') as f: json.dump(data, f, indent=2)
    def add(self, task, col='todo'):
        data = self.load(); data[col].append(task); self.save(data)
    def move(self, task, to_col):
        data = self.load()
        for col in ['todo', 'doing', 'done']:
            if task in data[col]: data[col].remove(task); break
        data[to_col].append(task); self.save(data)
    def show(self):
        data = self.load()
        for col in ['todo', 'doing', 'done']:
            print(f"=== {col.upper()} ===")
            for t in data[col]: print(f"  - {t}")

if __name__ == "__main__":
    kb = Kanban()
    if len(sys.argv) < 2: kb.show()
    elif sys.argv[1] == "add" and len(sys.argv)>=3: kb.add(' '.join(sys.argv[2:])); print("Added")
    elif sys.argv[1] == "move" and len(sys.argv)>=4: kb.move(sys.argv[2], sys.argv[3]); print("Moved")
