#!/usr/bin/env python3
"""Sanchala Continuity - Device Handoff & Continuity"""
import sys, os, json, socket, threading

class Continuity:
    def __init__(self, port=8888):
        self.port = port
        self.config_dir = os.path.expanduser("~/.config/sanchala/continuity")
        self.devices_file = os.path.join(self.config_dir, "devices.json")
        os.makedirs(self.config_dir, exist_ok=True)
    
    def discover_devices(self):
        # Simple LAN discovery
        devices = []
        local_ip = socket.gethostbyname(socket.gethostname())
        subnet = '.'.join(local_ip.split('.')[:-1])
        for i in range(1, 255):
            try:
                s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                s.settimeout(0.1)
                if s.connect_ex((f"{subnet}.{i}", self.port)) == 0:
                    devices.append(f"{subnet}.{i}")
                s.close()
            except: pass
        return devices
    
    def handoff(self, device_ip, data):
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.connect((device_ip, self.port))
        s.send(json.dumps(data).encode())
        s.close()
    
    def listen(self):
        server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        server.bind(('0.0.0.0', self.port))
        server.listen(1)
        print(f"Listening on port {self.port}...")
        while True:
            client, addr = server.accept()
            data = json.loads(client.recv(65536).decode())
            print(f"Handoff from {addr[0]}: {data}")

if __name__ == "__main__":
    c = Continuity()
    if len(sys.argv) < 2:
        print("Sanchala Continuity")
        print("Usage: sanchala-continuity [discover|listen|handoff IP DATA]")
    elif sys.argv[1] == "discover":
        print("Discovering devices...")
        for d in c.discover_devices(): print(f"  {d}")
    elif sys.argv[1] == "listen": c.listen()
    elif sys.argv[1] == "handoff" and len(sys.argv) >= 4: c.handoff(sys.argv[2], {'data': sys.argv[3]})
