#!/usr/bin/env python3
"""Sanchala Calculator - Advanced Calculator"""
import sys, os, math, json, ast, operator

class Calculator:
    def __init__(self):
        self.history = []
        self.memory = 0
        # Safe operators for expression evaluation
        self._operators = {
            ast.Add: operator.add,
            ast.Sub: operator.sub,
            ast.Mult: operator.mul,
            ast.Div: operator.truediv,
            ast.Pow: operator.pow,
            ast.USub: operator.neg,
            ast.UAdd: operator.pos,
        }
        # Safe math functions
        self._functions = {
            'sin': math.sin, 'cos': math.cos, 'tan': math.tan,
            'sqrt': math.sqrt, 'log': math.log, 'log10': math.log10,
            'exp': math.exp, 'abs': abs, 'round': round, 'pow': pow,
            'pi': math.pi, 'e': math.e,
            'asin': math.asin, 'acos': math.acos, 'atan': math.atan,
            'sinh': math.sinh, 'cosh': math.cosh, 'tanh': math.tanh,
            'degrees': math.degrees, 'radians': math.radians,
            'floor': math.floor, 'ceil': math.ceil,
        }
    
    def _safe_eval(self, node):
        """Safely evaluate an AST node"""
        if isinstance(node, ast.Num):  # Python 3.7
            return node.n
        elif isinstance(node, ast.Constant):  # Python 3.8+
            return node.value
        elif isinstance(node, ast.BinOp):
            left = self._safe_eval(node.left)
            right = self._safe_eval(node.right)
            return self._operators[type(node.op)](left, right)
        elif isinstance(node, ast.UnaryOp):
            operand = self._safe_eval(node.operand)
            return self._operators[type(node.op)](operand)
        elif isinstance(node, ast.Call):
            if isinstance(node.func, ast.Name) and node.func.id in self._functions:
                args = [self._safe_eval(arg) for arg in node.args]
                func = self._functions[node.func.id]
                if callable(func):
                    return func(*args)
                return func  # For constants like pi, e
            raise ValueError(f"Unknown function: {node.func.id if isinstance(node.func, ast.Name) else 'unknown'}")
        elif isinstance(node, ast.Name):
            if node.id in self._functions:
                return self._functions[node.id]
            raise ValueError(f"Unknown variable: {node.id}")
        else:
            raise ValueError(f"Unsupported expression type: {type(node)}")
    
    def calculate(self, expr):
        try:
            # Parse and safely evaluate expression
            tree = ast.parse(expr, mode='eval')
            result = self._safe_eval(tree.body)
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
