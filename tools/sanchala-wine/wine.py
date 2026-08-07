#!/usr/bin/env python3
"""Sanchala Wine - Windows Compatibility Layer Manager"""

import os, sys, json, subprocess
from datetime import datetime
from pathlib import Path

class WineManager:
    def __init__(self):
        self.base_dir = Path(__file__).parent
        self.config_dir = self.base_dir / "config"
        self.prefixes_dir = self.base_dir / "prefixes"
        self.apps_dir = self.base_dir / "apps"
        for d in [self.config_dir, self.prefixes_dir, self.apps_dir]:
            d.mkdir(parents=True, exist_ok=True)
        self.config_file = self.config_dir / "wine.json"
        self.config = self._load()
        
    def _load(self):
        if self.config_file.exists():
            try:
                with open(self.config_file) as f: return json.load(f)
            except: pass
        return {"prefixes": {}, "apps": {}, "default_prefix": "default", "wine_version": "8.0"}
        
    def _save(self):
        with open(self.config_file, 'w') as f: json.dump(self.config, f, indent=2)
            
    def create_prefix(self, name, arch="win64"):
        if name in self.config["prefixes"]: return print(f"❌ Prefix '{name}' exists")
        prefix_dir = self.prefixes_dir / name
        prefix_dir.mkdir(parents=True, exist_ok=True)
        (prefix_dir / "drive_c").mkdir(exist_ok=True)
        
        self.config["prefixes"][name] = {
            "name": name, "arch": arch, "created": datetime.now().isoformat(),
            "path": str(prefix_dir)
        }
        self._save()
        print(f"✅ Created prefix: {name} ({arch})")
        
    def list_prefixes(self):
        print("\n🍷 Wine Prefixes:")
        for name, pf in self.config["prefixes"].items():
            default = "*" if name == self.config["default_prefix"] else " "
            print(f"  [{default}] {name} ({pf['arch']})")
        if not self.config["prefixes"]: print("  No prefixes")
            
    def set_default(self, name):
        if name not in self.config["prefixes"]: return print(f"❌ Prefix not found")
        self.config["default_prefix"] = name
        self._save()
        print(f"✅ Default prefix: {name}")
        
    def install_app(self, name, exe_path):
        self.config["apps"][name] = {
            "name": name, "exe": exe_path, "prefix": self.config["default_prefix"],
            "installed": datetime.now().isoformat()
        }
        self._save()
        print(f"✅ Registered app: {name}")
        
    def run_app(self, name):
        if name not in self.config["apps"]: return print(f"❌ App not found")
        app = self.config["apps"][name]
        print(f"🍷 Running: {name}")
        print(f"   Prefix: {app['prefix']}")
        print(f"   Exe: {app['exe']}")
        # Would use wine to run
        
    def list_apps(self):
        print("\n📦 Wine Apps:")
        for name, app in self.config["apps"].items():
            print(f"  {name} - {app['exe']}")
        if not self.config["apps"]: print("  No apps installed")
            
    def winecfg(self, prefix=None):
        pf = prefix or self.config["default_prefix"]
        print(f"⚙️  Wine configuration for: {pf}")
        
    def status(self):
        print("\n🍷 Wine Status")
        print("=" * 40)
        print(f"  Version: {self.config['wine_version']}")
        print(f"  Default prefix: {self.config['default_prefix']}")
        print(f"  Prefixes: {len(self.config['prefixes'])}")
        print(f"  Apps: {len(self.config['apps'])}")

def main():
    wine = WineManager()
    if len(sys.argv) < 2: return wine.status()
    cmd = sys.argv[1]
    if cmd == "prefix" and len(sys.argv) > 2: wine.create_prefix(sys.argv[2])
    elif cmd == "prefixes": wine.list_prefixes()
    elif cmd == "default" and len(sys.argv) > 2: wine.set_default(sys.argv[2])
    elif cmd == "install" and len(sys.argv) > 3: wine.install_app(sys.argv[2], sys.argv[3])
    elif cmd == "run" and len(sys.argv) > 2: wine.run_app(sys.argv[2])
    elif cmd == "apps": wine.list_apps()
    elif cmd == "cfg": wine.winecfg()
    elif cmd == "status": wine.status()
    else: print("Usage: wine.py [prefix|prefixes|default|install|run|apps|cfg|status] ...")

if __name__ == "__main__": main()
