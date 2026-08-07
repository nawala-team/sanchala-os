#!/usr/bin/env python3
"""Sanchala Family Sharing - Family Account Management"""
import sys, os, json

class FamilySharing:
    def __init__(self):
        self.config = os.path.expanduser("~/.config/sanchala/family.json")
        os.makedirs(os.path.dirname(self.config), exist_ok=True)
    
    def load(self):
        if os.path.exists(self.config):
            with open(self.config) as f: return json.load(f)
        return {"members": [], "shared_apps": []}
    
    def save(self, data):
        with open(self.config, 'w') as f: json.dump(data, f, indent=2)
    
    def add_member(self, name, email):
        data = self.load()
        data['members'].append({"name": name, "email": email})
        self.save(data)
    
    def list_members(self):
        return self.load()['members']
    
    def share_app(self, app):
        data = self.load()
        if app not in data['shared_apps']: data['shared_apps'].append(app)
        self.save(data)

if __name__ == "__main__":
    fs = FamilySharing()
    if len(sys.argv) < 2:
        print("Sanchala Family Sharing")
        print("Usage: sanchala-family-sharing [members|add NAME EMAIL|share APP]")
    elif sys.argv[1] == "members": [print(f"  {m['name']} <{m['email']}>") for m in fs.list_members()]
    elif sys.argv[1] == "add" and len(sys.argv) >= 4: fs.add_member(sys.argv[2], sys.argv[3]); print("Added")
    elif sys.argv[1] == "share" and len(sys.argv) >= 3: fs.share_app(sys.argv[2]); print("Shared")
