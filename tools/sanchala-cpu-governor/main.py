#!/usr/bin/env python3
"""Sanchala CPU Governor - CPU Frequency Scaling"""
import sys, os, glob

class CPUGovernor:
    GOVERNORS = ['performance', 'powersave', 'ondemand', 'conservative', 'schedutil']
    
    def get_current(self):
        try:
            with open('/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor') as f:
                return f.read().strip()
        except: return None
    
    def set_governor(self, gov):
        cpus = glob.glob('/sys/devices/system/cpu/cpu*/cpufreq/scaling_governor')
        for cpu in cpus:
            os.system(f"echo {gov} | sudo tee {cpu}")
    
    def get_frequency(self):
        try:
            with open('/sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq') as f:
                return int(f.read().strip()) // 1000
        except: return 0
    
    def get_available(self):
        try:
            with open('/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors') as f:
                return f.read().strip().split()
        except: return self.GOVERNORS

if __name__ == "__main__":
    cg = CPUGovernor()
    if len(sys.argv) < 2:
        print(f"Current: {cg.get_current()}, Freq: {cg.get_frequency()} MHz")
        print(f"Available: {', '.join(cg.get_available())}")
        print("Usage: sanchala-cpu-governor [set GOVERNOR]")
    elif sys.argv[1] == "set" and len(sys.argv) >= 3:
        cg.set_governor(sys.argv[2]); print(f"Set to {sys.argv[2]}")
