#!/usr/bin/env python3
"""Sanchala Task Manager - Process & System Monitor"""

import os, sys, json, subprocess
from datetime import datetime
from pathlib import Path

class TaskManager:
    def __init__(self):
        self.base_dir = Path(__file__).parent
        self.config_dir = self.base_dir / "config"
        self.logs_dir = self.base_dir / "logs"
        for d in [self.config_dir, self.logs_dir]:
            d.mkdir(parents=True, exist_ok=True)
            
    def list_processes(self, filter_str=None):
        print("\n📊 Running Processes:")
        print(f"{'PID':<8} {'CPU%':<6} {'MEM%':<6} {'STATE':<6} {'COMMAND':<40}")
        print("-" * 70)
        try:
            result = subprocess.run(["ps", "aux"], capture_output=True, text=True)
            lines = result.stdout.strip().split('\n')[1:]
            for line in lines[:30]:
                parts = line.split(None, 10)
                if len(parts) >= 11:
                    pid, cpu, mem, stat, cmd = parts[1], parts[2], parts[3], parts[7], parts[10][:40]
                    if filter_str and filter_str.lower() not in line.lower(): continue
                    print(f"{pid:<8} {cpu:<6} {mem:<6} {stat:<6} {cmd}")
        except Exception as e:
            print(f"⚠️  Error: {e}")
            
    def kill_process(self, pid, force=False):
        signal = "-9" if force else "-15"
        try:
            subprocess.run(["kill", signal, str(pid)], check=True)
            print(f"✅ Killed process {pid}")
        except Exception as e:
            print(f"❌ Failed to kill {pid}: {e}")
            
    def system_info(self):
        print("\n💻 System Information:")
        print("=" * 40)
        try:
            # CPU info
            with open("/proc/cpuinfo") as f:
                for line in f:
                    if "model name" in line:
                        print(f"  CPU: {line.split(':')[1].strip()}")
                        break
            # Memory
            with open("/proc/meminfo") as f:
                for line in f:
                    if line.startswith(("MemTotal", "MemFree", "MemAvailable")):
                        print(f"  {line.strip()}")
            # Load average
            with open("/proc/loadavg") as f:
                load = f.read().split()[:3]
                print(f"  Load: {' '.join(load)}")
            # Uptime
            with open("/proc/uptime") as f:
                uptime = float(f.read().split()[0])
                hours = int(uptime // 3600)
                mins = int((uptime % 3600) // 60)
                print(f"  Uptime: {hours}h {mins}m")
        except Exception as e:
            print(f"⚠️  Limited info: {e}")
            
    def top_processes(self, count=10):
        print(f"\n🔝 Top {count} Processes by CPU:")
        try:
            result = subprocess.run(["ps", "aux", "--sort=-%cpu"], capture_output=True, text=True)
            lines = result.stdout.strip().split('\n')
            print(lines[0])
            for line in lines[1:count+1]:
                print(line)
        except:
            self.list_processes()
            
    def monitor(self, interval=2):
        print("📈 Live Monitor (Ctrl+C to stop)")
        import time
        try:
            while True:
                os.system('clear')
                self.system_info()
                self.top_processes(5)
                time.sleep(interval)
        except KeyboardInterrupt:
            print("\n⏹️  Monitor stopped")

def main():
    tm = TaskManager()
    if len(sys.argv) < 2: return tm.list_processes()
    cmd = sys.argv[1]
    if cmd == "ps": tm.list_processes(sys.argv[2] if len(sys.argv) > 2 else None)
    elif cmd == "kill" and len(sys.argv) > 2: tm.kill_process(sys.argv[2], "-f" in sys.argv)
    elif cmd == "info": tm.system_info()
    elif cmd == "top": tm.top_processes(int(sys.argv[2]) if len(sys.argv) > 2 else 10)
    elif cmd == "monitor": tm.monitor()
    else: print("Usage: task-manager.py [ps|kill <pid>|info|top|monitor]")

if __name__ == "__main__": main()
