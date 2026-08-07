#!/usr/bin/env python3
"""Sanchala Color Picker - Screen Color Picker"""
import sys, os, subprocess

class ColorPicker:
    def pick_color(self):
        # Try different color pickers
        for cmd in [['gpick', '-s'], ['kcolorchooser'], ['grabc']]:
            try:
                result = subprocess.run(cmd, capture_output=True, text=True)
                return result.stdout.strip()
            except: continue
        return None
    
    def convert_hex_rgb(self, hex_color):
        hex_color = hex_color.lstrip('#')
        return tuple(int(hex_color[i:i+2], 16) for i in (0, 2, 4))
    
    def convert_rgb_hex(self, r, g, b):
        return f"#{r:02x}{g:02x}{b:02x}"
    
    def copy_to_clipboard(self, color):
        p = subprocess.Popen(['xclip', '-selection', 'clipboard'], stdin=subprocess.PIPE)
        p.communicate(color.encode())

if __name__ == "__main__":
    cp = ColorPicker()
    if len(sys.argv) < 2:
        print("Sanchala Color Picker")
        print("Usage: sanchala-colorpicker [pick|hex2rgb HEX|rgb2hex R G B]")
    elif sys.argv[1] == "pick":
        color = cp.pick_color()
        if color: print(f"Color: {color}"); cp.copy_to_clipboard(color)
        else: print("Install gpick, kcolorchooser, or grabc")
    elif sys.argv[1] == "hex2rgb" and len(sys.argv) >= 3:
        r, g, b = cp.convert_hex_rgb(sys.argv[2])
        print(f"RGB: {r}, {g}, {b}")
    elif sys.argv[1] == "rgb2hex" and len(sys.argv) >= 5:
        print(cp.convert_rgb_hex(int(sys.argv[2]), int(sys.argv[3]), int(sys.argv[4])))
