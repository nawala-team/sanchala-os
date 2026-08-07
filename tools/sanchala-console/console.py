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
        self.allowed_scripts_dir = self.base_dir / "scripts"
        for d in [self.config_dir, self.history_dir, self.plugins_dir, self.allowed_scripts_dir]:
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
        script_path = Path(script_file).resolve()
        # Security: Only allow scripts from allowed directory
        if not script_path.exists():
            return print(f"❌ File not found: {script_file}")
        
        # Validate script is in allowed directory or is explicitly trusted
        allowed_dir = self.allowed_scripts_dir.resolve()
        try:
            script_path.relative_to(allowed_dir)
        except ValueError:
            return print(f"❌ Security: Script must be in {allowed_dir}")
        
        print(f"▶️  Running: {script_file}")
        # Use compile + exec with restricted globals for safer execution
        with open(script_path) as f:
            script_content = f.read()
        compiled = compile(script_content, script_path, 'exec')
        safe_globals = {"__builtins__": {"print": print, "range": range, "len": len, "str": str, "int": int, "float": float}}
        exec(compiled, safe_globals)
        
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
