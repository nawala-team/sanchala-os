#!/usr/bin/env python3
"""Sanchala FPS Overlay"""
import json
from pathlib import Path

class FPSOverlay:
    CONF = Path.home() / ".config/MangoHud/MangoHud.conf"
    PRESETS = {
        "minimal": {"fps": 1},
        "standard": {"fps": 1, "frametime": 1, "cpu_stats": 1, "gpu_stats": 1},
        "full": {"fps": 1, "frametime": 1, "cpu_stats": 1, "cpu_temp": 1, "gpu_stats": 1, "gpu_temp": 1, "ram": 1}
    }
    
    def __init__(self):
        self.cfg = Path.home() / ".config/sanchala/fps-overlay"
        self.cfg.mkdir(parents=True, exist_ok=True)
        self.CONF.parent.mkdir(parents=True, exist_ok=True)
        self.config = {"enabled": True, "preset": "standard"}
        c = self.cfg / "config.json"
        if c.exists():
            try: self.config.update(json.load(open(c)))
            except: pass
    
    def save(self):
        json.dump(self.config, open(self.cfg / "config.json", "w"), indent=2)
    
    def apply(self, name):
        if name not in self.PRESETS: return False
        self.config["preset"] = name
        lines = ["# Sanchala FPS"]
        for k, v in self.PRESETS[name].items():
            lines.append(k if v == 1 else f"{k}={v}")
        self.CONF.write_text("\n".join(lines))
        self.save()
        return True
    
    def toggle(self):
        self.config["enabled"] = not self.config["enabled"]
        self.save()
        return self.config["enabled"]

def main():
    import argparse
    p = argparse.ArgumentParser()
    sub = p.add_subparsers(dest="cmd")
    sub.add_parser("status")
    sub.add_parser("toggle")
    pp = sub.add_parser("preset")
    pp.add_argument("name", choices=["minimal", "standard", "full"])
    sub.add_parser("list-presets")
    a = p.parse_args()
    o = FPSOverlay()
    if a.cmd == "status":
        print(f"Enabled: {o.config['enabled']}")
        print(f"Preset: {o.config['preset']}")
    elif a.cmd == "toggle":
        print("Overlay: " + ("ON" if o.toggle() else "OFF"))
    elif a.cmd == "preset":
        o.apply(a.name)
        print(f"Applied: {a.name}")
    elif a.cmd == "list-presets":
        for n in o.PRESETS: print(n)
    else:
        p.print_help()

if __name__ == "__main__": main()
