#!/usr/bin/env python3
"""Sanchala Automator - Task Automation Tool"""
import sys, os, json, subprocess

class Automator:
    def __init__(self):
        self.config_dir = os.path.expanduser("~/.config/sanchala/automator")
        self.workflows_dir = os.path.join(self.config_dir, "workflows")
        os.makedirs(self.workflows_dir, exist_ok=True)
    
    def create_workflow(self, name, steps):
        workflow = {"name": name, "steps": steps}
        with open(os.path.join(self.workflows_dir, f"{name}.json"), 'w') as f:
            json.dump(workflow, f, indent=2)
        return True
    
    def run_workflow(self, name):
        path = os.path.join(self.workflows_dir, f"{name}.json")
        if not os.path.exists(path): return False, "Workflow not found"
        with open(path) as f: workflow = json.load(f)
        results = []
        for step in workflow['steps']:
            result = subprocess.run(step['command'], shell=True, capture_output=True, text=True)
            results.append({"step": step.get('name', step['command']), "success": result.returncode == 0})
        return True, results
    
    def list_workflows(self):
        return [f.replace('.json', '') for f in os.listdir(self.workflows_dir) if f.endswith('.json')]

if __name__ == "__main__":
    auto = Automator()
    if len(sys.argv) < 2:
        print("Sanchala Automator")
        print("Usage: sanchala-automator [list|run NAME|create NAME]")
    elif sys.argv[1] == "list":
        for w in auto.list_workflows(): print(f"  {w}")
    elif sys.argv[1] == "run" and len(sys.argv) >= 3:
        ok, results = auto.run_workflow(sys.argv[2])
        if ok:
            for r in results: print(f"  {'✓' if r['success'] else '✗'} {r['step']}")
        else: print(results)
