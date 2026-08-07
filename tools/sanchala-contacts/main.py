#!/usr/bin/env python3
"""Sanchala Contacts - Contact Manager"""
import sys, os, json

class Contacts:
    def __init__(self):
        self.config_dir = os.path.expanduser("~/.config/sanchala/contacts")
        self.contacts_file = os.path.join(self.config_dir, "contacts.json")
        os.makedirs(self.config_dir, exist_ok=True)
    
    def add(self, name, phone="", email=""):
        contacts = self.load()
        contacts.append({"id": len(contacts)+1, "name": name, "phone": phone, "email": email})
        self.save(contacts)
        return contacts[-1]
    
    def load(self):
        if os.path.exists(self.contacts_file):
            with open(self.contacts_file) as f: return json.load(f)
        return []
    
    def save(self, contacts):
        with open(self.contacts_file, 'w') as f: json.dump(contacts, f, indent=2)
    
    def search(self, query):
        return [c for c in self.load() if query.lower() in c['name'].lower() or query in c.get('phone', '') or query in c.get('email', '')]
    
    def delete(self, id):
        contacts = [c for c in self.load() if c['id'] != id]
        self.save(contacts)

if __name__ == "__main__":
    c = Contacts()
    if len(sys.argv) < 2:
        print("Sanchala Contacts")
        print("Usage: sanchala-contacts [list|add NAME [PHONE] [EMAIL]|search QUERY|delete ID]")
    elif sys.argv[1] == "list":
        for ct in c.load(): print(f"  {ct['id']}: {ct['name']} - {ct.get('phone', '')} - {ct.get('email', '')}")
    elif sys.argv[1] == "add" and len(sys.argv) >= 3:
        ct = c.add(sys.argv[2], sys.argv[3] if len(sys.argv) > 3 else '', sys.argv[4] if len(sys.argv) > 4 else '')
        print(f"Added: {ct['name']}")
    elif sys.argv[1] == "search" and len(sys.argv) >= 3:
        for ct in c.search(sys.argv[2]): print(f"  {ct['name']} - {ct.get('phone', '')}")
    elif sys.argv[1] == "delete" and len(sys.argv) >= 3: c.delete(int(sys.argv[2])); print("Deleted")
