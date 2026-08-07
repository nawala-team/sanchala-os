#!/usr/bin/env python3
"""Sanchala Feedback"""
import sys, os, json, subprocess
from datetime import datetime

class Feedback:
    def __init__(self):
        self.file = os.path.expanduser("~/.config/sanchala/feedback.json")
        os.makedirs(os.path.dirname(self.file), exist_ok=True)
    
    def submit(self, feedback_type, message):
        data = {"type": feedback_type, "message": message, "date": datetime.now().isoformat(), "system": os.uname().release}
        with open(self.file, 'a') as f: f.write(json.dumps(data) + "\n")
        print("Feedback saved. Thank you!")
    
    def open_github(self):
        subprocess.run(['xdg-open', 'https://github.com/sanchala-os/sanchala/issues'])

if __name__ == "__main__":
    fb = Feedback()
    if len(sys.argv) < 2:
        print("Sanchala Feedback")
        print("Usage: sanchala-feedback [bug|feature|general] MESSAGE")
    elif sys.argv[1] == "github": fb.open_github()
    elif len(sys.argv) >= 3: fb.submit(sys.argv[1], ' '.join(sys.argv[2:]))
