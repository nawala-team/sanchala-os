#!/usr/bin/env python3
"""Sanchala Env Editor - Environment Variables Manager"""

import os, sys, json, shutil
from datetime import datetime
from pathlib import Path

class EnvEditor:
    def __init__(self):
        self.base_dir = Path(__file__).parent
        self.config_dir = self.base_dir / "config"
        self.backups_dir = self.base_dir / "backups"
        self.profiles_dir = self.base_dir / "profiles"
        for d in [self.config_dir, self.backups_dir, self.profiles_dir]:
            d.mkdir(parents=True, exist_ok=True)
        self.config_file = self.config_dir / "env.json"
        self.config = self._load()
        
    def _load(self):
        if self.config_file.exists():
            try:
                with open(self.config_file) as f: return json.load(f)
            except: pass
        return {"custom_vars": {}, "profiles": {}, "active_profile": None}
        
    def _save(self):
        with open(self.config_file, 'w') as f: json.dump(self.config, f, indent=2)
            
    def show(self, filter_str=None):
        print("\n🌍 Environment Variables:")
        print("=" * 60)
        for key, val in sorted(os.environ.items()):
            if filter_str and filter_str.lower() not in key.lower(): continue
            val_display = val[:50] + "..." if len(val) > 50 else val
            print(f"  {key}={val_display}")
            
    def get(self, name):
        val = os.environ.get(name) or self.config["custom_vars"].get(name)
        if val:
            print(f"{name}={val}")
        else:
            print(f"❌ Variable not found: {name}")
            
    def set(self, name, value):
        os.environ[name] = value
        self.config["custom_vars"][name] = value
        self._save()
        print(f"✅ Set: {name}={value}")
        
    def unset(self, name):
        if name in os.environ: del os.environ[name]
        if name in self.config["custom_vars"]: del self.config["custom_vars"][name]
        self._save()
        print(f"✅ Unset: {name}")
        
    def export(self, output_file=None):
        if output_file:
            out = Path(output_file)
        else:
            out = self.backups_dir / f"env-{datetime.now().strftime('%Y%m%d-%H%M%S')}.sh"
        with open(out, 'w') as f:
            f.write("#!/bin/bash\n# Exported environment\n")
            for key, val in sorted(os.environ.items()):
                val_escaped = val.replace("'", "'\\''")
                f.write(f"export {key}='{val_escaped}'\n")
        print(f"✅ Exported to: {out}")
        
    def create_profile(self, name):
        self.config["profiles"][name] = {
            "name": name, "vars": dict(self.config["custom_vars"]),
            "created": datetime.now().isoformat()
        }
        self._save()
        print(f"✅ Created profile: {name}")
        
    def load_profile(self, name):
        if name not in self.config["profiles"]: return print(f"❌ Profile not found")
        profile = self.config["profiles"][name]
        for key, val in profile["vars"].items():
            os.environ[key] = val
        self.config["active_profile"] = name
        self._save()
        print(f"✅ Loaded profile: {name}")
        
    def list_profiles(self):
        print("\n📋 Environment Profiles:")
        for name, profile in self.config["profiles"].items():
            active = "*" if name == self.config["active_profile"] else " "
            print(f"  [{active}] {name} ({len(profile['vars'])} vars)")
        if not self.config["profiles"]: print("  No profiles")
            
    def edit_file(self, filepath):
        path = Path(filepath)
        if not path.exists(): return print(f"❌ File not found")
        editor = os.environ.get("EDITOR", "nano")
        os.system(f"{editor} {path}")
        
    def path_show(self):
        print("\n📂 PATH entries:")
        for i, p in enumerate(os.environ.get("PATH", "").split(":"), 1):
            exists = "✓" if Path(p).exists() else "✗"
            print(f"  {i:2}. [{exists}] {p}")
            
    def path_add(self, directory, prepend=False):
        path = os.environ.get("PATH", "")
        if prepend:
            os.environ["PATH"] = f"{directory}:{path}"
        else:
            os.environ["PATH"] = f"{path}:{directory}"
        print(f"✅ Added to PATH: {directory}")

def main():
    env = EnvEditor()
    if len(sys.argv) < 2: return env.show()
    cmd = sys.argv[1]
    if cmd == "show": env.show(sys.argv[2] if len(sys.argv) > 2 else None)
    elif cmd == "get" and len(sys.argv) > 2: env.get(sys.argv[2])
    elif cmd == "set" and len(sys.argv) > 3: env.set(sys.argv[2], sys.argv[3])
    elif cmd == "unset" and len(sys.argv) > 2: env.unset(sys.argv[2])
    elif cmd == "export": env.export(sys.argv[2] if len(sys.argv) > 2 else None)
    elif cmd == "profile" and len(sys.argv) > 2: env.create_profile(sys.argv[2])
    elif cmd == "load" and len(sys.argv) > 2: env.load_profile(sys.argv[2])
    elif cmd == "profiles": env.list_profiles()
    elif cmd == "path": env.path_show()
    elif cmd == "path-add" and len(sys.argv) > 2: env.path_add(sys.argv[2], "--prepend" in sys.argv)
    else: print("Usage: env-editor.py [show|get|set|unset|export|profile|load|profiles|path|path-add]")

if __name__ == "__main__": main()
