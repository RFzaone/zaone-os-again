#!/usr/bin/env bash
set -euo pipefail
test -x build.sh
test -f config/package-lists/zaone.list.chroot
test -f config/includes.chroot/usr/share/backgrounds/zaone/zaone-wallpaper.png
test -f config/includes.chroot/usr/share/icons/hicolor/256x256/apps/zaone-logo.png
find config/includes.chroot/usr/local/bin -type f -maxdepth 1 -print0 | xargs -0 -n1 bash -n
./audit-driver-packages.sh
echo "Project structure and shell syntax checks passed."
