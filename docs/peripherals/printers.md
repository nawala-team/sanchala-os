# Sanchala OS - Printer Setup Guide

Comprehensive guide for setting up and troubleshooting printers.

## Quick Start

### USB Printers
1. Connect printer via USB
2. Power on the printer
3. Open System Settings → Printers
4. Printer should appear automatically
5. Print a test page

### Network Printers
1. Ensure printer is on the same network
2. Open System Settings → Printers
3. Click "Add Printer"
4. Select discovered printer or enter IP manually
5. Follow the wizard

---

## Printer Types & Setup

### IPP Everywhere (Driverless)

Most modern printers support IPP Everywhere / AirPrint:

```bash
# Discover IPP printers
ippfind

# Add IPP printer
lpadmin -p MyPrinter -E -v ipp://192.168.1.100:631/ipp/print -m everywhere
```

### HP Printers

HP printers have the best Linux support:

```bash
# Interactive setup
hp-setup

# Automated setup (USB)
hp-setup -i -a

# Network setup
hp-setup -i 192.168.1.100
```

**HP Toolbox** for maintenance:
```bash
hp-toolbox
```

### Brother Printers

Brother provides official Linux drivers:

1. Download from [Brother Support](https://support.brother.com)
2. Install the driver package:
```bash
# For .deb (convert with debtap)
debtap brother-driver.deb
sudo pacman -U brother-driver.pkg.tar.zst
```

### Canon Printers

Canon provides cnijfilter drivers:

```bash
# From AUR
yay -S cnijfilter2
```

### Epson Printers

Epson provides escpr drivers:

```bash
# From AUR
yay -S epson-inkjet-printer-escpr2
```

---

## CUPS Configuration

### Web Interface

Full printer management at: **http://localhost:631**

### Command Line Management

```bash
# List all printers
lpstat -p -d

# Set default printer
lpoptions -d PrinterName

# Print a file
lp -d PrinterName document.pdf

# Print with options
lp -d PrinterName -o sides=two-sided-long-edge document.pdf

# Cancel all jobs
cancel -a PrinterName

# Remove a printer
lpadmin -x PrinterName
```

### Print Options

Common print options:

| Option | Values | Description |
|--------|--------|-------------|
| `media` | A4, Letter, Legal | Paper size |
| `sides` | one-sided, two-sided-long-edge, two-sided-short-edge | Duplex |
| `copies` | 1-999 | Number of copies |
| `print-quality` | 3 (draft), 4 (normal), 5 (high) | Quality |
| `ColorModel` | Gray, RGB | Color mode |

```bash
# Example: Print 2 copies, double-sided, grayscale
lp -d MyPrinter -o copies=2 -o sides=two-sided-long-edge -o ColorModel=Gray document.pdf
```

---

## Network Printer Discovery

### Avahi/mDNS (Bonjour)

Most network printers advertise via mDNS:

```bash
# Browse for printers
avahi-browse -rt _ipp._tcp
avahi-browse -rt _ipps._tcp
avahi-browse -rt _printer._tcp

# Check avahi status
systemctl status avahi-daemon
```

### Manual Network Setup

If auto-discovery fails:

```bash
# Find printer IP (check router or printer display)
# Add printer manually
lpadmin -p NetworkPrinter -E \
    -v ipp://192.168.1.100:631/ipp/print \
    -m everywhere \
    -L "Office" \
    -D "Office Network Printer"
```

---

## Print to PDF

### Using CUPS-PDF

Print to PDF from any application:

1. Select "Print to PDF (CUPS-PDF)" as printer
2. Click Print
3. PDF saved to `~/Documents/PDF/`

### Configuration

Edit `/etc/cups/cups-pdf.conf`:

```conf
# Change output directory
Out ${HOME}/PDFs

# Change resolution
Resolution 600

# PDF version
PDFVer 1.7
```

---

## Troubleshooting

### Printer Not Found

```bash
# Check USB connection
lsusb

# Check CUPS service
systemctl status cups

# Check for driver
lpinfo -m | grep -i "printer-model"

# Restart services
sudo systemctl restart cups avahi-daemon cups-browsed
```

### Print Jobs Stuck

```bash
# View queue
lpstat -o

# Cancel specific job
cancel job-id

# Cancel all jobs for printer
cancel -a PrinterName

# Clear entire queue
lprm -

# Restart CUPS
sudo systemctl restart cups
```

### Permission Denied

```bash
# Add user to lp group
sudo usermod -aG lp $USER

# Log out and back in
```

### Driver Issues

```bash
# List available drivers
lpinfo -m | less

# Use generic driver
lpadmin -p PrinterName -m drv:///sample.drv/generic.ppd

# Use driverless/IPP Everywhere
lpadmin -p PrinterName -m everywhere
```

### CUPS Error Log

```bash
# View recent errors
tail -100 /var/log/cups/error_log

# Follow log in real-time
tail -f /var/log/cups/error_log

# Increase log verbosity
sudo cupsctl --debug-logging
# Remember to disable after debugging:
sudo cupsctl --no-debug-logging
```

---

## Sharing Printers

### Share on Local Network

1. Edit `/etc/cups/cupsd.conf`:
```conf
# Change listening
Listen *:631

# Enable browsing
Browsing On
BrowseLocalProtocols dnssd

# Allow network access
<Location />
  Order allow,deny
  Allow @LOCAL
</Location>
```

2. Restart CUPS:
```bash
sudo systemctl restart cups
```

3. Open firewall:
```bash
sudo firewall-cmd --add-service=ipp --permanent
sudo firewall-cmd --reload
```

### Access Shared Printer

On client machines, the shared printer appears automatically via Avahi.

Manual addition:
```bash
lpadmin -p SharedPrinter -E -v ipp://server.local:631/printers/PrinterName -m everywhere
```

---

## Common Issues by Brand

### HP

| Issue | Solution |
|-------|----------|
| Plugin required | Run `hp-plugin` |
| Wireless setup | Use `hp-setup` wizard |
| Ink levels wrong | Install `hplip-plugin` |

### Brother

| Issue | Solution |
|-------|----------|
| Driver not found | Install from AUR or Brother website |
| Wireless issues | Use Brother's brscan tool |

### Canon

| Issue | Solution |
|-------|----------|
| No driver | Install `cnijfilter2` from AUR |
| Scanning fails | Install `scangearmp2` |

### Epson

| Issue | Solution |
|-------|----------|
| No driver | Install `epson-inkjet-printer-escpr2` |
| Network scan | Configure in Epson Scan 2 |
