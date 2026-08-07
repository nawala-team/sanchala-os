#!/usr/bin/env python3
"""Sanchala Hex Editor - Binary File Hex Editor"""

import os, sys, json
from datetime import datetime
from pathlib import Path

class HexEditor:
    def __init__(self):
        self.base_dir = Path(__file__).parent
        self.config_dir = self.base_dir / "config"
        self.recent_dir = self.base_dir / "recent"
        self.bookmarks_dir = self.base_dir / "bookmarks"
        for d in [self.config_dir, self.recent_dir, self.bookmarks_dir]:
            d.mkdir(parents=True, exist_ok=True)
        self.config = {"bytes_per_line": 16, "show_ascii": True, "recent": []}
        
    def view(self, filepath, offset=0, length=256):
        path = Path(filepath)
        if not path.exists(): return print(f"❌ File not found: {filepath}")
        
        print(f"\n📄 {path.name} (offset: {offset:#x}, length: {length})")
        print("=" * 70)
        print(f"{'OFFSET':<10} {'HEX':<49} {'ASCII'}")
        print("-" * 70)
        
        with open(path, 'rb') as f:
            f.seek(offset)
            data = f.read(length)
            
        bpl = self.config["bytes_per_line"]
        for i in range(0, len(data), bpl):
            chunk = data[i:i+bpl]
            hex_str = ' '.join(f'{b:02x}' for b in chunk)
            ascii_str = ''.join(chr(b) if 32 <= b < 127 else '.' for b in chunk)
            print(f"{offset+i:08x}  {hex_str:<48} {ascii_str}")
            
    def search(self, filepath, pattern):
        path = Path(filepath)
        if not path.exists(): return print(f"❌ File not found")
        
        # Convert hex pattern like "ff d8 ff" to bytes
        try:
            if ' ' in pattern:
                search_bytes = bytes(int(x, 16) for x in pattern.split())
            else:
                search_bytes = pattern.encode()
        except:
            search_bytes = pattern.encode()
            
        print(f"\n🔍 Searching for: {pattern}")
        with open(path, 'rb') as f:
            data = f.read()
            
        pos = 0
        found = []
        while True:
            pos = data.find(search_bytes, pos)
            if pos == -1: break
            found.append(pos)
            pos += 1
            
        if found:
            print(f"✅ Found {len(found)} matches:")
            for offset in found[:20]:
                print(f"  Offset: {offset:#x} ({offset})")
        else:
            print("❌ Pattern not found")
            
    def edit(self, filepath, offset, hex_value):
        path = Path(filepath)
        if not path.exists(): return print(f"❌ File not found")
        
        try:
            new_bytes = bytes(int(x, 16) for x in hex_value.split())
        except:
            return print("❌ Invalid hex value")
            
        with open(path, 'r+b') as f:
            f.seek(int(offset, 16) if offset.startswith('0x') else int(offset))
            f.write(new_bytes)
            
        print(f"✅ Wrote {len(new_bytes)} bytes at offset {offset}")
        
    def info(self, filepath):
        path = Path(filepath)
        if not path.exists(): return print(f"❌ File not found")
        
        stat = path.stat()
        print(f"\n📄 File Info: {path.name}")
        print("=" * 40)
        print(f"  Size: {stat.st_size} bytes ({stat.st_size/1024:.2f} KB)")
        print(f"  Modified: {datetime.fromtimestamp(stat.st_mtime)}")
        
        # Show first bytes (magic number)
        with open(path, 'rb') as f:
            magic = f.read(16)
        print(f"  Magic: {' '.join(f'{b:02x}' for b in magic)}")
        
    def compare(self, file1, file2):
        p1, p2 = Path(file1), Path(file2)
        if not p1.exists() or not p2.exists(): return print("❌ File not found")
        
        with open(p1, 'rb') as f1, open(p2, 'rb') as f2:
            d1, d2 = f1.read(), f2.read()
            
        diffs = []
        for i in range(min(len(d1), len(d2))):
            if d1[i] != d2[i]: diffs.append(i)
            
        print(f"\n🔀 Comparing: {p1.name} vs {p2.name}")
        print(f"  Size: {len(d1)} vs {len(d2)} bytes")
        print(f"  Differences: {len(diffs)}")
        for off in diffs[:10]:
            print(f"    {off:#x}: {d1[off]:02x} → {d2[off]:02x}")

def main():
    he = HexEditor()
    if len(sys.argv) < 2:
        print("Usage: hex-editor.py [view|search|edit|info|compare] <file> ...")
        return
    cmd = sys.argv[1]
    if cmd == "view" and len(sys.argv) > 2:
        he.view(sys.argv[2], int(sys.argv[3], 0) if len(sys.argv) > 3 else 0)
    elif cmd == "search" and len(sys.argv) > 3: he.search(sys.argv[2], sys.argv[3])
    elif cmd == "edit" and len(sys.argv) > 4: he.edit(sys.argv[2], sys.argv[3], sys.argv[4])
    elif cmd == "info" and len(sys.argv) > 2: he.info(sys.argv[2])
    elif cmd == "compare" and len(sys.argv) > 3: he.compare(sys.argv[2], sys.argv[3])
    else: print("Usage: hex-editor.py [view|search|edit|info|compare] <file> ...")

if __name__ == "__main__": main()
