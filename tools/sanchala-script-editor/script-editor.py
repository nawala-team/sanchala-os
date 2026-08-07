#!/usr/bin/env python3
"""Sanchala Script Editor - Developer Script Editor with Syntax Highlighting"""

import os, sys, json
from datetime import datetime
from pathlib import Path

class ScriptEditor:
    def __init__(self):
        self.base_dir = Path(__file__).parent
        self.config_dir = self.base_dir / "config"
        self.scripts_dir = self.base_dir / "scripts"
        self.templates_dir = self.base_dir / "templates"
        for d in [self.config_dir, self.scripts_dir, self.templates_dir]:
            d.mkdir(parents=True, exist_ok=True)
        self._init_templates()
        
    def _init_templates(self):
        templates = {
            "python.py": "#!/usr/bin/env python3\n\"\"\"\nScript: {name}\nCreated: {date}\n\"\"\"\n\ndef main():\n    pass\n\nif __name__ == \"__main__\":\n    main()\n",
            "bash.sh": "#!/bin/bash\n# Script: {name}\n# Created: {date}\n\nset -e\n\nmain() {{\n    echo \"Hello\"\n}}\n\nmain \"$@\"\n",
            "node.js": "#!/usr/bin/env node\n/**\n * Script: {name}\n * Created: {date}\n */\n\nfunction main() {\n    console.log('Hello');\n}\n\nmain();\n"
        }
        for name, content in templates.items():
            tf = self.templates_dir / name
            if not tf.exists():
                with open(tf, 'w') as f: f.write(content)
                    
    def create(self, name, template="python"):
        ext_map = {"python": ".py", "bash": ".sh", "node": ".js"}
        ext = ext_map.get(template, ".py")
        script_file = self.scripts_dir / f"{name}{ext}"
        
        tf = self.templates_dir / f"{template}{ext}"
        if tf.exists():
            with open(tf) as f: content = f.read()
            content = content.format(name=name, date=datetime.now().strftime("%Y-%m-%d"))
        else:
            content = f"# {name}\n"
            
        with open(script_file, 'w') as f: f.write(content)
        script_file.chmod(0o755)
        print(f"✅ Created: {script_file}")
        
    def edit(self, script_file):
        path = Path(script_file)
        if not path.exists(): path = self.scripts_dir / script_file
        if not path.exists(): return print(f"❌ Not found: {script_file}")
        
        editor = os.environ.get("EDITOR", "nano")
        os.system(f"{editor} {path}")
        
    def run(self, script_file, args=None):
        path = Path(script_file)
        if not path.exists(): path = self.scripts_dir / script_file
        if not path.exists(): return print(f"❌ Not found: {script_file}")
        
        ext = path.suffix
        cmd_map = {".py": "python3", ".sh": "bash", ".js": "node"}
        cmd = cmd_map.get(ext, "")
        
        full_cmd = f"{cmd} {path}" if cmd else str(path)
        if args: full_cmd += f" {args}"
        print(f"▶️  Running: {full_cmd}\n")
        os.system(full_cmd)
        
    def ls(self):
        print("\n📜 Scripts:")
        for ext in ["*.py", "*.sh", "*.js"]:
            for f in sorted(self.scripts_dir.glob(ext)):
                size = f.stat().st_size
                print(f"  {f.name:<30} {size:>8} bytes")
        if not list(self.scripts_dir.glob("*")): print("  No scripts")
            
    def templates(self):
        print("\n📋 Templates:")
        for f in sorted(self.templates_dir.glob("*")):
            print(f"  {f.stem}")

def main():
    se = ScriptEditor()
    if len(sys.argv) < 2: return se.ls()
    cmd = sys.argv[1]
    if cmd == "create" and len(sys.argv) > 2:
        se.create(sys.argv[2], sys.argv[3] if len(sys.argv) > 3 else "python")
    elif cmd == "edit" and len(sys.argv) > 2: se.edit(sys.argv[2])
    elif cmd == "run" and len(sys.argv) > 2: se.run(sys.argv[2], " ".join(sys.argv[3:]) if len(sys.argv) > 3 else None)
    elif cmd == "list": se.ls()
    elif cmd == "templates": se.templates()
    else: print("Usage: script-editor.py [create|edit|run|list|templates] ...")

if __name__ == "__main__": main()
