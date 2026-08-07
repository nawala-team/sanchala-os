# 🔀 Multi-GPU Configuration - Sanchala OS

## Overview

Sanchala OS supports hybrid graphics configurations common in laptops:
- Intel + NVIDIA (Optimus)
- AMD + NVIDIA
- AMD + AMD (rare)

## PRIME Render Offload

Modern approach - discrete GPU renders specific applications while integrated GPU handles display.

### AMD/Intel (Open Source)

```bash
# Run application on discrete GPU
DRI_PRIME=1 application

# Example: Run game on discrete AMD
DRI_PRIME=1 steam

# Check which GPU is being used
DRI_PRIME=1 glxinfo | grep "OpenGL renderer"
```

### NVIDIA (Proprietary)

```bash
# Run application on NVIDIA GPU
__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia application

# Example: Run game on NVIDIA
__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia steam

# For Vulkan applications
__NV_PRIME_RENDER_OFFLOAD=1 __VK_LAYER_NV_optimus=NVIDIA_only application
```

### Desktop Integration

Right-click applications in KDE menu → "Run with discrete GPU"

Or add to `.desktop` file:
```ini
[Desktop Entry]
Name=Game
Exec=env DRI_PRIME=1 /path/to/game
# or for NVIDIA:
Exec=env __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia /path/to/game
```

---

## Power Management

### Runtime PM (Recommended)

Discrete GPU powers down when not in use:

```bash
# Check GPU power state
cat /sys/bus/pci/devices/0000:01:00.0/power/runtime_status

# Should show "suspended" when idle
```

Configured automatically via `/etc/udev/rules.d/70-sanchala-gpu.rules`

### NVIDIA Power Management

For NVIDIA Optimus laptops:

```bash
# Check if GPU is suspended
cat /proc/driver/nvidia/gpus/*/power

# Dynamic power management (RTX 20+)
# Set in /etc/modprobe.d/sanchala-gpu.conf:
# options nvidia NVreg_DynamicPowerManagement=0x02
```

---

## Configuration Files

### Environment Variables

`/etc/environment.d/55-sanchala-multigpu.conf`:
```bash
# Default to integrated GPU
DRI_PRIME=0

# NVIDIA variables set by sanchala-gpu-detect when needed
```

### Checking GPU Configuration

```bash
# List all GPUs
lspci | grep VGA

# Check active GPU
glxinfo | grep "OpenGL renderer"

# Check Vulkan GPUs
vulkaninfo --summary

# Monitor GPU usage
# AMD
radeontop
# Intel
intel_gpu_top
# NVIDIA
nvidia-smi
```

---

## Switching Modes

### On-Demand (Default)

- Integrated GPU for desktop
- Discrete GPU activated per-application
- Best battery life

### Performance Mode

For maximum performance (uses more power):

```bash
# Temporarily use discrete for everything
export DRI_PRIME=1
```

### Power Save Mode

Force integrated GPU only:

```bash
# Disable discrete GPU
echo 'OFF' | sudo tee /sys/kernel/debug/vgaswitcheroo/switch

# Re-enable
echo 'ON' | sudo tee /sys/kernel/debug/vgaswitcheroo/switch
```

---

## Troubleshooting

### Discrete GPU Not Detected

```bash
# Check if GPU is visible
lspci | grep -E "VGA|3D"

# Check driver loaded
lsmod | grep -E "amdgpu|nvidia|i915"

# Check dmesg for errors
dmesg | grep -E "amdgpu|nvidia|i915"
```

### PRIME Not Working

```bash
# Verify render nodes exist
ls /dev/dri/renderD*

# Check GPU permissions
groups $USER  # Should include 'video'
```

### High Battery Drain

Ensure discrete GPU is suspending:
```bash
cat /sys/bus/pci/devices/*/power/runtime_status
# Should show "suspended" for discrete GPU
```
