# Sanchala OS - USB Devices Guide

Complete guide for USB device support including storage, phones, controllers, and development boards.

## USB Storage

### Automatic Mounting

USB drives mount automatically under `/run/media/username/`.

```bash
# List mounted drives
lsblk

# Safely eject
udisksctl unmount -b /dev/sdb1
udisksctl power-off -b /dev/sdb

# Or in Dolphin: Right-click → Safely Remove
```

### Supported Filesystems

| Filesystem | Support | Notes |
|------------|---------|-------|
| ext4 | ✅ Native | Full permissions |
| NTFS | ✅ Full | Via ntfs-3g |
| exFAT | ✅ Full | Via exfatprogs |
| FAT32 | ✅ Full | Universal compatibility |
| BTRFS | ✅ Native | Snapshots supported |
| HFS+ | ⚠️ Read-only | macOS format |
| APFS | ❌ No | Use different format |

---

## Android Phones (MTP)

### Automatic Access

1. Connect phone via USB
2. On phone: Select "File Transfer" mode
3. Phone appears in Dolphin sidebar

### Command Line Access

```bash
# Mount MTP device
jmtpfs ~/phone

# Browse files
ls ~/phone

# Unmount
fusermount -u ~/phone
```

### Troubleshooting MTP

```bash
# Check MTP detection
mtp-detect

# Restart gvfs
systemctl --user restart gvfs-daemon
```

---

## Game Controllers

### Supported Controllers

| Controller | Connection | Status |
|------------|------------|--------|
| Xbox One/Series | USB/Wireless | ✅ Native |
| PlayStation 4 | USB/Bluetooth | ✅ Native |
| PlayStation 5 | USB/Bluetooth | ✅ Native |
| Nintendo Switch Pro | USB/Bluetooth | ✅ Native |
| Steam Controller | USB/Wireless | ✅ Native |
| 8BitDo | USB/Bluetooth | ✅ Native |

### Testing Controllers

```bash
# List input devices
cat /proc/bus/input/devices | grep -A5 "Controller"

# Test with jstest
jstest /dev/input/js0

# GUI testing
jstest-gtk
```

### Steam Controller

```bash
# Ensure steam-devices is installed
pacman -Q steam-devices

# Controller works in Steam and via sc-controller for desktop use
```

---

## Serial Devices & Development

### Arduino / Microcontrollers

Serial access works without root:

```bash
# List serial ports  
ls /dev/ttyUSB* /dev/ttyACM*

# Connect to Arduino
picocom /dev/ttyUSB0 -b 115200

# Or with screen
screen /dev/ttyUSB0 115200

# Exit picocom: Ctrl+A, Ctrl+X
# Exit screen: Ctrl+A, K, Y
```

### Arduino CLI

```bash
# List connected boards
arduino-cli board list

# Compile sketch
arduino-cli compile --fqbn arduino:avr:uno MySketch

# Upload
arduino-cli upload -p /dev/ttyUSB0 --fqbn arduino:avr:uno MySketch
```

### ESP32/ESP8266

```bash
# Install esptool
pip install esptool

# Flash firmware
esptool.py --port /dev/ttyUSB0 write_flash 0x0 firmware.bin
```

---

## Graphics Tablets

### Wacom Tablets

```bash
# List tablets
xsetwacom list devices

# Configure pressure curve
xsetwacom set "Wacom Intuos Pro M Pen stylus" PressureCurve 0 25 75 100

# Map to specific monitor
xsetwacom set "Wacom Intuos Pro M Pen stylus" MapToOutput HDMI-1
```

### Huion/XP-Pen

Most work via the DIGImend driver (included):

```bash
# Check detection
xinput list | grep -i tablet
```

---

## USB Audio

### Automatic Configuration

USB audio interfaces are auto-configured by PipeWire:

```bash
# List audio devices
wpctl status

# Set default output
wpctl set-default <device-id>
```

### Pro Audio (Low Latency)

```bash
# Check realtime privileges
ulimit -r

# Add user to realtime group
sudo usermod -aG realtime $USER
```

---

## Security Keys

### YubiKey

```bash
# Test YubiKey
ykman info

# Configure for FIDO2
ykman fido credentials list
```

### Generic FIDO2

```bash
# Test FIDO2 key
fido2-token -L
```

---

## Troubleshooting

### Device Not Detected

```bash
# Check USB connection
lsusb

# Check kernel messages
dmesg | tail -20

# Reload udev rules
sudo udevadm control --reload-rules
sudo udevadm trigger
```

### Permission Denied

```bash
# Check your groups
groups

# Add to required groups
sudo usermod -aG dialout,uucp,input,plugdev $USER

# Log out and back in
```

### Device Works Intermittently

```bash
# Check USB power management
cat /sys/bus/usb/devices/*/power/control

# Disable autosuspend for specific device
echo on | sudo tee /sys/bus/usb/devices/1-2/power/control
```
