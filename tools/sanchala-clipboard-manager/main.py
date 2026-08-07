#!/usr/bin/env python3
"""Sanchala Clipboard Manager - Clipboard History"""
import sys, os, json, subprocess
from datetime import datetime

class ClipboardManager:
    def __init__(self):
        self.config_dir = os.path.expanduser("~/.config/sanchala/clipboard")
        self.history_file = os.path.join(self.config_dir, "history.json")
        os.makedirs(self.config_dir, exist_ok=True)
    
    def get_current(self):
        result = subprocess.run(['xclip', '-selection', 'clipboard', '-o'], capture_output=True, text=True)
        return result.stdout
    
    def set_clipboard(self, text):
        p = subprocess.Popen(['xclip', '-selection', 'clipboard'], stdin=subprocess.PIPE)
        p.communicate(text.encode())
    
    def save_to_history(self, text):
        history = self.load_history()
        history.insert(0, {"text": text[:1000], "time": datetime.now().isoformat()})
        history = history[:100]
        with open(self.history_file, 'w') as f: json.dump(history, f)
    
    def load_history(self):
        if os.path.exists(self.history_file):
            with open(self.history_file) as f: return json.load(f)
        return []
    
    def clear_history(self):
        if os.path.exists(self.history_file): os.remove(self.history_file)

if __name__ == "__main__":
    cm = ClipboardManager()
    if len(sys.argv) < 2:
        print("Sanchala Clipboard Manager")
        print("Usage: sanchala-clipboard-manager [get|set TEXT|history|clear|pick N]")
    elif sys.argv[1] == "get": print(cm.get_current())
    elif sys.argv[1] == "set" and len(sys.argv) >= 3: cm.set_clipboard(' '.join(sys.argv[2:])); print("Copied!")
    elif sys.argv[1] == "history":
        for i, h in enumerate(cm.load_history()[:20]): print(f"  {i}: {h['text'][:50]}...")
    elif sys.argv[1] == "clear": cm.clear_history(); print("History cleared")
    elif sys.argv[1] == "pick" and len(sys.argv) >= 3:
        h = cm.load_history()
        idx = int(sys.argv[2])
        if 0 <= idx < len(h): cm.set_clipboard(h[idx]['text']); print("Copied!")
