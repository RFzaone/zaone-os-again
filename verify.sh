#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

required=(
  build.sh
  .github/workflows/build-iso.yml
  manifests/required-packages.txt
  assets/boot-splash.png
  config/includes.chroot/usr/local/bin/zaone-setup
  config/includes.chroot/usr/lib/zaone/setup-helper
  config/includes.chroot/usr/lib/zaone/pam-pin-auth
  config/includes.chroot/usr/lib/zaone/live-firstboot-reset
  config/includes.chroot/usr/local/bin/zaone-first-setup-launcher
  config/includes.chroot/etc/systemd/system/zaone-live-firstboot.service
  config/includes.chroot/usr/share/plymouth/themes/zaone/zaone.script
)

for path in "${required[@]}"; do
  [[ -f "$ROOT/$path" ]] || { echo "Missing: $path"; exit 1; }
done

bash -n "$ROOT/build.sh"
find "$ROOT/config/hooks" -name '*.hook.chroot' -print0 | xargs -0 -n1 bash -n
bash -n "$ROOT/config/includes.chroot/usr/lib/zaone/live-firstboot-reset"
bash -n "$ROOT/config/includes.chroot/usr/local/bin/zaone-first-setup-launcher"

python3 - \
  "$ROOT/config/includes.chroot/usr/local/bin/zaone-setup" \
  "$ROOT/config/includes.chroot/usr/lib/zaone/setup-helper" \
  "$ROOT/config/includes.chroot/usr/lib/zaone/pam-pin-auth" <<'PYSYNTAX'
from pathlib import Path
import sys

for filename in sys.argv[1:]:
    path = Path(filename)
    compile(path.read_text(encoding="utf-8"), str(path), "exec")
print("Python syntax checks passed")
PYSYNTAX

python3 - "$ROOT" <<'PYCHECK'
from pathlib import Path
import struct
import sys
import xml.etree.ElementTree as ET

root = Path(sys.argv[1])

def png_size(path):
    data = path.read_bytes()[:24]
    if data[:8] != b"\x89PNG\r\n\x1a\n":
        raise AssertionError(f"Not a PNG: {path}")
    return struct.unpack(">II", data[16:24])

assert png_size(root / "assets/boot-splash.png") == (640, 480)
assert png_size(root / "assets/zaone-wallpaper.png") == (1920, 1080)

for path in root.rglob("*.xml"):
    ET.parse(path)

print("Image and XML checks passed")
PYCHECK

if grep -RnE 'TODO|COMING SOON|NOT IMPLEMENTED|PLACEHOLDER' \
  "$ROOT/config/includes.chroot" "$ROOT/config/hooks"; then
  echo "Unfinished runtime marker found" >&2
  exit 1
fi

echo "Zaone V2.1 source verification passed"
