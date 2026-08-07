# 🔧 Graphics Troubleshooting - Sanchala OS

## Common Issues

### No GPU Acceleration

**Symptoms:** Slow desktop, no effects, software rendering

**Diagnosis:**
```bash
# Check GPU detected
lspci -k | grep -A 3 VGA

# Check OpenGL renderer
glxinfo | grep "OpenGL renderer"
# Should NOT say "llvmpipe" or "software"

# Check DRM devices exist
ls -la /dev/dri/
```

**Solutions:**
1. Ensure correct driver packages installed
2. Check kernel module loaded: `lsmod | grep -E "amdgpu|i915|nvidia"`
3. Reboot after driver installation

### Screen Tearing

**Symptoms:** Horizontal lines during motion, video playback issues

**Solutions:**

1. **Verify VSync enabled** in `~/.config/kwinrc`:
   ```ini
   [Compositing]
   VSync=true
   ```

2. **Check compositor running:**
   ```bash
   qdbus org.kde.KWin /Compositor active
   ```

3. **NVIDIA specific:** Ensure kernel parameter set:
   ```
   nvidia-drm.modeset=1
   ```

### Black Screen on Boot

**Emergency Recovery:**
1. Switch to TTY: `Ctrl+Alt+F2`
2. Login as root
3. Check logs: `journalctl -b -p err`

**Common fixes:**

```bash
# Boot with basic graphics
# Add to kernel command line in GRUB:
nomodeset

# For NVIDIA issues:
nouveau.modeset=0 nvidia-drm.modeset=1

# Reinstall graphics drivers
sudo pacman -S mesa vulkan-radeon  # AMD
sudo pacman -S nvidia-dkms         # NVIDIA
```

### Poor Performance / Low FPS

**Diagnosis:**
```bash
# Check GPU usage
radeontop          # AMD
intel_gpu_top      # Intel  
nvidia-smi         # NVIDIA

# Check compositor overhead
# Press Alt+Shift+F12 to toggle compositor
```

**Solutions:**
1. Disable heavy effects in kwinrc
2. Reduce blur strength
3. Check for thermal throttling
4. Update GPU drivers

### Wayland Session Won't Start

**Diagnosis:**
```bash
# Check Wayland support
echo $XDG_SESSION_TYPE  # Should be "wayland"

# Check KWin Wayland logs
journalctl --user -u plasma-kwin_wayland
```

**Solutions:**
1. Ensure `plasma-wayland-session` installed
2. Select "Plasma (Wayland)" at SDDM login
3. For NVIDIA: ensure driver 555+ and `nvidia-drm.modeset=1`

### Monitor Not Detected

**Diagnosis:**
```bash
# List connected displays
kscreen-doctor -o

# Check kernel detection
cat /sys/class/drm/*/status
```

**Solutions:**
1. Check cable connection
2. Try different port
3. Force detection: `xrandr --auto` (X11) or reconnect cable

### Wrong Resolution

**Solutions:**
```bash
# List available modes
kscreen-doctor -o

# Set specific resolution
kscreen-doctor output.HDMI-1.mode.1920x1080@60

# Or use System Settings → Display
```

### Multi-Monitor Issues

**Displays mirrored instead of extended:**
- System Settings → Display → Arrangement → Uncheck "Unify Outputs"

**Wrong primary display:**
- System Settings → Display → Select monitor → Check "Primary"

**Scaling different per monitor:**
- Set scale individually for each display in Display settings

## NVIDIA-Specific Issues

### Wayland Flickering

Ensure explicit sync support (driver 555+):
```bash
nvidia-smi --query-gpu=driver_version --format=csv
```

### Screen artifacts

```bash
# Disable GPU memory preservation
# Add to /etc/modprobe.d/nvidia.conf:
options nvidia NVreg_PreserveVideoMemoryAllocations=0
```

### Suspend/Resume Issues

```bash
# Enable systemd services
sudo systemctl enable nvidia-suspend nvidia-resume nvidia-hibernate
```

## Diagnostic Commands

```bash
# Full GPU info
inxi -G

# Vulkan capabilities
vulkaninfo

# VA-API status
vainfo

# VDPAU status  
vdpauinfo

# KWin compositor info
qdbus org.kde.KWin /Compositor supportedOpenGLPlatformInterfaceName

# Display configuration
kscreen-doctor -o
```

## Getting Help

1. Check logs: `journalctl -b | grep -E "drm|gpu|kwin"`
2. Forum: forum.sanchala.id
3. GitHub Issues: Report with `inxi -Fxxxz` output
