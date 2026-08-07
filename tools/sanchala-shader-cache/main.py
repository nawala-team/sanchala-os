#!/usr/bin/env python3
"""Sanchala Shader Cache Manager"""
import sys, os, subprocess

class ShaderCache:
    def clear_mesa(self):
        path = os.path.expanduser('~/.cache/mesa_shader_cache')
        subprocess.run(['rm', '-rf', path]); print("Mesa cache cleared")
    def clear_nvidia(self):
        path = os.path.expanduser('~/.nv/GLCache')
        subprocess.run(['rm', '-rf', path]); print("NVIDIA cache cleared")
    def clear_all(self): self.clear_mesa(); self.clear_nvidia()
    def size(self):
        paths = ['~/.cache/mesa_shader_cache', '~/.nv/GLCache']
        for p in paths:
            ep = os.path.expanduser(p)
            if os.path.exists(ep):
                r = subprocess.run(['du', '-sh', ep], capture_output=True, text=True)
                print(r.stdout.strip())

if __name__ == "__main__":
    sc = ShaderCache()
    if len(sys.argv) < 2: sc.size()
    elif sys.argv[1] == "clear": sc.clear_all()
