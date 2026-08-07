#!/usr/bin/env python3
"""Sanchala Expense Tracker"""
import sys, os, json
from datetime import datetime

class ExpenseTracker:
    def __init__(self):
        self.file = os.path.expanduser("~/.config/sanchala/expenses.json")
        os.makedirs(os.path.dirname(self.file), exist_ok=True)
    
    def load(self):
        if os.path.exists(self.file):
            with open(self.file) as f: return json.load(f)
        return []
    
    def save(self, data):
        with open(self.file, 'w') as f: json.dump(data, f, indent=2)
    
    def add(self, amount, category, desc=""):
        data = self.load()
        data.append({"date": datetime.now().isoformat(), "amount": float(amount), "category": category, "desc": desc})
        self.save(data)
    
    def summary(self):
        data = self.load()
        total = sum(e['amount'] for e in data)
        by_cat = {}
        for e in data:
            by_cat[e['category']] = by_cat.get(e['category'], 0) + e['amount']
        return {"total": total, "by_category": by_cat}

if __name__ == "__main__":
    et = ExpenseTracker()
    if len(sys.argv) < 2:
        s = et.summary()
        print(f"Total: ${s['total']:.2f}")
        for c, a in s['by_category'].items(): print(f"  {c}: ${a:.2f}")
    elif sys.argv[1] == "add" and len(sys.argv) >= 4: et.add(sys.argv[2], sys.argv[3], ' '.join(sys.argv[4:]) if len(sys.argv) > 4 else "")
