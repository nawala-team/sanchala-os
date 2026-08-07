#!/usr/bin/env python3
"""Sanchala Disk IO - Disk I/O Monitor"""
import sys, os, subprocess, time

class DiskIO:
    def get_stats(self):
        with open('/proc/diskstats') as f:
            stats = {}
            for line in f:
                parts = line.split()
                if len(parts) >= 14:
                    dev = parts[2]
                    if dev.startswith('sd') or dev.startswith('nvme'):
                        stats[dev] = {'reads': int(parts[5]), 'writes': int(parts[9])}
            return stats
    
    def monitor(self, interval=1):
        prev = self.get_stats()
        while True:
            time.sleep(interval)
            curr = self.get_stats()
            print("\033[2J\033[H")
            print(f"{'Device':<15} {'Read/s':<15} {'Write/s':<15}")
            print("-" * 45)
            for dev in curr:
                if dev in prev:
                    reads = (curr[dev]['reads'] - prev[dev]['reads']) * 512 / interval / 1024
                    writes = (curr[dev]['writes'] - prev[dev]['writes']) * 512 / interval / 1024
                    print(f"{dev:<15} {reads:>10.1f} KB  {writes:>10.1f} KB")
            prev = curr
    
    def benchmark(self, path):
        subprocess.run(['fio', '--name=test', '--rw=randread', '--bs=4k', '--size=100M', f'--directory={path}', '--runtime=10'])

if __name__ == "__main__":
    dio = DiskIO()
    if len(sys.argv) < 2 or sys.argv[1] == "monitor": dio.monitor()
    elif sys.argv[1] == "stats":
        for dev, s in dio.get_stats().items(): print(f"{dev}: R={s['reads']} W={s['writes']}")
    elif sys.argv[1] == "benchmark" and len(sys.argv) >= 3: dio.benchmark(sys.argv[2])
