#!/usr/bin/env python3
"""Sanchala Terminal Config"""
import sys, os, subprocess, json

class TerminalConfig:
    def __init__(self):
        self.config_dir = os.path.expanduser("~/.config/sanchala/terminal")
        os.makedirs(self.config_dir, exist_ok=True)
    
    def set_shell(self, shell):
        subprocess.run(['chsh', '-s', f'/usr/bin/{shell}'])
    
    def get_shell(self):
        return os.environ.get('SHELL', '/bin/bash')
    
    def install_ohmyzsh(self):
        subprocess.run(['sh', '-c', '$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)'])
    
    def install_starship(self):
        subprocess.run(['sh', '-c', 'curl -sS https://starship.rs/install.sh | sh'])
    
    def open_terminal(self):
        for term in ['konsole', 'gnome-terminal', 'alacritty', 'kitty', 'xterm']:
            try: subprocess.Popen([term]); return
            except: continue

if __name__ == "__main__":
    tc = TerminalConfig()
    if len(sys.argv) < 2:
        print(f"Current shell: {tc.get_shell()}")
    elif sys.argv[1] == "shell" and len(sys.argv) >= 3: tc.set_shell(sys.argv[2])
    elif sys.argv[1] == "ohmyzsh": tc.install_ohmyzsh()
    elif sys.argv[1] == "starship": tc.install_starship()
    elif sys.argv[1] == "open": tc.open_terminal()
