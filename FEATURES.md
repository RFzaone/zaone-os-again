# zaone OS v1 contents

## Included and functional

### Base system
- Debian stable, 64-bit
- Linux kernel and Debian hardware drivers
- Live boot from USB
- UEFI and legacy BIOS ISO support through Debian Live Build
- NetworkManager for Wi-Fi and Ethernet
- PipeWire audio
- Bluetooth tools
- Laptop power management
- Printer support
- Flatpak and Flathub setup helper
- No advertisements, promoted apps, or sponsored placements
- No Zaone telemetry service

### Branding and desktop
- Original Zaone logo supplied by the project owner
- Original mountain wallpaper supplied by the project owner
- XFCE desktop configured as the v1 foundation
- Bottom panel
- Zaone menu button
- App search
- Files and Terminal pinned
- Light and dark mode switch
- Super key opens the application menu
- Familiar Alt+Tab, Super+D, Super+E, Super+L, and screenshot shortcuts

### Preinstalled applications
- Firefox ESR
- Files: Thunar
- Terminal: XFCE Terminal
- Settings Manager
- App search / launcher
- Text editor: Mousepad
- Calculator
- PDF viewer: Evince
- Image viewer: Ristretto
- Media player: Parole
- Screenshot tool
- Archive manager
- Task manager
- Disk usage analyser
- System information
- USB image writer
- GParted
- Fonts, codecs, and common archive formats where available


### Expanded hardware and driver bundle
- Debian live non-free-firmware hardware bundle
- Intel Wi-Fi firmware (`iwlwifi`)
- Realtek Wi-Fi, Ethernet, Bluetooth, and audio firmware
- Broadcom Wi-Fi firmware
- Qualcomm/Atheros wireless firmware
- MediaTek/Ralink firmware
- Intel SOF and Intel sound DSP firmware
- AMD, Intel, and NVIDIA graphics firmware
- Mesa OpenGL and Vulkan drivers
- Nouveau open-source NVIDIA display driver
- Generic Xorg keyboard, mouse, touchpad, tablet, and display drivers
- Printer and scanner drivers
- Webcam/V4L2 tools
- USB, storage, and removable-device services
- `zaone Driver Check` for hardware and missing-firmware reports
- DKMS, kernel headers, and Secure Boot inspection tools for later driver installation
- Proprietary NVIDIA is deliberately optional and is not forced onto every machine

### Zaone tools
- `zaone-about`
- `zaone-theme-dark`
- `zaone-theme-light`
- `zaone-update`
- `zaone-recovery-info`
- Crash-code generator for user-space crash reports
- Offline recovery information page
- Website starter folder for downloads and crash lookup

## Included as prototypes, not complete

- Custom Zaone taskbar: v1 currently uses a themed XFCE panel
- Bottom-right custom Super menu: XFCE menu is used for stability
- Chrome window zoom-out selector: not implemented
- Face unlock: not enabled because camera support and secure biometric setup vary by hardware
- PIN login: standard Linux password login is used
- Graphical kernel-panic screen: artwork is included, but a real kernel panic can occur before the normal desktop graphics stack is available
- Automatic online crash lookup: local code generation and website starter are included, but no hosted database exists yet
- Atomic operating-system rollback: update helper is included, but reliable rollback needs an installer and Btrfs/OSTree deployment design
- Full graphical installer branded as Zaone: Debian live installer launcher is included where supported
- Custom kernel: not included
- Custom file manager and terminal: v1 uses reliable existing apps

## Important

This kit prioritises a bootable and testable v1 over pretending unfinished components work.
