# zaone OS v1 Prototype ISO Kit


> **FULL FIXED PACKAGE:** This folder contains the complete Zaone OS v1 build project,
> not only a patch. The Debian Trixie, security repository, privileged container,
> project-mount, driver-package, and artifact fixes are already merged.


This repository builds a bootable **64-bit live ISO** using Debian Live Build.

## Easiest method: GitHub Actions, no admin on your laptop

1. Create a new GitHub repository.
2. Upload every file and folder from this ZIP.
3. Open **Actions** → **Build zaone ISO** → **Run workflow**.
4. Wait for the build.
5. Download the `zaone-v1-iso` artifact.
6. A friend or administrator still needs to flash the ISO to a USB using Rufus, Etcher, Ventoy, or `dd`.

## Local Linux build

Requires root privileges:

```bash
sudo ./build.sh
```

The ISO appears in:

```text
out/zaone-v1-amd64.iso
```

## What this actually is

This is a real bootable live Linux ISO build project with Zaone branding, applications,
desktop defaults, helper tools, and GitHub CI.

It is **not yet** a from-scratch kernel or a fully custom desktop environment. It uses
Debian Linux and XFCE as the stable foundation while Zaone-specific components are built.

Read `FEATURES.md` for the exact included and unfinished features.


## Driver coverage

The patched kit includes broad firmware and drivers for common Intel, AMD, Realtek,
Broadcom, Qualcomm/Atheros, MediaTek, NVIDIA, audio, input, printer, scanner, USB,
storage, and webcam hardware. Run `zaone-driver-check` inside the live system to
inspect detected devices and missing firmware.

The proprietary NVIDIA driver is not forced into the live image. Zaone v1 uses
Nouveau by default and leaves proprietary NVIDIA installation as an explicit choice.
