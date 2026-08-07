# 🎮 GPU Drivers - Sanchala OS

## Supported GPUs

### AMD (Recommended)

| Generation | Cards | Driver | Status |
|------------|-------|--------|--------|
| RDNA 3 | RX 7000 series | amdgpu + RADV | ✅ Excellent |
| RDNA 2 | RX 6000 series | amdgpu + RADV | ✅ Excellent |
| RDNA 1 | RX 5000 series | amdgpu + RADV | ✅ Excellent |
| Vega | Vega 56/64 | amdgpu + RADV | ✅ Excellent |
| Polaris | RX 400/500 series | amdgpu + RADV | ✅ Good |
| GCN 1-3 | HD 7000, R7/R9 | amdgpu + RADV | ⚠️ Legacy |

**Why AMD is recommended:**
- Fully open-source drivers in kernel
- Day-one Wayland support
- Excellent RADV Vulkan implementation
- No proprietary blobs needed

### Intel

| Generation | Products | Driver | Status |
|------------|----------|--------|--------|
| Arc (DG2) | Arc A770/A750/A380 | i915 + ANV | ✅ Good |
| Gen 12 | Iris Xe (11th/12th Gen) | i915 + ANV | ✅ Excellent |
| Gen 9-11 | UHD 620/630 | i915 + ANV | ✅ Good |
| Gen 7-8 | HD 4000/5000 | i915 + ANV | ⚠️ Legacy |

### NVIDIA

| Generation | Cards | Driver | Status |
|------------|-------|--------|--------|
| Ada Lovelace | RTX 4000 series | nvidia-dkms | ✅ Good |
| Ampere | RTX 3000 series | nvidia-dkms | ✅ Good |
| Turing | RTX 2000, GTX 16 | nvidia-dkms | ✅ Good |
| Pascal | GTX 10 series | nvidia-dkms | ⚠️ Wayland issues |
| Maxwell | GTX 900 series | nvidia-dkms | ⚠️ Limited Wayland |

**NVIDIA Notes:**
- Requires proprietary driver for good performance
- Wayland support improving but not perfect
- NVIDIA 555+ required for explicit sync (smoother Wayland)
- Use `nvidia-dkms` for kernel module building

---

## 📦 Package Groups

### Core Graphics (Always Installed)

```
mesa                    # OpenGL implementation
vulkan-icd-loader       # Vulkan loader
libva                   # Video acceleration API
wayland                 # Wayland protocol
xorg-xwayland           # X11 compatibility
```

### AMD Packages

```
vulkan-radeon           # RADV Vulkan driver
lib32-vulkan-radeon     # 32-bit support (gaming)
libva-mesa-driver       # VA-API for AMD
mesa-vdpau              # VDPAU video decode
xf86-video-amdgpu       # X11 DDX (XWayland)
amdvlk                  # Alternative Vulkan driver
```

### Intel Packages

```
vulkan-intel            # ANV Vulkan driver
lib32-vulkan-intel      # 32-bit support
intel-media-driver      # VA-API (modern Intel)
libva-intel-driver      # VA-API (legacy Intel)
```

### NVIDIA Packages (Conditional)

```
nvidia-dkms             # Kernel module (DKMS)
nvidia-utils            # Userspace utilities
lib32-nvidia-utils      # 32-bit support
nvidia-settings         # Configuration GUI
libva-nvidia-driver     # VA-API via NVDEC
opencl-nvidia           # OpenCL support
```

---

## 🛠️ GPU Detection Tool

Sanchala includes `sanchala-gpu-detect` for automatic GPU setup:

```bash
# Detect and configure GPU
sudo sanchala-gpu-detect

# Show detected GPUs
sanchala-gpu-detect --info

# Install NVIDIA drivers (if detected)
sudo sanchala-gpu-detect --install-nvidia
```

The tool:
1. Detects all GPUs in system
2. Installs appropriate drivers
3. Configures hybrid graphics if applicable
4. Sets up VA-API for video acceleration
5. Configures kernel parameters

---

## 🔍 Verification Commands

```bash
# Check GPU detection
lspci -k | grep -A 3 VGA

# Check DRM devices
ls -la /dev/dri/

# Check OpenGL
glxinfo | grep "OpenGL renderer"

# Check Vulkan
vulkaninfo | grep "GPU"

# Check VA-API
vainfo

# Check VDPAU
vdpauinfo
```
