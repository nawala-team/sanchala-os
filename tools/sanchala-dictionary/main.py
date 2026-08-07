#!/usr/bin/env python3
"""Sanchala Dictionary - Dictionary & Thesaurus"""
import sys, os, subprocess, json
try: import urllib.request
except: pass

class Dictionary:
    def define(self, word):
        try:
            url = f"https://api.dictionaryapi.dev/api/v2/entries/en/{word}"
            with urllib.request.urlopen(url, timeout=5) as r:
                data = json.loads(r.read().decode())
                if data and len(data) > 0:
                    meanings = data[0].get('meanings', [])
                    return [{"part": m['partOfSpeech'], "definitions": [d['definition'] for d in m['definitions'][:3]]} for m in meanings]
        except: pass
        # Fallback to dict command
        result = subprocess.run(['dict', word], capture_output=True, text=True)
        return result.stdout if result.returncode == 0 else None
    
    def synonyms(self, word):
        result = subprocess.run(['wn', word, '-synsn', '-synsv'], capture_output=True, text=True)
        return result.stdout
    
    def spell_check(self, word):
        result = subprocess.run(['aspell', '-a'], input=word, capture_output=True, text=True)
        return '*' in result.stdout

if __name__ == "__main__":
    d = Dictionary()
    if len(sys.argv) < 2:
        print("Sanchala Dictionary")
        print("Usage: sanchala-dictionary [define|synonyms|spell] WORD")
    elif sys.argv[1] == "define" and len(sys.argv) >= 3:
        result = d.define(sys.argv[2])
        if isinstance(result, list):
            for m in result:
                print(f"\n[{m['part']}]")
                for df in m['definitions']: print(f"  - {df}")
        elif result: print(result)
        else: print("Not found")
    elif sys.argv[1] == "synonyms" and len(sys.argv) >= 3: print(d.synonyms(sys.argv[2]))
    elif sys.argv[1] == "spell" and len(sys.argv) >= 3: print("Correct" if d.spell_check(sys.argv[2]) else "Misspelled")
