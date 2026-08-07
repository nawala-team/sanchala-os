#!/usr/bin/env python3
"""Sanchala Terminal Config - Advanced Terminal Customization Tool"""

import os, sys, json, shutil
from datetime import datetime
from pathlib import Path

class TerminalConfig:
    def __init__(self):
        self.base_dir = Path(__file__).parent
        self.config_dir = self.base_dir / "config"
        self.themes_dir = self.base_dir / "themes"
        self.profiles_dir = self.base_dir / "profiles"
        self.config_file = self.config_dir / "settings.json"
        for d in [self.config_dir, self.themes_dir, self.profiles_dir]:
            d.mkdir(parents=True, exist_ok=True)
        self.config = self._load_config()
        
    def _load_config(self):
        default = {
            "active_profile": "default", "active_theme": "sanchala-dark",
            "font_family": "monospace", "font_size": 14, "cursor_style": "block",
            "cursor_blink": True, "scrollback_lines": 10000, "bell_enabled": False,
            "transparency": 0.95, "shell": os.environ.get("SHELL", "/bin/bash"),
            "shortcuts": {"copy": "Ctrl+Shift+C", "paste": "Ctrl+Shift+V",
                "new_tab": "Ctrl+Shift+T", "close_tab": "Ctrl+Shift+W",
                "fullscreen": "F11", "zoom_in": "Ctrl+Plus", "zoom_out": "Ctrl+Minus"}
        }
        if self.config_file.exists():
            try:
                with open(self.config_file) as f:
                    return {**default, **json.load(f)}
            except: pass
        return default
        
    def _save_config(self):
        with open(self.config_file, 'w') as f:
            json.dump(self.config, f, indent=2)
            
    def _init_themes(self):
        themes = {
            "sanchala-dark": {"name": "Sanchala Dark", "background": "#1a1a2e",
                "foreground": "#eaeaea", "cursor": "#ff6b6b", "black": "#1a1a2e",
                "red": "#ff6b6b", "green": "#4ade80", "yellow": "#fbbf24",
                "blue": "#60a5fa", "magenta": "#c084fc", "cyan": "#22d3d3", "white": "#eaeaea"},
            "dracula": {"name": "Dracula", "background": "#282a36", "foreground": "#f8f8f2",
                "cursor": "#f8f8f2", "black": "#21222c", "red": "#ff5555", "green": "#50fa7b",
                "yellow": "#f1fa8c", "blue": "#bd93f9", "magenta": "#ff79c6", "cyan": "#8be9fd", "white": "#f8f8f2"},
            "nord": {"name": "Nord", "background": "#2e3440", "foreground": "#d8dee9",
                "cursor": "#d8dee9", "black": "#3b4252", "red": "#bf616a", "green": "#a3be8c",
                "yellow": "#ebcb8b", "blue": "#81a1c1", "magenta": "#b48ead", "cyan": "#88c0d0", "white": "#e5e9f0"}
        }
        for name, theme in themes.items():
            tf = self.themes_dir / f"{name}.json"
            if not tf.exists():
                with open(tf, 'w') as f: json.dump(theme, f, indent=2)
                    
    def list_themes(self):
        self._init_themes()
        print("\n🎨 Available Themes:")
        for tf in sorted(self.themes_dir.glob("*.json")):
            with open(tf) as f: theme = json.load(f)
            act = "✓" if tf.stem == self.config["active_theme"] else " "
            print(f"  [{act}] {tf.stem} - {theme.get('name')}")
            
    def apply_theme(self, name):
        self._init_themes()
        tf = self.themes_dir / f"{name}.json"
        if not tf.exists(): return print(f"❌ Theme '{name}' not found")
        self.config["active_theme"] = name
        self._save_config()
        print(f"✅ Applied theme: {name}")
        
    def list_profiles(self):
        print("\n📋 Profiles:")
        act = "✓" if self.config["active_profile"] == "default" else " "
        print(f"  [{act}] default")
        for pf in sorted(self.profiles_dir.glob("*.json")):
            act = "✓" if pf.stem == self.config["active_profile"] else " "
            print(f"  [{act}] {pf.stem}")
            
    def create_profile(self, name):
        profile = {"name": name, "theme": self.config["active_theme"],
            "font_size": self.config["font_size"], "created": datetime.now().isoformat()}
        with open(self.profiles_dir / f"{name}.json", 'w') as f:
            json.dump(profile, f, indent=2)
        print(f"✅ Created profile: {name}")
        
    def switch_profile(self, name):
        if name != "default" and not (self.profiles_dir / f"{name}.json").exists():
            return print(f"❌ Profile '{name}' not found")
        self.config["active_profile"] = name
        self._save_config()
        print(f"✅ Switched to: {name}")
        
    def show_status(self):
        print("\n🖥️  Terminal Config Status")
        print("=" * 40)
        print(f"  Profile:  {self.config['active_profile']}")
        print(f"  Theme:    {self.config['active_theme']}")
        print(f"  Font:     {self.config['font_family']} @ {self.config['font_size']}px")
        print(f"  Cursor:   {self.config['cursor_style']}")
        print(f"  Shell:    {self.config['shell']}")

def main():
    tc = TerminalConfig()
    if len(sys.argv) < 2: return tc.show_status()
    cmd = sys.argv[1]
    if cmd == "status": tc.show_status()
    elif cmd == "themes": tc.list_themes()
    elif cmd == "theme" and len(sys.argv) > 2: tc.apply_theme(sys.argv[2])
    elif cmd == "profiles": tc.list_profiles()
    elif cmd == "profile" and len(sys.argv) > 2: tc.switch_profile(sys.argv[2])
    elif cmd == "create-profile" and len(sys.argv) > 2: tc.create_profile(sys.argv[2])
    else: print(f"Usage: terminal-config.py [status|themes|theme <n>|profiles|profile <n>|create-profile <n>]")

if __name__ == "__main__": main()
