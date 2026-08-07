#!/usr/bin/env python3
"""Sanchala Subscription Manager"""
import sys, os, json

class Subscription:
    def __init__(self):
        self.file = os.path.expanduser("~/.config/sanchala/subscriptions.json")
        os.makedirs(os.path.dirname(self.file), exist_ok=True)
    def add(self, name, price, cycle):
        data = self.load()
        data.append({"name": name, "price": float(price), "cycle": cycle})
        self.save(data)
    def load(self):
        if os.path.exists(self.file):
            with open(self.file) as f: return json.load(f)
        return []
    def save(self, data):
        with open(self.file, 'w') as f: json.dump(data, f, indent=2)
    def summary(self):
        data = self.load()
        monthly = sum(s['price'] for s in data if s['cycle'] == 'monthly')
        yearly = sum(s['price'] for s in data if s['cycle'] == 'yearly')
        return f"Monthly: ${monthly:.2f}\nYearly: ${yearly:.2f}"

if __name__ == "__main__":
    s = Subscription()
    if len(sys.argv) < 2:
        for sub in s.load(): print(f"  {sub['name']}: ${sub['price']}/{sub['cycle']}")
        print(s.summary())
    elif sys.argv[1] == "add" and len(sys.argv) >= 5: s.add(sys.argv[2], sys.argv[3], sys.argv[4])
