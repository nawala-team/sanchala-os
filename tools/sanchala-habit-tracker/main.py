#!/usr/bin/env python3
"""Sanchala Habit Tracker - Daily Habits"""
import sys, os, json
from datetime import datetime, date

class HabitTracker:
    def __init__(self):
        self.config_dir = os.path.expanduser("~/.config/sanchala/habits")
        self.habits_file = os.path.join(self.config_dir, "habits.json")
        os.makedirs(self.config_dir, exist_ok=True)
    
    def load(self):
        if os.path.exists(self.habits_file):
            with open(self.habits_file) as f: return json.load(f)
        return {'habits': [], 'log': {}}
    
    def save(self, data):
        with open(self.habits_file, 'w') as f: json.dump(data, f, indent=2)
    
    def add_habit(self, name):
        data = self.load()
        data['habits'].append({'name': name, 'created': str(date.today())})
        self.save(data)
    
    def log_habit(self, name):
        data = self.load()
        today = str(date.today())
        if today not in data['log']: data['log'][today] = []
        if name not in data['log'][today]: data['log'][today].append(name)
        self.save(data)
    
    def status(self):
        data = self.load()
        today = str(date.today())
        done = data['log'].get(today, [])
        return [(h['name'], h['name'] in done) for h in data['habits']]

if __name__ == "__main__":
    ht = HabitTracker()
    if len(sys.argv) < 2:
        for name, done in ht.status(): print(f"  {'[x]' if done else '[ ]'} {name}")
    elif sys.argv[1] == "add" and len(sys.argv) >= 3: ht.add_habit(sys.argv[2]); print("Added")
    elif sys.argv[1] == "done" and len(sys.argv) >= 3: ht.log_habit(sys.argv[2]); print("Logged!")
