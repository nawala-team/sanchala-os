#!/usr/bin/env python3
"""Sanchala SDK - Software Development Kit Manager"""

import os, sys, json, subprocess
from datetime import datetime
from pathlib import Path

class SDKManager:
    def __init__(self):
        self.base_dir = Path(__file__).parent
        self.config_dir = self.base_dir / "config"
        self.sdks_dir = self.base_dir / "sdks"
        self.cache_dir = self.base_dir / "cache"
        for d in [self.config_dir, self.sdks_dir, self.cache_dir]:
            d.mkdir(parents=True, exist_ok=True)
        self.config_file = self.config_dir / "sdk.json"
        self.config = self._load()
        
    def _load(self):
        if self.config_file.exists():
            try:
                with open(self.config_file) as f: return json.load(f)
            except: pass
        return {"installed": {}, "active": {}}
        
    def _save(self):
        with open(self.config_file, 'w') as f: json.dump(self.config, f, indent=2)
        
    def available(self):
        print("\n📦 Available SDKs:")
        sdks = {
            "python": ["3.9", "3.10", "3.11", "3.12"],
            "node": ["16", "18", "20", "21"],
            "java": ["11", "17", "21"],
            "go": ["1.20", "1.21", "1.22"],
            "rust": ["stable", "nightly"],
            "ruby": ["3.1", "3.2", "3.3"],
            "php": ["8.1", "8.2", "8.3"]
        }
        for sdk, versions in sdks.items():
            installed = self.config["installed"].get(sdk, [])
            active = self.config["active"].get(sdk, "")
            print(f"\n  {sdk}:")
            for v in versions:
                mark = "✓" if v in installed else " "
                act = "*" if v == active else " "
                print(f"    [{mark}]{act} {v}")
                
    def install(self, sdk, version):
        if sdk not in self.config["installed"]:
            self.config["installed"][sdk] = []
        if version in self.config["installed"][sdk]:
            return print(f"✅ {sdk} {version} already installed")
        self.config["installed"][sdk].append(version)
        if sdk not in self.config["active"]:
            self.config["active"][sdk] = version
        self._save()
        print(f"✅ Installed {sdk} {version}")
        
    def uninstall(self, sdk, version):
        if sdk not in self.config["installed"] or version not in self.config["installed"][sdk]:
            return print(f"❌ {sdk} {version} not installed")
        self.config["installed"][sdk].remove(version)
        if self.config["active"].get(sdk) == version:
            self.config["active"][sdk] = self.config["installed"][sdk][0] if self.config["installed"][sdk] else ""
        self._save()
        print(f"🗑️  Uninstalled {sdk} {version}")
        
    def use(self, sdk, version):
        if sdk not in self.config["installed"] or version not in self.config["installed"][sdk]:
            return print(f"❌ {sdk} {version} not installed")
        self.config["active"][sdk] = version
        self._save()
        print(f"✅ Now using {sdk} {version}")
        
    def current(self):
        print("\n🔧 Active SDKs:")
        for sdk, ver in self.config["active"].items():
            if ver: print(f"  {sdk}: {ver}")
        if not self.config["active"]: print("  No SDKs active")

def main():
    sdk = SDKManager()
    if len(sys.argv) < 2: return sdk.current()
    cmd = sys.argv[1]
    if cmd == "list": sdk.available()
    elif cmd == "install" and len(sys.argv) > 3: sdk.install(sys.argv[2], sys.argv[3])
    elif cmd == "uninstall" and len(sys.argv) > 3: sdk.uninstall(sys.argv[2], sys.argv[3])
    elif cmd == "use" and len(sys.argv) > 3: sdk.use(sys.argv[2], sys.argv[3])
    elif cmd == "current": sdk.current()
    else: print("Usage: sdk.py [list|install|uninstall|use|current] <sdk> <version>")

if __name__ == "__main__": main()
