#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK="$ROOT/.build-work"
OUT="$ROOT/out"
REQ="$ROOT/manifests/required-packages.txt"
OPT="$ROOT/manifests/optional-packages.txt"

[[ "$EUID" -eq 0 ]] || { echo "Run as root: sudo ./build.sh"; exit 1; }
export DEBIAN_FRONTEND=noninteractive

echo "== Zaone OS V2.1 ISO builder =="
echo "Debian Trixie amd64 with Trixie backports"

apt-get update
apt-get install -y --no-install-recommends ca-certificates debian-archive-keyring

# Replace any preloaded source definitions so APT does not choke on mixed Signed-By values
rm -f /etc/apt/sources.list
rm -f /etc/apt/sources.list.d/*.list /etc/apt/sources.list.d/*.sources
cat >/etc/apt/sources.list.d/zaone-build.sources <<'EOF'
Types: deb
URIs: https://deb.debian.org/debian
Suites: trixie trixie-updates trixie-backports
Components: main contrib non-free non-free-firmware
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg

Types: deb
URIs: https://security.debian.org/debian-security
Suites: trixie-security
Components: main contrib non-free non-free-firmware
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg
EOF

apt-get update
apt-get install -y --no-install-recommends \
  live-build debootstrap xorriso isolinux syslinux-common squashfs-tools \
  rsync python3 file

rm -rf "$WORK" "$OUT"
mkdir -p "$WORK" "$OUT"
cp -a "$ROOT/config" "$WORK/config"
mkdir -p "$WORK/config/package-lists"

LIST="$WORK/config/package-lists/zaone.list.chroot"
SKIP="$OUT/skipped-optional-packages.txt"
: >"$LIST"
: >"$SKIP"

candidate_exists() {
  local package_name="$1" candidate
  candidate="$(apt-cache policy "$package_name" | awk '/Candidate:/ {print $2; exit}')"
  [[ -n "$candidate" && "$candidate" != "(none)" ]]
}

while IFS= read -r package_name || [[ -n "$package_name" ]]; do
  package_name="${package_name%%#*}"
  package_name="$(xargs <<<"$package_name")"
  [[ -z "$package_name" ]] && continue
  candidate_exists "$package_name" || {
    echo "Required package unavailable: $package_name" >&2
    exit 3
  }
  echo "$package_name" >>"$LIST"
done <"$REQ"

while IFS= read -r package_name || [[ -n "$package_name" ]]; do
  package_name="${package_name%%#*}"
  package_name="$(xargs <<<"$package_name")"
  [[ -z "$package_name" ]] && continue
  if candidate_exists "$package_name"; then
    echo "$package_name" >>"$LIST"
  else
    echo "$package_name" | tee -a "$SKIP"
  fi
done <"$OPT"

sort -u -o "$LIST" "$LIST"

find "$WORK/config/hooks" -type f -name '*.hook.chroot' -exec chmod +x {} +
find "$WORK/config/includes.chroot" -type f \
  \( -path '*/usr/local/bin/*' -o -path '*/usr/lib/zaone/*' -o -path '*/lib/live/config/*' \) \
  -exec chmod +x {} +

cd "$WORK"
lb clean --purge || true

lb config \
  --mode debian \
  --distribution trixie \
  --architectures amd64 \
  --binary-images iso-hybrid \
  --debian-installer live \
  --archive-areas "main contrib non-free non-free-firmware" \
  --security true \
  --updates true \
  --apt-recommends true \
  --mirror-bootstrap "https://deb.debian.org/debian" \
  --mirror-chroot "https://deb.debian.org/debian" \
  --mirror-binary "https://deb.debian.org/debian" \
  --iso-application "Zaone OS V2.1" \
  --iso-publisher "Zaone OS Project" \
  --iso-volume "ZAONE_V21" \
  --bootappend-live "boot=live components quiet splash loglevel=3 systemd.show_status=false vt.global_cursor_default=0 username=zaone user-fullname=Zaone hostname=zaone-os locales=en_AU.UTF-8 keyboard-layouts=us"

# Start with live-build's complete BIOS and UEFI templates, then replace the
# Debian artwork and visible menu names.
rm -rf config/bootloaders
cp -a /usr/share/live/build/bootloaders config/bootloaders

find config/bootloaders -type f -name 'splash.svg' -delete
while IFS= read -r -d '' boot_dir; do
  cp "$ROOT/assets/boot-splash.png" "$boot_dir/splash.png"
done < <(find config/bootloaders -mindepth 1 -maxdepth 1 -type d -print0)

while IFS= read -r -d '' text_file; do
  sed -i \
    -e 's/splash\.svg/splash.png/g' \
    -e 's/Debian GNU\/Linux/Zaone OS V2.1/g' \
    -e 's/Debian Live/Zaone OS V2.1/g' \
    -e 's/Live system/Start Zaone OS V2.1/g' \
    -e 's/Boot menu/Zaone OS V2.1/g' \
    "$text_file" || true
done < <(grep -RIlZ -E 'splash\.svg|Debian GNU/Linux|Debian Live|Live system|Boot menu' config/bootloaders || true)

lb build 2>&1 | tee "$OUT/build.log"

ISO="$(find . -maxdepth 1 -type f -name '*.iso' -print -quit)"
[[ -n "$ISO" ]] || { echo "Build ended without an ISO" >&2; exit 4; }

cp "$ISO" "$OUT/zaone-v2.1-amd64.iso"
sha256sum "$OUT/zaone-v2.1-amd64.iso" >"$OUT/zaone-v2.1-amd64.iso.sha256"
cp "$LIST" "$OUT/requested-packages.txt"

echo
echo "Built: $OUT/zaone-v2.1-amd64.iso"
ls -lh "$OUT/zaone-v2.1-amd64.iso"
