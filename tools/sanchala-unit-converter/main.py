#!/usr/bin/env python3
"""Sanchala Unit Converter"""
import sys

class UnitConverter:
    def convert(self, value, from_unit, to_unit):
        conversions = {
            ('km', 'mi'): lambda x: x * 0.621371,
            ('mi', 'km'): lambda x: x * 1.60934,
            ('kg', 'lb'): lambda x: x * 2.20462,
            ('lb', 'kg'): lambda x: x * 0.453592,
            ('c', 'f'): lambda x: x * 9/5 + 32,
            ('f', 'c'): lambda x: (x - 32) * 5/9,
            ('l', 'gal'): lambda x: x * 0.264172,
            ('gal', 'l'): lambda x: x * 3.78541,
        }
        key = (from_unit.lower(), to_unit.lower())
        if key in conversions: return conversions[key](float(value))
        return None

if __name__ == "__main__":
    uc = UnitConverter()
    if len(sys.argv) >= 4:
        result = uc.convert(sys.argv[1], sys.argv[2], sys.argv[3])
        if result: print(f"{sys.argv[1]} {sys.argv[2]} = {result:.2f} {sys.argv[3]}")
    else: print("Usage: sanchala-unit-converter VALUE FROM TO")
