#!/usr/bin/env python3
"""Sanchala Diff Tool - File & Directory Comparison Tool"""

import os, sys, json, difflib
from datetime import datetime
from pathlib import Path

class DiffTool:
    def __init__(self):
        self.base_dir = Path(__file__).parent
        self.config_dir = self.base_dir / "config"
        self.patches_dir = self.base_dir / "patches"
        self.history_dir = self.base_dir / "history"
        for d in [self.config_dir, self.patches_dir, self.history_dir]:
            d.mkdir(parents=True, exist_ok=True)
            
    def diff_files(self, file1, file2, context=3):
        p1, p2 = Path(file1), Path(file2)
        if not p1.exists(): return print(f"❌ Not found: {file1}")
        if not p2.exists(): return print(f"❌ Not found: {file2}")
        
        with open(p1) as f1, open(p2) as f2:
            lines1 = f1.readlines()
            lines2 = f2.readlines()
            
        diff = difflib.unified_diff(lines1, lines2, fromfile=str(p1), tofile=str(p2), lineterm='', n=context)
        
        print(f"\n📄 Diff: {p1.name} ↔ {p2.name}")
        print("=" * 60)
        
        has_diff = False
        for line in diff:
            has_diff = True
            if line.startswith('+'): print(f"\033[32m{line}\033[0m")
            elif line.startswith('-'): print(f"\033[31m{line}\033[0m")
            elif line.startswith('@'): print(f"\033[36m{line}\033[0m")
            else: print(line)
            
        if not has_diff: print("✅ Files are identical")
        
    def diff_dirs(self, dir1, dir2):
        d1, d2 = Path(dir1), Path(dir2)
        if not d1.is_dir() or not d2.is_dir(): return print("❌ Invalid directories")
        
        files1 = set(f.relative_to(d1) for f in d1.rglob('*') if f.is_file())
        files2 = set(f.relative_to(d2) for f in d2.rglob('*') if f.is_file())
        
        print(f"\n📁 Directory Diff: {d1.name} ↔ {d2.name}")
        print("=" * 50)
        
        only1 = files1 - files2
        only2 = files2 - files1
        common = files1 & files2
        
        if only1:
            print(f"\n  Only in {d1.name}:")
            for f in sorted(only1)[:20]: print(f"    - {f}")
        if only2:
            print(f"\n  Only in {d2.name}:")
            for f in sorted(only2)[:20]: print(f"    + {f}")
            
        modified = []
        for f in common:
            if (d1/f).read_bytes() != (d2/f).read_bytes():
                modified.append(f)
        if modified:
            print(f"\n  Modified:")
            for f in sorted(modified)[:20]: print(f"    ~ {f}")
            
        print(f"\n  Summary: {len(only1)} removed, {len(only2)} added, {len(modified)} modified")
        
    def create_patch(self, file1, file2, output=None):
        p1, p2 = Path(file1), Path(file2)
        if not p1.exists() or not p2.exists(): return print("❌ File not found")
        
        with open(p1) as f1, open(p2) as f2:
            diff = difflib.unified_diff(f1.readlines(), f2.readlines(), 
                                        fromfile=str(p1), tofile=str(p2))
        patch = ''.join(diff)
        
        if output:
            out_path = Path(output)
        else:
            out_path = self.patches_dir / f"patch-{datetime.now().strftime('%Y%m%d-%H%M%S')}.patch"
            
        with open(out_path, 'w') as f: f.write(patch)
        print(f"✅ Patch saved: {out_path}")
        
    def apply_patch(self, patch_file, target):
        # Simplified patch application
        print(f"📋 Applying patch: {patch_file} to {target}")
        print("   (Use 'patch' command for full functionality)")
        
    def side_by_side(self, file1, file2, width=80):
        p1, p2 = Path(file1), Path(file2)
        if not p1.exists() or not p2.exists(): return print("❌ File not found")
        
        with open(p1) as f1, open(p2) as f2:
            lines1, lines2 = f1.readlines(), f2.readlines()
            
        hw = width // 2 - 2
        print(f"\n{'=' * hw} | {'=' * hw}")
        print(f"{p1.name:<{hw}} | {p2.name:<{hw}}")
        print(f"{'-' * hw} | {'-' * hw}")
        
        for i in range(max(len(lines1), len(lines2))):
            l1 = lines1[i].rstrip()[:hw] if i < len(lines1) else ""
            l2 = lines2[i].rstrip()[:hw] if i < len(lines2) else ""
            mark = " " if l1 == l2 else "~"
            print(f"{l1:<{hw}} {mark} {l2:<{hw}}")

def main():
    dt = DiffTool()
    if len(sys.argv) < 3:
        print("Usage: diff-tool.py [diff|dirs|patch|apply|side] <file1> <file2>")
        return
    cmd = sys.argv[1]
    if cmd == "diff": dt.diff_files(sys.argv[2], sys.argv[3])
    elif cmd == "dirs": dt.diff_dirs(sys.argv[2], sys.argv[3])
    elif cmd == "patch": dt.create_patch(sys.argv[2], sys.argv[3], sys.argv[4] if len(sys.argv) > 4 else None)
    elif cmd == "apply" and len(sys.argv) > 3: dt.apply_patch(sys.argv[2], sys.argv[3])
    elif cmd == "side": dt.side_by_side(sys.argv[2], sys.argv[3])
    else: print("Usage: diff-tool.py [diff|dirs|patch|apply|side] <file1> <file2>")

if __name__ == "__main__": main()
