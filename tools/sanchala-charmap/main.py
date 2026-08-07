#!/usr/bin/env python3
"""Sanchala Character Map - Unicode Character Browser"""
import sys, os, unicodedata

class CharMap:
    CATEGORIES = {'emoji': (0x1F600, 0x1F64F), 'arrows': (0x2190, 0x21FF), 'math': (0x2200, 0x22FF), 'symbols': (0x2600, 0x26FF), 'dingbats': (0x2700, 0x27BF)}
    
    def search(self, query):
        results = []
        for i in range(0x10000):
            try:
                name = unicodedata.name(chr(i), '')
                if query.upper() in name: results.append((chr(i), f"U+{i:04X}", name))
            except: pass
        return results[:50]
    
    def get_category(self, cat):
        if cat in self.CATEGORIES:
            start, end = self.CATEGORIES[cat]
            return [(chr(i), f"U+{i:04X}") for i in range(start, end+1)]
        return []
    
    def char_info(self, char):
        code = ord(char)
        return {"char": char, "code": f"U+{code:04X}", "decimal": code, "name": unicodedata.name(char, 'Unknown'), "category": unicodedata.category(char)}
    
    def copy_to_clipboard(self, text):
        os.system(f"echo -n '{text}' | xclip -selection clipboard")

if __name__ == "__main__":
    cm = CharMap()
    if len(sys.argv) < 2:
        print("Sanchala Character Map")
        print("Usage: sanchala-charmap [search QUERY|category CAT|info CHAR|copy CHAR]")
        print(f"Categories: {', '.join(CharMap.CATEGORIES.keys())}")
    elif sys.argv[1] == "search" and len(sys.argv) >= 3:
        for c, code, name in cm.search(sys.argv[2]): print(f"  {c}  {code}  {name}")
    elif sys.argv[1] == "category" and len(sys.argv) >= 3:
        for c, code in cm.get_category(sys.argv[2])[:30]: print(f"  {c}  {code}")
    elif sys.argv[1] == "info" and len(sys.argv) >= 3:
        for k, v in cm.char_info(sys.argv[2]).items(): print(f"  {k}: {v}")
    elif sys.argv[1] == "copy" and len(sys.argv) >= 3: cm.copy_to_clipboard(sys.argv[2]); print("Copied!")
