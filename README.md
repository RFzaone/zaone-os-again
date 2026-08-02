# Zaone OS V2 GitHub ISO builder

This package builds a separate **Zaone OS V2** live ISO. The blue Debian/Xfce desktop shown in the V1 screenshot is not reused as the V2 branding.

## Build it on GitHub

1. Extract this ZIP.
2. Upload **everything inside the extracted folder** to the root of your GitHub repository.
3. Open **Actions**.
4. Choose **Build Zaone V2 ISO**.
5. Press **Run workflow**.
6. When the green tick appears, download the `zaone-v2-iso` artifact.
7. Extract `zaone-v2-amd64.iso`.

GitHub performs the ISO build inside Debian Trixie, so the Windows school laptop does not need administrator access.

## Working V2 features included

- Zaone BIOS and UEFI boot artwork and menu labels
- Real Zaone Plymouth boot animation
- Finished Zaone wallpaper, logo, OS identity, and LightDM branding
- Bottom Xfce taskbar with working menu, Search, Files, Terminal, tasks, tray, clock, and power controls
- First Setup asking for username, password, PIN, and light/dark mode
- A real Linux account created through a restricted Polkit helper
- Password stored by Linux in `/etc/shadow`
- PIN stored as a root-only salted Argon2id hash
- Password **or** PIN login through PAM for LightDM and the Xfce lock screen
- `Super+L`, automatic idle locking, and lock-on-suspend
- Touchscreen, active pen, sensor rotation, Wi-Fi, Bluetooth, Intel graphics, SOF audio, camera, battery, USB-C, printer, and scanner packages
- Trixie-backports kernel and Intel firmware for newer hardware
- Hardware report utility for finding exact device-specific failures

The PIN is accepted only by login and the lock screen. `sudo` and other administrator actions still require the full password.

## Two priority laptops

- Lenovo 13w 2-in-1 Gen 3, Intel Core 5, 16 GB, 512 GB
- Lenovo ThinkPad L13 2-in-1 Gen 6, Intel Core Ultra 5, 16 GB, 512 GB

Complete `docs/HARDWARE-TEST-MATRIX.md` on both physical laptops before calling V2 hardware-certified.

## V2 live-session behaviour

V2 is still a live ISO. The account and settings work for the running session but reset after reboot unless the system is installed or persistence is configured. A permanent polished installer is a later milestone.
