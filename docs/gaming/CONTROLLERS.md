# Controller Setup Guide

## Supported Controllers

| Controller | Driver | Status |
|------------|--------|--------|
| Xbox (USB/Wireless) | xpad/xpadneo | ✓ Full support |
| Xbox Elite | xpadneo | ✓ Full support |
| DualShock 4 | hid-sony | ✓ Full support |
| DualSense (PS5) | hid-playstation | ✓ Full support |
| Switch Pro | hid-nintendo | ✓ Full support |
| Joy-Con | hid-nintendo | ✓ Full support |
| 8BitDo | hid-generic | ✓ Full support |
| Steam Controller | Steam | ✓ Via Steam |

## Check Controller Status

```bash
sanchala-gaming controllers
```

## Xbox Controllers

### Wireless (Bluetooth)

Install xpadneo for better wireless support:

```bash
sudo pacman -S xpadneo-dkms
```

Features: battery reporting, rumble, trigger rumble

### Xbox Wireless Adapter

```bash
sudo pacman -S xone-dkms
```

## PlayStation Controllers

### DualShock 4

Works out of the box. Additional features:

```bash
# LED color (requires ds4drv)
ds4drv --led 0000ff
```

### DualSense (PS5)

Full support including:
- Adaptive triggers
- Haptic feedback
- Touchpad
- LED control

```bash
# Install control utility
sudo pacman -S dualsensectl

# Set LED color
dualsensectl lightbar 0 0 255

# Check battery
dualsensectl battery

# Set player LED
dualsensectl player-leds 1
```

## Nintendo Controllers

### Switch Pro Controller

Works via Bluetooth or USB automatically.

### Joy-Con

```bash
# Pair via Bluetooth
# Hold sync button until lights flash

# Combine Joy-Cons
# Steam Input handles this automatically
```

## Steam Input

Steam Input provides the best controller experience:

1. **Steam → Settings → Controller**
2. Enable for each controller type
3. Use **Desktop Configuration** for non-game use

### Non-Steam Games

1. Add game to Steam library
2. Launch through Steam
3. Steam Input applies automatically

## Troubleshooting

### Controller Not Detected

```bash
# Reload udev rules
sudo udevadm control --reload
sudo udevadm trigger

# Check device
ls -la /dev/input/js*

# Test input
jstest /dev/input/js0
```

### Wrong Button Mapping

Use `antimicrox` for custom mapping:

```bash
sudo pacman -S antimicrox
antimicrox
```

### Bluetooth Issues

```bash
# Restart Bluetooth
sudo systemctl restart bluetooth

# Re-pair controller
bluetoothctl
> remove <MAC>
> scan on
> pair <MAC>
> trust <MAC>
> connect <MAC>
```
