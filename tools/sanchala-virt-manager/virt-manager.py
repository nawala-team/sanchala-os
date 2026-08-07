#!/usr/bin/env python3
"""Sanchala Virt Manager - Virtual Machine Management"""

import os, sys, json
from datetime import datetime
from pathlib import Path

class VirtManager:
    def __init__(self):
        self.base_dir = Path(__file__).parent
        self.config_dir = self.base_dir / "config"
        self.vms_dir = self.base_dir / "vms"
        self.iso_dir = self.base_dir / "iso"
        for d in [self.config_dir, self.vms_dir, self.iso_dir]:
            d.mkdir(parents=True, exist_ok=True)
        self.config_file = self.config_dir / "vms.json"
        self.vms = self._load()
        
    def _load(self):
        if self.config_file.exists():
            try:
                with open(self.config_file) as f: return json.load(f)
            except: pass
        return {"vms": {}, "default_cpu": 2, "default_ram": 1024}
        
    def _save(self):
        with open(self.config_file, 'w') as f: json.dump(self.vms, f, indent=2)
            
    def create(self, name, cpu=2, ram=1024, disk=10):
        if name in self.vms["vms"]:
            return print(f"❌ VM '{name}' exists")
        self.vms["vms"][name] = {
            "name": name, "cpu": int(cpu), "ram": int(ram), "disk_gb": int(disk),
            "status": "stopped", "os": "linux", "created": datetime.now().isoformat()
        }
        self._save()
        print(f"✅ Created VM: {name} ({cpu} CPU, {ram}MB RAM, {disk}GB disk)")
        
    def start(self, name):
        if name not in self.vms["vms"]: return print(f"❌ VM '{name}' not found")
        self.vms["vms"][name]["status"] = "running"
        self._save()
        print(f"▶️  Started VM: {name}")
        
    def stop(self, name):
        if name not in self.vms["vms"]: return print(f"❌ VM '{name}' not found")
        self.vms["vms"][name]["status"] = "stopped"
        self._save()
        print(f"⏹️  Stopped VM: {name}")
        
    def delete(self, name):
        if name not in self.vms["vms"]: return print(f"❌ VM '{name}' not found")
        del self.vms["vms"][name]
        self._save()
        print(f"🗑️  Deleted VM: {name}")
        
    def ls(self):
        print("\n💻 Virtual Machines:")
        print(f"{'NAME':<15} {'CPU':<5} {'RAM':<8} {'DISK':<8} {'STATUS':<10}")
        print("-" * 50)
        for name, vm in self.vms["vms"].items():
            print(f"{name:<15} {vm['cpu']:<5} {vm['ram']}MB  {vm['disk_gb']}GB   {vm['status']}")
        if not self.vms["vms"]: print("  No VMs configured")
            
    def info(self, name):
        if name not in self.vms["vms"]: return print(f"❌ VM '{name}' not found")
        vm = self.vms["vms"][name]
        print(f"\n💻 VM: {name}")
        print("=" * 35)
        for k, v in vm.items(): print(f"  {k}: {v}")

def main():
    vm = VirtManager()
    if len(sys.argv) < 2: return vm.ls()
    cmd = sys.argv[1]
    if cmd == "create" and len(sys.argv) > 2:
        vm.create(sys.argv[2], sys.argv[3] if len(sys.argv) > 3 else 2,
                  sys.argv[4] if len(sys.argv) > 4 else 1024)
    elif cmd == "start" and len(sys.argv) > 2: vm.start(sys.argv[2])
    elif cmd == "stop" and len(sys.argv) > 2: vm.stop(sys.argv[2])
    elif cmd == "delete" and len(sys.argv) > 2: vm.delete(sys.argv[2])
    elif cmd == "list": vm.ls()
    elif cmd == "info" and len(sys.argv) > 2: vm.info(sys.argv[2])
    else: print("Usage: virt-manager.py [create|start|stop|delete|list|info] ...")

if __name__ == "__main__": main()
