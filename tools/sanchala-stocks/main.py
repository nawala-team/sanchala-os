#!/usr/bin/env python3
"""Sanchala Stocks"""
import sys, subprocess

class Stocks:
    def get_quote(self, symbol):
        try:
            import urllib.request, json
            # Using a free API
            r = subprocess.run(['curl', '-s', f'https://query1.finance.yahoo.com/v8/finance/chart/{symbol}'], capture_output=True, text=True)
            return r.stdout[:500]
        except: return "Could not fetch quote"
    def open_app(self): subprocess.run(['xdg-open', 'https://finance.yahoo.com'])

if __name__ == "__main__":
    s = Stocks()
    if len(sys.argv) < 2: s.open_app()
    elif len(sys.argv) >= 2: print(s.get_quote(sys.argv[1]))
