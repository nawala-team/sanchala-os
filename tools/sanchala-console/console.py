#!/usr/bin/env python3
"""Sanchala Console - Advanced Developer Console"""

import os, sys, json, code, readline
from datetime import datetime
from pathlib import Path

class DevConsole:
    def __init__(self):
        self.base_dir = Path(__file__).parent
        self.config_dir = self.base_dir / "config"
        self.history_dir = self.base_dir / "history"
        self.plugins_dir = self.base_dir / "plugins"
        for d in [self.config_dir, self.history_dir, self.plugins_dir]:
            d.mkdir(parents=True, exist_ok=True)
        self.history_file = self.history_dir / "console_history"
        self.config = self._load_config()
        
    def _load_config(self):
        cf = self.config_dir / "console.json"
        default = {"prompt": ">>> ", "history_size": 1000, "auto_indent": True,
                   "syntax_highlight": True, "plugins": []}
        if cf.exists():
            try:
                with open(cf) as f: return {**default, **json.load(f)}
            except: pass
        return default
        
    def _load_history(self):
        if self.history_file.exists():
            try: readline.read_history_file(str(self.history_file))
            except: pass
            
    def _save_history(self):
        readline.set_history_length(self.config["history_size"])
        readline.write_history_file(str(self.history_file))
        
    def interactive(self):
        self._load_history()
        print("🖥️  Sanchala Developer Console")
        print("   Type 'help()' for commands, 'exit()' to quit\n")
        
        local_vars = {
            "os": os, "sys": sys, "json": json, "Path": Path,
            "datetime": datetime, "console": self
        }
        
        try:
            code.interact(local=local_vars, banner="", exitmsg="Goodbye!")
        finally:
            self._save_history()
            
    def run_script(self, script_file):
        if not Path(script_file).exists():
            return print(f"❌ File not found: {script_file}")
        print(f"▶️  Running: {script_file}")
        exec(open(script_file).read())
        
    def clear_history(self):
        if self.history_file.exists():
            self.history_file.unlink()
        readline.clear_history()
        print("✅ History cleared")
        
    def show_history(self, count=20):
        print(f"\n📜 Last {count} commands:")
        length = readline.get_current_history_length()
        start = max(1, length - count + 1)
        for i in range(start, length + 1):
            item = readline.get_history_item(i)
            if item: print(f"  {i}: {item}")

def main():
    console = DevConsole()
    if len(sys.argv) < 2: return console.interactive()
    cmd = sys.argv[1]
    if cmd == "run" and len(sys.argv) > 2: console.run_script(sys.argv[2])
    elif cmd == "history": console.show_history(int(sys.argv[2]) if len(sys.argv) > 2 else 20)
    elif cmd == "clear-history": console.clear_history()
    else: print("Usage: console.py [run <script>|history|clear-history]")

if __name__ == "__main__": main()
