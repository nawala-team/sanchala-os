# Network Diagnostics

Comprehensive network troubleshooting and monitoring tools for Sanchala OS.

## Quick Commands

```bash
# Network overview
sanchala-diagnostics network

# Test connectivity
sanchala-diagnostics ping google.com

# Trace network path
sanchala-diagnostics traceroute 8.8.8.8

# Check DNS
sanchala-diagnostics dns

# View connections
sanchala-diagnostics connections

# Check open ports
sanchala-diagnostics ports
```

## Network Interface Status

```bash
$ sanchala-diagnostics network

═══ NETWORK INTERFACES ═══
1: lo: <LOOPBACK,UP> mtu 65536
    inet 127.0.0.1/8

2: enp0s3: <BROADCAST,UP> mtu 1500
    inet 192.168.1.100/24

3: wlan0: <BROADCAST,UP> mtu 1500
    inet 192.168.1.101/24

═══ ROUTING TABLE ═══
default via 192.168.1.1 dev enp0s3
192.168.1.0/24 dev enp0s3 proto kernel

═══ DNS SERVERS ═══
nameserver 192.168.1.1
nameserver 8.8.8.8
```

## Connectivity Testing

### Ping Test
```bash
# Default (5 packets to 8.8.8.8)
sanchala-diagnostics ping

# Custom host
sanchala-diagnostics ping google.com

# With count
sanchala-diagnostics ping cloudflare.com 10
```

### Traceroute
```bash
# Trace path to destination
sanchala-diagnostics traceroute google.com

# Uses mtr if available for better output
```

## DNS Diagnostics

```bash
$ sanchala-diagnostics dns

═══ DNS CONFIGURATION ═══
nameserver 192.168.1.1
nameserver 8.8.8.8
search home.lan

═══ DNS RESOLUTION TEST ═══
✓ google.com → 142.250.185.78
✓ cloudflare.com → 104.16.132.229
✓ sanchala.id → 185.199.108.153
```

### Manual DNS Tests
```bash
# Query specific DNS server
dig @8.8.8.8 google.com

# Reverse lookup
dig -x 8.8.8.8

# Check all records
dig google.com ANY
```

## Connection Monitoring

### Active Connections
```bash
$ sanchala-diagnostics connections

State    Local Address:Port    Remote Address:Port    Process
ESTAB    192.168.1.100:43210  142.250.185.78:443    firefox
ESTAB    192.168.1.100:22     192.168.1.50:52341    sshd
TIME-WAIT 192.168.1.100:35000  ...
```

### Listening Ports
```bash
$ sanchala-diagnostics ports

Proto  Local Address    Port   Process
tcp    0.0.0.0          22     sshd
tcp    127.0.0.1        631    cupsd
tcp6   :::              80     nginx
udp    0.0.0.0          68     dhclient
```

## Bandwidth Monitoring

```bash
# Current bandwidth usage
sanchala-diagnostics bandwidth

# Real-time with vnstat (if installed)
vnstat -l

# Per-interface statistics
cat /proc/net/dev
```

## Speed Testing

```bash
$ sanchala-diagnostics speed

═══ INTERNET SPEED TEST ═══
Download test (10MB file)...
Download: ~45 MB/s

# For accurate results, install speedtest-cli
sudo pacman -S speedtest-cli
speedtest-cli
```

## Common Issues

### No Network Connection

```bash
# Check interface status
ip link show

# Bring interface up
sudo ip link set enp0s3 up

# Request DHCP
sudo dhclient enp0s3

# Check NetworkManager
nmcli device status
nmcli connection show
```

### DNS Not Resolving

```bash
# Test direct IP connectivity
ping 8.8.8.8

# If ping works but DNS doesn't:
# Check /etc/resolv.conf
cat /etc/resolv.conf

# Test with different DNS
dig @1.1.1.1 google.com

# Flush DNS cache
sudo systemd-resolve --flush-caches
```

### Slow Connection

```bash
# Check for packet loss
ping -c 100 google.com | grep loss

# Check latency to gateway
ping -c 10 $(ip route | awk '/default/ {print $3}')

# Monitor bandwidth usage
iftop  # requires: sudo pacman -S iftop
```

### Port Blocked

```bash
# Check if port is listening locally
ss -tlnp | grep :80

# Test remote port
nc -zv hostname 80

# Check firewall
sudo iptables -L -n
sudo firewall-cmd --list-all
```

## Network Tools Reference

| Tool | Purpose | Install |
|------|---------|---------|
| `ip` | Interface management | iproute2 (included) |
| `ss` | Socket statistics | iproute2 (included) |
| `ping` | Connectivity test | iputils (included) |
| `dig` | DNS queries | bind-tools |
| `traceroute` | Path tracing | traceroute |
| `mtr` | Combined ping/traceroute | mtr |
| `nmap` | Port scanning | nmap |
| `tcpdump` | Packet capture | tcpdump |
| `wireshark` | GUI packet analysis | wireshark-qt |
| `iftop` | Bandwidth monitor | iftop |
| `vnstat` | Traffic statistics | vnstat |
| `speedtest-cli` | Speed testing | speedtest-cli |

## Firewall Configuration

### Check Status
```bash
# Using firewalld
sudo firewall-cmd --state
sudo firewall-cmd --list-all

# Using iptables
sudo iptables -L -n -v
```

### Open Port
```bash
# Firewalld
sudo firewall-cmd --add-port=8080/tcp --permanent
sudo firewall-cmd --reload

# iptables
sudo iptables -A INPUT -p tcp --dport 8080 -j ACCEPT
```

## See Also

- [Diagnostics Overview](DIAGNOSTICS.md)
- [Network Configuration](../network/NETWORK.md)
- [Firewall Guide](../security/FIREWALL.md)
