#!/usr/bin/env python3
"""Sanchala VPN"""
import sys, os, subprocess

class VPN:
    def list_connections(self):
        result = subprocess.run(['nmcli', 'con', 'show', '--active'], capture_output=True, text=True)
        return result.stdout
    
    def connect(self, name):
        subprocess.run(['nmcli', 'con', 'up', name])
    
    def disconnect(self, name):
        subprocess.run(['nmcli', 'con', 'down', name])
    
    def import_ovpn(self, filepath):
        name = os.path.basename(filepath).replace('.ovpn', '')
        subprocess.run(['nmcli', 'con', 'import', 'type', 'openvpn', 'file', filepath])
        return name
    
    def status(self):
        result = subprocess.run(['nmcli', 'con', 'show', '--active'], capture_output=True, text=True)
        vpns = [l for l in result.stdout.split('\n') if 'vpn' in l.lower()]
        return vpns if vpns else ["No VPN connected"]

if __name__ == "__main__":
    vpn = VPN()
    if len(sys.argv) < 2: [print(v) for v in vpn.status()]
    elif sys.argv[1] == "list": print(vpn.list_connections())
    elif sys.argv[1] == "connect" and len(sys.argv) >= 3: vpn.connect(sys.argv[2])
    elif sys.argv[1] == "disconnect" and len(sys.argv) >= 3: vpn.disconnect(sys.argv[2])
    elif sys.argv[1] == "import" and len(sys.argv) >= 3: print(f"Imported: {vpn.import_ovpn(sys.argv[2])}")
