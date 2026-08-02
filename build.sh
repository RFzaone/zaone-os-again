#!/usr/bin/env bash
set -Eeuo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUT_DIR="$PROJECT_ROOT/out"
WORK_DIR="$PROJECT_ROOT/.build-work"
PACKAGE_LIST="config/package-lists/zaone.list.chroot"

if [[ "${EUID}" -ne 0 ]]; then
  echo "Run with sudo/root: sudo ./build.sh"
  exit 1
fi

echo "== zaone OS v1 ISO builder =="
echo "Base: Debian Trixie amd64"

required_commands=(lb debootstrap xorriso mksquashfs apt-cache)
missing_commands=()

for command_name in "${required_commands[@]}"; do
  command -v "$command_name" >/dev/null 2>&1 || missing_commands+=("$command_name")
done

if (( ${#missing_commands[@]} > 0 )); then
  echo "Installing ISO build tools..."
  apt-get update
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
    live-build \
    debootstrap \
    xorriso \
    isolinux \
    syslinux-common \
    squashfs-tools \
    ca-certificates \
    debian-archive-keyring
fi

rm -rf "$WORK_DIR" "$OUT_DIR"
mkdir -p "$WORK_DIR" "$OUT_DIR"
cp -a "$PROJECT_ROOT/config" "$WORK_DIR/config"

# ZIP extraction and cross-platform copies can lose executable bits.
find "$WORK_DIR/config/hooks" -type f -name '*.hook.*' -exec chmod +x {} + 2>/dev/null || true
find "$WORK_DIR/config/includes.chroot/usr/local/bin" -type f -exec chmod +x {} + 2>/dev/null || true

# Prevent one optional package rename from killing the whole ISO build.
# Package availability is checked against the same Debian Trixie repositories
# used by the build container.
if [[ -f "$WORK_DIR/$PACKAGE_LIST" ]]; then
  requested="$WORK_DIR/$PACKAGE_LIST"
  filtered="${requested}.filtered"
  missing_report="$OUT_DIR/skipped-packages.txt"

  : > "$filtered"
  : > "$missing_report"

  while IFS= read -r package_name || [[ -n "$package_name" ]]; do
    package_name="${package_name%%#*}"
    package_name="$(echo "$package_name" | xargs)"

    [[ -z "$package_name" ]] && continue

    if apt-cache show "$package_name" >/dev/null 2>&1; then
      echo "$package_name" >> "$filtered"
    else
      echo "$package_name" | tee -a "$missing_report"
    fi
  done < "$requested"

  mv "$filtered" "$requested"

  essential_packages=(
    live-config
    live-boot
    linux-image-amd64
    xfce4
    lightdm
    network-manager
    firefox-esr
  )

  for essential_package in "${essential_packages[@]}"; do
    if ! grep -qx "$essential_package" "$requested"; then
      echo "Required package unavailable: $essential_package"
      exit 3
    fi
  done

  if [[ -s "$missing_report" ]]; then
    echo "Optional unavailable packages were skipped:"
    cat "$missing_report"
  else
    echo "All requested packages are available."
  fi
fi

cd "$WORK_DIR"

lb clean --purge || true

lb config \
  --mode debian \
  --distribution trixie \
  --architectures amd64 \
  --binary-images iso-hybrid \
  --debian-installer live \
  --archive-areas "main contrib non-free non-free-firmware" \
  --security false \
  --updates true \
  --mirror-bootstrap "https://deb.debian.org/debian" \
  --mirror-chroot "https://deb.debian.org/debian" \
  --mirror-binary "https://deb.debian.org/debian" \
  --bootappend-live "boot=live components quiet splash username=zaone hostname=zaone-os locales=en_AU.UTF-8 keyboard-layouts=us"

lb build 2>&1 | tee "$OUT_DIR/build.log"

iso="$(find . -maxdepth 1 -type f -name '*.iso' -print -quit)"

if [[ -z "$iso" ]]; then
  echo "Build finished, but no ISO file was found."
  exit 2
fi

cp "$iso" "$OUT_DIR/zaone-v1-amd64.iso"
sha256sum "$OUT_DIR/zaone-v1-amd64.iso" > "$OUT_DIR/zaone-v1-amd64.iso.sha256"

echo
echo "ISO built successfully:"
ls -lh "$OUT_DIR/zaone-v1-amd64.iso"
