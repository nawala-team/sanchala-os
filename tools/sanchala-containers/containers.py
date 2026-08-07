#!/usr/bin/env python3
"""Sanchala Containers - Container Management Tool"""

import os, sys, json, subprocess, shutil
from datetime import datetime
from pathlib import Path

class ContainerManager:
    def __init__(self):
        self.base_dir = Path(__file__).parent
        self.config_dir = self.base_dir / "config"
        self.images_dir = self.base_dir / "images"
        self.volumes_dir = self.base_dir / "volumes"
        for d in [self.config_dir, self.images_dir, self.volumes_dir]:
            d.mkdir(parents=True, exist_ok=True)
        self.config_file = self.config_dir / "containers.json"
        self.containers = self._load()
        
    def _load(self):
        if self.config_file.exists():
            try:
                with open(self.config_file) as f: return json.load(f)
            except: pass
        return {"containers": {}, "networks": {"default": {"subnet": "172.17.0.0/16"}}}
        
    def _save(self):
        with open(self.config_file, 'w') as f: json.dump(self.containers, f, indent=2)
            
    def create(self, name, image="alpine", ports=None, volumes=None):
        if name in self.containers["containers"]:
            return print(f"❌ Container '{name}' exists")
        self.containers["containers"][name] = {
            "name": name, "image": image, "status": "created",
            "ports": ports.split(",") if ports else [],
            "volumes": volumes.split(",") if volumes else [],
            "created": datetime.now().isoformat(), "pid": None
        }
        self._save()
        print(f"✅ Created container: {name} (image: {image})")
        
    def start(self, name):
        if name not in self.containers["containers"]:
            return print(f"❌ Container '{name}' not found")
        self.containers["containers"][name]["status"] = "running"
        self.containers["containers"][name]["started"] = datetime.now().isoformat()
        self._save()
        print(f"▶️  Started: {name}")
        
    def stop(self, name):
        if name not in self.containers["containers"]:
            return print(f"❌ Container '{name}' not found")
        self.containers["containers"][name]["status"] = "stopped"
        self._save()
        print(f"⏹️  Stopped: {name}")
        
    def remove(self, name):
        if name not in self.containers["containers"]:
            return print(f"❌ Container '{name}' not found")
        del self.containers["containers"][name]
        self._save()
        print(f"🗑️  Removed: {name}")
        
    def ls(self, all_containers=False):
        print("\n📦 Containers:")
        print(f"{'NAME':<15} {'IMAGE':<12} {'STATUS':<10} {'CREATED':<20}")
        print("-" * 60)
        for name, c in self.containers["containers"].items():
            if all_containers or c["status"] == "running":
                created = c["created"][:16] if c.get("created") else "N/A"
                print(f"{name:<15} {c['image']:<12} {c['status']:<10} {created}")
        if not self.containers["containers"]:
            print("  No containers")
            
    def images(self):
        print("\n🖼️  Images:")
        builtin = ["alpine:latest", "ubuntu:22.04", "debian:stable", "python:3.11", "node:18"]
        for img in builtin:
            print(f"  {img}")
        for img in self.images_dir.glob("*.tar"):
            print(f"  {img.stem} (local)")
            
    def exec_cmd(self, name, command):
        if name not in self.containers["containers"]:
            return print(f"❌ Container '{name}' not found")
        if self.containers["containers"][name]["status"] != "running":
            return print(f"❌ Container not running")
        print(f"🔧 Exec in {name}: {command}")
        # Simulated exec - in real impl would use proot/chroot
        
    def logs(self, name, lines=50):
        if name not in self.containers["containers"]:
            return print(f"❌ Container '{name}' not found")
        log_file = self.config_dir / f"{name}.log"
        if log_file.exists():
            with open(log_file) as f:
                for line in f.readlines()[-lines:]:
                    print(line.rstrip())
        else:
            print(f"No logs for {name}")

def main():
    cm = ContainerManager()
    if len(sys.argv) < 2: return cm.ls(True)
    cmd = sys.argv[1]
    if cmd == "create" and len(sys.argv) > 2:
        cm.create(sys.argv[2], sys.argv[3] if len(sys.argv) > 3 else "alpine")
    elif cmd == "start" and len(sys.argv) > 2: cm.start(sys.argv[2])
    elif cmd == "stop" and len(sys.argv) > 2: cm.stop(sys.argv[2])
    elif cmd == "rm" and len(sys.argv) > 2: cm.remove(sys.argv[2])
    elif cmd in ["ls", "ps"]: cm.ls("-a" in sys.argv)
    elif cmd == "images": cm.images()
    elif cmd == "exec" and len(sys.argv) > 3: cm.exec_cmd(sys.argv[2], " ".join(sys.argv[3:]))
    elif cmd == "logs" and len(sys.argv) > 2: cm.logs(sys.argv[2])
    else: print("Usage: containers.py [create|start|stop|rm|ls|images|exec|logs] ...")

if __name__ == "__main__": main()
