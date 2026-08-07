#!/usr/bin/env python3
"""Sanchala Boot Sound - Startup Sound Manager"""
import sys, os, subprocess, shutil

class BootSound:
    def __init__(self):
        self.config_dir = os.path.expanduser("~/.config/sanchala/boot-sound")
        self.sound_file = os.path.join(self.config_dir, "boot.wav")
        self.autostart = os.path.expanduser("~/.config/autostart/sanchala-boot-sound.desktop")
        os.makedirs(self.config_dir, exist_ok=True)
    
    def set_sound(self, sound_path):
        shutil.copy(sound_path, self.sound_file)
        return True
    
    def play(self):
        if os.path.exists(self.sound_file):
            subprocess.Popen(['paplay', self.sound_file])
            return True
        return False
    
    def enable(self):
        os.makedirs(os.path.dirname(self.autostart), exist_ok=True)
        with open(self.autostart, 'w') as f:
            f.write(f"""[Desktop Entry]
Type=Application
Name=Sanchala Boot Sound
Exec=sanchala-boot-sound play
X-GNOME-Autostart-enabled=true
""")
        return True
    
    def disable(self):
        if os.path.exists(self.autostart):
            os.remove(self.autostart)
        return True
    
    def status(self):
        return {"enabled": os.path.exists(self.autostart), "sound_set": os.path.exists(self.sound_file)}

if __name__ == "__main__":
    bs = BootSound()
    if len(sys.argv) < 2:
        print("Sanchala Boot Sound")
        print("Usage: sanchala-boot-sound [play|set FILE|enable|disable|status]")
    elif sys.argv[1] == "play": bs.play()
    elif sys.argv[1] == "set" and len(sys.argv) >= 3:
        bs.set_sound(sys.argv[2]); print(f"Sound set to {sys.argv[2]}")
    elif sys.argv[1] == "enable": bs.enable(); print("Boot sound enabled")
    elif sys.argv[1] == "disable": bs.disable(); print("Boot sound disabled")
    elif sys.argv[1] == "status":
        s = bs.status()
        print(f"Enabled: {s['enabled']}, Sound configured: {s['sound_set']}")
