#!/usr/bin/env python3
"""Sanchala Automator - Task Automation & Workflow Engine"""

import os, sys, json, subprocess, time, shlex
from datetime import datetime
from pathlib import Path

class Automator:
    def __init__(self):
        self.base_dir = Path(__file__).parent
        self.config_dir = self.base_dir / "config"
        self.workflows_dir = self.base_dir / "workflows"
        self.triggers_dir = self.base_dir / "triggers"
        for d in [self.config_dir, self.workflows_dir, self.triggers_dir]:
            d.mkdir(parents=True, exist_ok=True)
        self.config_file = self.config_dir / "automator.json"
        self.config = self._load()
        # Allowed commands for security
        self._allowed_commands = [
            'echo', 'notify-send', 'xdg-open', 'cp', 'mv', 'mkdir', 'rm',
            'systemctl', 'pacman', 'flatpak', 'snap', 'yay',
            'rsync', 'tar', 'gzip', 'zip', 'unzip', 'sleep'
        ]
        
    def _load(self):
        if self.config_file.exists():
            try:
                with open(self.config_file) as f: return json.load(f)
            except: pass
        return {"workflows": {}, "history": []}
        
    def _save(self):
        with open(self.config_file, 'w') as f: json.dump(self.config, f, indent=2)
    
    def _validate_command(self, cmd):
        """Validate command is in allowed list"""
        try:
            parts = shlex.split(cmd)
            if not parts:
                return False
            if parts[0] == 'sudo' and len(parts) > 1:
                return parts[1] in self._allowed_commands
            return parts[0] in self._allowed_commands
        except:
            return False
            
    def create_workflow(self, name):
        wf = {"name": name, "steps": [], "created": datetime.now().isoformat(), "enabled": True}
        wf_file = self.workflows_dir / f"{name}.json"
        with open(wf_file, 'w') as f: json.dump(wf, f, indent=2)
        print(f"✅ Created workflow: {name}")
        
    def add_step(self, workflow, step_type, command):
        wf_file = self.workflows_dir / f"{workflow}.json"
        if not wf_file.exists(): return print(f"❌ Workflow not found: {workflow}")
        with open(wf_file) as f: wf = json.load(f)
        wf["steps"].append({"type": step_type, "command": command, "order": len(wf["steps"]) + 1})
        with open(wf_file, 'w') as f: json.dump(wf, f, indent=2)
        print(f"✅ Added step to {workflow}")
        
    def run_workflow(self, name):
        wf_file = self.workflows_dir / f"{name}.json"
        if not wf_file.exists(): return print(f"❌ Workflow not found: {name}")
        with open(wf_file) as f: wf = json.load(f)
        
        print(f"\n▶️  Running workflow: {name}")
        print("=" * 40)
        
        for i, step in enumerate(wf["steps"], 1):
            print(f"\n  Step {i}: {step['type']}")
            print(f"  Command: {step['command']}")
            try:
                if step["type"] == "shell":
                    if not self._validate_command(step["command"]):
                        print(f"  ❌ Command not allowed: {step['command']}")
                        continue
                    cmd_parts = shlex.split(step["command"])
                    result = subprocess.run(cmd_parts, capture_output=True, text=True)
                    if result.stdout: print(f"  Output: {result.stdout.strip()[:100]}")
                    if result.returncode != 0: 
                        print(f"  ⚠️  Warning: Exit code {result.returncode}")
                elif step["type"] == "wait":
                    time.sleep(int(step["command"]))
                print(f"  ✓ Complete")
            except Exception as e:
                print(f"  ❌ Error: {e}")
                
        self.config["history"].append({"workflow": name, "ran": datetime.now().isoformat()})
        self._save()
        print(f"\n✅ Workflow complete")
        
    def list_workflows(self):
        print("\n🔄 Workflows:")
        for wf_file in sorted(self.workflows_dir.glob("*.json")):
            with open(wf_file) as f: wf = json.load(f)
            status = "✓" if wf.get("enabled", True) else "✗"
            print(f"  [{status}] {wf_file.stem} ({len(wf['steps'])} steps)")
        if not list(self.workflows_dir.glob("*.json")): print("  No workflows")
            
    def show_workflow(self, name):
        wf_file = self.workflows_dir / f"{name}.json"
        if not wf_file.exists(): return print(f"❌ Not found: {name}")
        with open(wf_file) as f: wf = json.load(f)
        print(f"\n📋 Workflow: {name}")
        for i, step in enumerate(wf["steps"], 1):
            print(f"  {i}. [{step['type']}] {step['command']}")

def main():
    auto = Automator()
    if len(sys.argv) < 2: return auto.list_workflows()
    cmd = sys.argv[1]
    if cmd == "create" and len(sys.argv) > 2: auto.create_workflow(sys.argv[2])
    elif cmd == "add" and len(sys.argv) > 4: auto.add_step(sys.argv[2], sys.argv[3], " ".join(sys.argv[4:]))
    elif cmd == "run" and len(sys.argv) > 2: auto.run_workflow(sys.argv[2])
    elif cmd == "list": auto.list_workflows()
    elif cmd == "show" and len(sys.argv) > 2: auto.show_workflow(sys.argv[2])
    else: print("Usage: automator.py [create|add|run|list|show] <name> ...")

if __name__ == "__main__": main()
