#!/usr/bin/env python3
"""Sanchala Disk IO - Disk I/O Monitor & Benchmark"""

import os, sys, json, time, subprocess
from datetime import datetime
from pathlib import Path

class DiskIO:
    def __init__(self):
        self.base_dir = Path(__file__).parent
        self.config_dir = self.base_dir / "config"
        self.logs_dir = self.base_dir / "logs"
        self.bench_dir = self.base_dir / "benchmarks"
        for d in [self.config_dir, self.logs_dir, self.bench_dir]:
            d.mkdir(parents=True, exist_ok=True)
            
    def disk_usage(self):
        print("\n💾 Disk Usage:")
        print(f"{'MOUNT':<25} {'SIZE':<10} {'USED':<10} {'AVAIL':<10} {'USE%'}")
        print("-" * 65)
        try:
            result = subprocess.run(["df", "-h"], capture_output=True, text=True)
            for line in result.stdout.strip().split('\n')[1:]:
                parts = line.split()
                if len(parts) >= 6:
                    mount, size, used, avail, pct = parts[5], parts[1], parts[2], parts[3], parts[4]
                    print(f"{mount:<25} {size:<10} {used:<10} {avail:<10} {pct}")
        except Exception as e:
            print(f"⚠️  Error: {e}")
            
    def io_stats(self):
        print("\n📊 I/O Statistics:")
        try:
            with open("/proc/diskstats") as f:
                print(f"{'DEVICE':<12} {'READS':<12} {'WRITES':<12}")
                print("-" * 40)
                for line in f:
                    parts = line.split()
                    if len(parts) >= 14:
                        dev, reads, writes = parts[2], parts[3], parts[7]
                        if not dev.startswith(('loop', 'ram', 'dm-')):
                            print(f"{dev:<12} {reads:<12} {writes:<12}")
        except Exception as e:
            print(f"⚠️  Error: {e}")
            
    def benchmark(self, size_mb=100):
        print(f"\n🏃 Disk Benchmark ({size_mb}MB)")
        print("=" * 40)
        test_file = self.bench_dir / "benchmark.tmp"
        data = os.urandom(1024 * 1024)  # 1MB chunk
        
        # Write test
        print("  Write test...", end=" ", flush=True)
        start = time.time()
        with open(test_file, 'wb') as f:
            for _ in range(size_mb):
                f.write(data)
            f.flush()
            os.fsync(f.fileno())
        write_time = time.time() - start
        write_speed = size_mb / write_time
        print(f"{write_speed:.1f} MB/s")
        
        # Read test
        print("  Read test...", end=" ", flush=True)
        start = time.time()
        with open(test_file, 'rb') as f:
            while f.read(1024 * 1024): pass
        read_time = time.time() - start
        read_speed = size_mb / read_time
        print(f"{read_speed:.1f} MB/s")
        
        test_file.unlink()
        
        result = {"date": datetime.now().isoformat(), "size_mb": size_mb,
                  "write_mbs": round(write_speed, 2), "read_mbs": round(read_speed, 2)}
        log_file = self.bench_dir / f"bench-{datetime.now().strftime('%Y%m%d-%H%M%S')}.json"
        with open(log_file, 'w') as f: json.dump(result, f, indent=2)
        print(f"\n✅ Results saved: {log_file.name}")
        
    def monitor(self, interval=2):
        print("📈 I/O Monitor (Ctrl+C to stop)")
        try:
            while True:
                os.system('clear')
                self.disk_usage()
                self.io_stats()
                print(f"\n  Updated: {datetime.now().strftime('%H:%M:%S')}")
                time.sleep(interval)
        except KeyboardInterrupt:
            print("\n⏹️  Stopped")

def main():
    dio = DiskIO()
    if len(sys.argv) < 2: return dio.disk_usage()
    cmd = sys.argv[1]
    if cmd == "usage": dio.disk_usage()
    elif cmd == "stats": dio.io_stats()
    elif cmd == "bench": dio.benchmark(int(sys.argv[2]) if len(sys.argv) > 2 else 100)
    elif cmd == "monitor": dio.monitor()
    else: print("Usage: disk-io.py [usage|stats|bench <mb>|monitor]")

if __name__ == "__main__": main()
