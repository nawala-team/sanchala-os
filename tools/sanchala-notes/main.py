#!/usr/bin/env python3
"""Sanchala Notes"""
import sys, os, json
from datetime import datetime

class Notes:
    def __init__(self):
        self.notes_dir = os.path.expanduser("~/.config/sanchala/notes")
        os.makedirs(self.notes_dir, exist_ok=True)
    
    def create(self, title, content=""):
        note = {"title": title, "content": content, "created": datetime.now().isoformat(), "modified": datetime.now().isoformat()}
        filename = f"{datetime.now().strftime('%Y%m%d_%H%M%S')}_{title.replace(' ', '_')}.json"
        with open(os.path.join(self.notes_dir, filename), 'w') as f: json.dump(note, f, indent=2)
        return filename
    
    def list(self):
        notes = []
        for f in os.listdir(self.notes_dir):
            if f.endswith('.json'):
                with open(os.path.join(self.notes_dir, f)) as file:
                    data = json.load(file)
                    notes.append({"file": f, "title": data.get('title', 'Untitled')})
        return notes
    
    def read(self, filename):
        with open(os.path.join(self.notes_dir, filename)) as f: return json.load(f)
    
    def delete(self, filename):
        os.remove(os.path.join(self.notes_dir, filename))

if __name__ == "__main__":
    n = Notes()
    if len(sys.argv) < 2:
        for note in n.list(): print(f"  {note['file']}: {note['title']}")
    elif sys.argv[1] == "new" and len(sys.argv) >= 3: print(f"Created: {n.create(sys.argv[2], ' '.join(sys.argv[3:]) if len(sys.argv) > 3 else '')}")
    elif sys.argv[1] == "read" and len(sys.argv) >= 3: print(json.dumps(n.read(sys.argv[2]), indent=2))
    elif sys.argv[1] == "delete" and len(sys.argv) >= 3: n.delete(sys.argv[2]); print("Deleted")
