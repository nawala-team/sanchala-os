#!/usr/bin/env python3
"""Sanchala Clipboard Sync - Sync Clipboard Across Devices"""
import sys, os, json, socket, threading

class ClipboardSync:
    def __init__(self, port=9876):
        self.port = port
        self.config_dir = os.path.expanduser("~/.config/sanchala/clipboard-sync")
        os.makedirs(self.config_dir, exist_ok=True)
    
    def start_server(self):
        server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        server.bind(('0.0.0.0', self.port))
        server.listen(5)
        print(f"Clipboard sync server on port {self.port}")
        while True:
            client, addr = server.accept()
            data = client.recv(65536).decode()
            os.system(f"echo -n '{data}' | xclip -selection clipboard")
            print(f"Received from {addr[0]}")
            client.close()
    
    def send(self, host, text):
        client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        client.connect((host, self.port))
        client.send(text.encode())
        client.close()

if __name__ == "__main__":
    cs = ClipboardSync()
    if len(sys.argv) < 2:
        print("Sanchala Clipboard Sync")
        print("Usage: sanchala-clipboard-sync [server|send HOST TEXT]")
    elif sys.argv[1] == "server": cs.start_server()
    elif sys.argv[1] == "send" and len(sys.argv) >= 4: cs.send(sys.argv[2], ' '.join(sys.argv[3:])); print("Sent!")
