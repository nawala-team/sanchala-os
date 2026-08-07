#!/usr/bin/env python3
"""Sanchala Calculator - Advanced Calculator"""
import sys, os, math, json

class Calculator:
    def __init__(self):
        self.history = []
        self.memory = 0
    
    def calculate(self, expr):
        try:
            # Safe eval with math functions
            allowed = {k: v for k, v in math.__dict__.items() if not k.startswith('_')}
            allowed.update({'abs': abs, 'round': round, 'pow': pow})
            result = eval(expr, {"__builtins__": {}}, allowed)
            self.history.append({"expr": expr, "result": result})
            return result
        except Exception as e:
            return f"Error: {e}"
    
    def memory_store(self, value): self.memory = value
    def memory_recall(self): return self.memory
    def memory_clear(self): self.memory = 0
    def memory_add(self, value): self.memory += value
    
    def convert_unit(self, value, from_unit, to_unit):
        conversions = {
            ('km', 'mi'): 0.621371, ('mi', 'km'): 1.60934,
            ('kg', 'lb'): 2.20462, ('lb', 'kg'): 0.453592,
            ('c', 'f'): lambda x: x * 9/5 + 32, ('f', 'c'): lambda x: (x - 32) * 5/9,
        }
        key = (from_unit.lower(), to_unit.lower())
        if key in conversions:
            conv = conversions[key]
            return conv(value) if callable(conv) else value * conv
        return None

if __name__ == "__main__":
    calc = Calculator()
    if len(sys.argv) < 2:
        print("Sanchala Calculator")
        print("Usage: sanchala-calculator 'EXPRESSION'")
        print("       sanchala-calculator convert VALUE FROM TO")
        print("Examples: sanchala-calculator '2+2', 'sqrt(16)', 'sin(pi/2)'")
    elif sys.argv[1] == "convert" and len(sys.argv) >= 5:
        result = calc.convert_unit(float(sys.argv[2]), sys.argv[3], sys.argv[4])
        print(f"{sys.argv[2]} {sys.argv[3]} = {result} {sys.argv[4]}")
    else:
        expr = ' '.join(sys.argv[1:])
        print(calc.calculate(expr))
