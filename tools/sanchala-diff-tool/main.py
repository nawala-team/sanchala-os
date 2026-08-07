#!/usr/bin/env python3
"""Sanchala Diff Tool - File Comparison"""
import sys, os, subprocess, difflib

class DiffTool:
    def diff_files(self, file1, file2):
        with open(file1) as f1, open(file2) as f2:
            diff = difflib.unified_diff(f1.readlines(), f2.readlines(), fromfile=file1, tofile=file2)
            return ''.join(diff)
    
    def diff_dirs(self, dir1, dir2):
        result = subprocess.run(['diff', '-rq', dir1, dir2], capture_output=True, text=True)
        return result.stdout
    
    def visual_diff(self, file1, file2):
        for app in ['meld', 'kdiff3', 'kompare', 'diffuse']:
            try: subprocess.Popen([app, file1, file2]); return True
            except: continue
        return False
    
    def side_by_side(self, file1, file2):
        result = subprocess.run(['diff', '-y', '--width=120', file1, file2], capture_output=True, text=True)
        return result.stdout

if __name__ == "__main__":
    dt = DiffTool()
    if len(sys.argv) < 3:
        print("Sanchala Diff Tool")
        print("Usage: sanchala-diff-tool FILE1 FILE2 [--visual|--side]")
        print("       sanchala-diff-tool --dirs DIR1 DIR2")
    elif sys.argv[1] == "--dirs" and len(sys.argv) >= 4: print(dt.diff_dirs(sys.argv[2], sys.argv[3]))
    elif '--visual' in sys.argv: dt.visual_diff(sys.argv[1], sys.argv[2])
    elif '--side' in sys.argv: print(dt.side_by_side(sys.argv[1], sys.argv[2]))
    else: print(dt.diff_files(sys.argv[1], sys.argv[2]))
