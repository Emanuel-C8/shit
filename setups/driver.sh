#!/bin/bash

set -e

echo "[INFO] Detecting hardware..."

# Detect CPU vendor
CPU_VENDOR=$(lscpu | grep -i 'Vendor ID' | awk '{print $3}')

# Detect GPUs
GPU_INFO=$(lspci | grep -Ei 'vga|3d|display')
GPU_NVIDIA=$(echo "$GPU_INFO" | grep -i nvidia)
GPU_AMD=$(echo "$GPU_INFO" | grep -i amd)
GPU_INTEL=$(echo "$GPU_INFO" | grep -i intel)

echo "[INFO] CPU Vendor: $CPU_VENDOR"
echo "[INFO] GPU(s) Detected:"
echo "$GPU_INFO"

# --- Install CPU microcode ---
echo "[ACTION] Installing CPU microcode..."
case "$CPU_VENDOR" in
    GenuineIntel)
        pacman -Sy --noconfirm intel-ucode
        ;;
    AuthenticAMD)
        pacman -Sy --noconfirm amd-ucode
        ;;
    *)
        echo "[WARN] Unknown CPU vendor. Skipping microcode."
        ;;
esac

# --- Install GPU drivers ---
echo "[ACTION] Installing GPU drivers..."

# Common dependencies
pacman -Sy --noconfirm mesa lib32-mesa

# Hybrid setup: Intel + NVIDIA
if [[ -n "$GPU_NVIDIA" && -n "$GPU_INTEL" ]]; then
    echo "[INFO] Hybrid NVIDIA + Intel GPU detected."

    pacman -Sy --noconfirm \
        nvidia nvidia-utils lib32-nvidia-utils \
        vulkan-icd-loader lib32-vulkan-icd-loader \
        vulkan-intel \
        xf86-video-intel

    echo "[INFO] Hybrid setup ready. Use PRIME offloading like:"
    echo "   __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia glxgears"
    
# Dedicated NVIDIA only
elif [[ -n "$GPU_NVIDIA" ]]; then
    echo "[INFO] NVIDIA GPU detected."

    pacman -Sy --noconfirm \
        nvidia nvidia-utils lib32-nvidia-utils \
        vulkan-icd-loader lib32-vulkan-icd-loader

# AMD GPU
elif [[ -n "$GPU_AMD" ]]; then
    echo "[INFO] AMD GPU detected."

    pacman -Sy --noconfirm \
        xf86-video-amdgpu vulkan-radeon

# Intel only
elif [[ -n "$GPU_INTEL" ]]; then
    echo "[INFO] Intel GPU detected."

    pacman -Sy --noconfirm \
        xf86-video-intel vulkan-intel

else
    echo "[WARN] No supported GPU detected."
fi

echo "[✅ DONE] Installation complete."
