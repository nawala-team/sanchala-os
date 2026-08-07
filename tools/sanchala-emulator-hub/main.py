#!/usr/bin/env python3
"""Sanchala Emulator Hub - Gaming Emulators"""
import sys, os, subprocess

class EmulatorHub:
    EMULATORS = {'nes': 'fceux', 'snes': 'snes9x-gtk', 'gba': 'mgba-qt', 'nds': 'desmume', 'n64': 'mupen64plus', 'ps1': 'duckstation', 'ps2': 'pcsx2', 'psp': 'ppsspp', 'gc': 'dolphin-emu', 'wii': 'dolphin-emu', 'switch': 'yuzu'}
    
    def __init__(self):
        self.roms_dir = os.path.expanduser("~/Games/ROMs")
        os.makedirs(self.roms_dir, exist_ok=True)
    
    def launch(self, platform, rom=None):
        emu = self.EMULATORS.get(platform.lower())
        if not emu: return False
        cmd = [emu]
        if rom: cmd.append(rom)
        try: subprocess.Popen(cmd); return True
        except: return False
    
    def list_roms(self, platform=None):
        roms = []
        search_dir = os.path.join(self.roms_dir, platform) if platform else self.roms_dir
        if os.path.exists(search_dir):
            for f in os.listdir(search_dir):
                if not f.startswith('.'): roms.append(f)
        return roms
    
    def open_retroarch(self):
        subprocess.Popen(['retroarch'])

if __name__ == "__main__":
    eh = EmulatorHub()
    if len(sys.argv) < 2:
        print("Sanchala Emulator Hub")
        print(f"Platforms: {', '.join(EmulatorHub.EMULATORS.keys())}")
    elif sys.argv[1] == "launch" and len(sys.argv) >= 3:
        rom = sys.argv[3] if len(sys.argv) > 3 else None
        eh.launch(sys.argv[2], rom)
    elif sys.argv[1] == "roms": [print(f"  {r}") for r in eh.list_roms(sys.argv[2] if len(sys.argv) > 2 else None)]
    elif sys.argv[1] == "retroarch": eh.open_retroarch()
