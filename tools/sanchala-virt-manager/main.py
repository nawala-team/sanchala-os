#!/usr/bin/env python3
"""Sanchala Virtual Machine Manager"""
import sys, os, subprocess

class VirtManager:
    def open_app(self): subprocess.Popen(['virt-manager'])
    def list_vms(self): return subprocess.run(['virsh', 'list', '--all'], capture_output=True, text=True).stdout
    def start_vm(self, name): subprocess.run(['virsh', 'start', name])
    def stop_vm(self, name): subprocess.run(['virsh', 'shutdown', name])

if __name__ == "__main__":
    vm = VirtManager()
    if len(sys.argv) < 2: vm.open_app()
    elif sys.argv[1] == "list": print(vm.list_vms())
    elif sys.argv[1] == "start" and len(sys.argv) >= 3: vm.start_vm(sys.argv[2])
    elif sys.argv[1] == "stop" and len(sys.argv) >= 3: vm.stop_vm(sys.argv[2])
