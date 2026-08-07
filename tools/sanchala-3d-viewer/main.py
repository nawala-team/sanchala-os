#!/usr/bin/env python3
"""Sanchala 3D Viewer - 3D Model Viewer"""
import sys, os, subprocess

class Viewer3D:
    SUPPORTED = ['.obj', '.stl', '.gltf', '.glb', '.fbx', '.dae', '.3ds', '.blend']
    
    def __init__(self):
        self.config_dir = os.path.expanduser("~/.config/sanchala/3d-viewer")
        os.makedirs(self.config_dir, exist_ok=True)
    
    def open_file(self, filepath):
        ext = os.path.splitext(filepath)[1].lower()
        if ext not in self.SUPPORTED:
            return False, f"Unsupported format: {ext}"
        # Try f3d first, then blender
        for cmd in ['f3d', 'blender']:
            try:
                subprocess.Popen([cmd, filepath])
                return True, f"Opened with {cmd}"
            except FileNotFoundError:
                continue
        return False, "No 3D viewer installed (install f3d or blender)"
    
    def get_info(self, filepath):
        return {"file": filepath, "size": os.path.getsize(filepath), "ext": os.path.splitext(filepath)[1]}

if __name__ == "__main__":
    viewer = Viewer3D()
    if len(sys.argv) < 2:
        print("Sanchala 3D Viewer")
        print(f"Supported: {', '.join(Viewer3D.SUPPORTED)}")
        print("Usage: sanchala-3d-viewer <file.obj>")
    else:
        success, msg = viewer.open_file(sys.argv[1])
        print(msg)
