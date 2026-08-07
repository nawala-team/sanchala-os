#!/usr/bin/env python3
"""Sanchala AI - KRunner integration for smart search"""

import sys
import json
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent.parent / "lib"))

def main():
    """KRunner plugin for AI-powered search suggestions"""
    from sanchala_aid import SmartSuggestions, Config
    
    if len(sys.argv) < 2:
        return
    
    query = " ".join(sys.argv[1:])
    suggestions = SmartSuggestions(Config())
    results = suggestions.get_suggestions(query, limit=5)
    
    # Output in KRunner format
    for item in results:
        print(f"{item['text']}\t{item['type']}\t{item['score']}")

if __name__ == "__main__":
    main()
