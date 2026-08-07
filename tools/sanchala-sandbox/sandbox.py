#!/usr/bin/env python3
"""Sanchala Sandbox - Isolated Execution Environment"""

import os, sys, json, subprocess, shutil
from datetime import datetime
from pathlib import Path

class Sandbox:
    def __init__(self):
        self.base_dir = Path(__file__).parent
        self.config_dir = self.base_dir / "config"
        self.sandboxes_dir = self.base_dir / "sandboxes"
        self.snapshots_dir = self.base_dir / "snapshots"
        for d in [self.config_dir, self.sandboxes_dir, self.snapshots_dir]:
            d.mkdir(parents=True, exist_ok=True)
        self.config_file = self.config_dir / "sandbox.json"
        self.config = self._load()
        
    def _load(self):
        if self.config_file.exists():
            try:
                with open(self.config_file) as f: return json.load(f)
            except: pass
        return {"sandboxes": {}, "default_limits": {"memory_mb": 512, "cpu_percent": 50, "network": False}}
        
    def _save(self):
        with open(self.config_file, 'w') as f: json.dump(self.config, f, indent=2)
            
    def create(self, name, template="minimal"):
        if name in self.config["sandboxes"]: return print(f"❌ Sandbox '{name}' exists")
        
        sb_dir = self.sandboxes_dir / name
        sb_dir.mkdir(parents=True, exist_ok=True)
        (sb_dir / "root").mkdir(exist_ok=True)
        (sb_dir / "home").mkdir(exist_ok=True)
        (sb_dir / "tmp").mkdir(exist_ok=True)
        
        self.config["sandboxes"][name] = {
            "name": name, "template": template, "status": "stopped",
            "created": datetime.now().isoformat(), "limits": self.config["default_limits"].copy()
        }
        self._save()
        print(f"✅ Created sandbox: {name}")
        
    def start(self, name):
        if name not in self.config["sandboxes"]: return print(f"❌ Sandbox not found")
        self.config["sandboxes"][name]["status"] = "running"
        self._save()
        print(f"▶️  Started: {name}")
        
    def stop(self, name):
        if name not in self.config["sandboxes"]: return print(f"❌ Sandbox not found")
        self.config["sandboxes"][name]["status"] = "stopped"
        self._save()
        print(f"⏹️  Stopped: {name}")
        
    def delete(self, name):
        if name not in self.config["sandboxes"]: return print(f"❌ Sandbox not found")
        sb_dir = self.sandboxes_dir / name
        if sb_dir.exists(): shutil.rmtree(sb_dir)
        del self.config["sandboxes"][name]
        self._save()
        print(f"🗑️  Deleted: {name}")
        
    def run(self, name, command):
        if name not in self.config["sandboxes"]: return print(f"❌ Sandbox not found")
        if self.config["sandboxes"][name]["status"] != "running":
            return print(f"❌ Sandbox not running")
        sb_dir = self.sandboxes_dir / name
        print(f"🔧 Running in {name}: {command}")
        # Simulated sandboxed execution
        os.system(f"cd {sb_dir} && {command}")
        
    def ls(self):
        print("\n📦 Sandboxes:")
        print(f"{'NAME':<15} {'STATUS':<10} {'TEMPLATE':<10} {'CREATED':<20}")
        print("-" * 55)
        for name, sb in self.config["sandboxes"].items():
            created = sb["created"][:16]
            print(f"{name:<15} {sb['status']:<10} {sb['template']:<10} {created}")
        if not self.config["sandboxes"]: print("  No sandboxes")
            
    def snapshot(self, name, snap_name):
        if name not in self.config["sandboxes"]: return print(f"❌ Sandbox not found")
        sb_dir = self.sandboxes_dir / name
        snap_dir = self.snapshots_dir / f"{name}-{snap_name}"
        shutil.copytree(sb_dir, snap_dir)
        print(f"📸 Snapshot created: {snap_name}")

def main():
    sb = Sandbox()
    if len(sys.argv) < 2: return sb.ls()
    cmd = sys.argv[1]
    if cmd == "create" and len(sys.argv) > 2: sb.create(sys.argv[2])
    elif cmd == "start" and len(sys.argv) > 2: sb.start(sys.argv[2])
    elif cmd == "stop" and len(sys.argv) > 2: sb.stop(sys.argv[2])
    elif cmd == "delete" and len(sys.argv) > 2: sb.delete(sys.argv[2])
    elif cmd == "run" and len(sys.argv) > 3: sb.run(sys.argv[2], " ".join(sys.argv[3:]))
    elif cmd == "list": sb.ls()
    elif cmd == "snapshot" and len(sys.argv) > 3: sb.snapshot(sys.argv[2], sys.argv[3])
    else: print("Usage: sandbox.py [create|start|stop|delete|run|list|snapshot] ...")

if __name__ == "__main__": main()
