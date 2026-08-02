#!/usr/bin/env bash
set -euo pipefail

list="config/package-lists/zaone.list.chroot"
required=(
  live-task-non-free-firmware-pc
  firmware-iwlwifi firmware-realtek firmware-brcm80211
  firmware-atheros firmware-mediatek firmware-amd-graphics
  firmware-intel-graphics firmware-intel-sound firmware-sof-signed
  firmware-nvidia-graphics mesa-vulkan-drivers
  xserver-xorg-input-all xserver-xorg-video-all
)

for package in "${required[@]}"; do
  grep -qx "$package" "$list" || {
    echo "Missing required driver package: $package"
    exit 1
  }
done

echo "Zaone driver bundle audit passed."
