#!/usr/bin/env bash
set -Eeuo pipefail

if [[ "${EUID}" -ne 0 ]]; then
  echo "Run with sudo: sudo ./build.sh"
  exit 1
fi

command -v lb >/dev/null 2>&1 || {
  echo "Installing build dependencies..."
  apt-get update
  DEBIAN_FRONTEND=noninteractive apt-get install -y live-build debootstrap xorriso isolinux syslinux-common squashfs-tools
}

rm -rf .build-work out
mkdir -p .build-work out
cp -a config .build-work/
cd .build-work

lb clean --purge || true
lb config \
  --mode debian \
  --distribution stable \
  --architectures amd64 \
  --binary-images iso-hybrid \
  --debian-installer live \
  --archive-areas "main contrib non-free-firmware" \
  --bootappend-live "boot=live components quiet splash username=zaone hostname=zaone-os locales=en_AU.UTF-8 keyboard-layouts=us"

lb build 2>&1 | tee ../out/build.log

iso="$(find . -maxdepth 1 -type f -name '*.iso' | head -n1)"
if [[ -z "$iso" ]]; then
  echo "Build finished but no ISO was found."
  exit 2
fi

cp "$iso" ../out/zaone-v1-amd64.iso
sha256sum ../out/zaone-v1-amd64.iso > ../out/zaone-v1-amd64.iso.sha256
echo
echo "Built: out/zaone-v1-amd64.iso"
