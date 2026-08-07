#!/usr/bin/env python3
"""Sanchala Containers - Container Management (Docker/Podman)"""
import sys, os, subprocess

class Containers:
    def __init__(self):
        self.runtime = 'podman' if subprocess.run(['which', 'podman'], capture_output=True).returncode == 0 else 'docker'
    
    def list_containers(self, all=False):
        cmd = [self.runtime, 'ps']
        if all: cmd.append('-a')
        return subprocess.run(cmd, capture_output=True, text=True).stdout
    
    def list_images(self):
        return subprocess.run([self.runtime, 'images'], capture_output=True, text=True).stdout
    
    def run(self, image, name=None, ports=None, detach=True):
        cmd = [self.runtime, 'run']
        if detach: cmd.append('-d')
        if name: cmd.extend(['--name', name])
        if ports: cmd.extend(['-p', ports])
        cmd.append(image)
        return subprocess.run(cmd, capture_output=True, text=True)
    
    def stop(self, container): subprocess.run([self.runtime, 'stop', container])
    def start(self, container): subprocess.run([self.runtime, 'start', container])
    def rm(self, container): subprocess.run([self.runtime, 'rm', container])
    def logs(self, container): return subprocess.run([self.runtime, 'logs', container], capture_output=True, text=True).stdout

if __name__ == "__main__":
    c = Containers()
    if len(sys.argv) < 2:
        print(f"Sanchala Containers ({c.runtime})")
        print("Usage: sanchala-containers [ps|images|run IMAGE|stop|start|rm|logs] CONTAINER")
    elif sys.argv[1] == "ps": print(c.list_containers('-a' in sys.argv))
    elif sys.argv[1] == "images": print(c.list_images())
    elif sys.argv[1] == "run" and len(sys.argv) >= 3: c.run(sys.argv[2]); print("Started")
    elif sys.argv[1] == "stop" and len(sys.argv) >= 3: c.stop(sys.argv[2])
    elif sys.argv[1] == "start" and len(sys.argv) >= 3: c.start(sys.argv[2])
    elif sys.argv[1] == "rm" and len(sys.argv) >= 3: c.rm(sys.argv[2])
    elif sys.argv[1] == "logs" and len(sys.argv) >= 3: print(c.logs(sys.argv[2]))
