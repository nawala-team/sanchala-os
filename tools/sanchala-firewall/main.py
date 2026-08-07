#!/usr/bin/env python3
"""Sanchala Firewall - Firewall Manager"""
import sys, os, subprocess

class Firewall:
    def status(self):
        result = subprocess.run(['sudo', 'ufw', 'status', 'verbose'], capture_output=True, text=True)
        return result.stdout
    
    def enable(self): subprocess.run(['sudo', 'ufw', 'enable'])
    def disable(self): subprocess.run(['sudo', 'ufw', 'disable'])
    
    def allow(self, port):
        subprocess.run(['sudo', 'ufw', 'allow', str(port)])
    
    def deny(self, port):
        subprocess.run(['sudo', 'ufw', 'deny', str(port)])
    
    def delete_rule(self, rule_num):
        subprocess.run(['sudo', 'ufw', 'delete', str(rule_num)])
    
    def reset(self):
        subprocess.run(['sudo', 'ufw', 'reset'])
    
    def open_gui(self):
        subprocess.Popen(['gufw'])

if __name__ == "__main__":
    fw = Firewall()
    if len(sys.argv) < 2: print(fw.status())
    elif sys.argv[1] == "enable": fw.enable()
    elif sys.argv[1] == "disable": fw.disable()
    elif sys.argv[1] == "allow" and len(sys.argv) >= 3: fw.allow(sys.argv[2])
    elif sys.argv[1] == "deny" and len(sys.argv) >= 3: fw.deny(sys.argv[2])
    elif sys.argv[1] == "gui": fw.open_gui()
