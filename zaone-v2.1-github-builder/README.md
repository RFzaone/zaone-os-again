# Zaone OS V2.1 GitHub Builder

This is the full **Zaone OS V2.1** source bundle for GitHub Actions.

## What V2.1 changes
- Replaces the old temporary logo with the real Zaone logo everywhere
- Uses your mountain/lake wallpaper as the default system wallpaper
- Keeps the wallpaper changeable by each user from settings
- Tunes the desktop toward a clean Windows-like 125% scale feel
- Refines the taskbar sizing, icon spacing, DPI, and login sizing
- Keeps the full V2 driver support, setup flow, PIN auth, boot branding, and lock screen

## How to use
1. Extract this ZIP.
2. Upload **everything inside** to the root of your GitHub repo.
3. Run `verify.sh` locally if you want a quick source check.
4. Push to GitHub.
5. Open **Actions → Build Zaone V2.1 ISO** and wait for the artifact named `zaone-v2.1-iso`.

## Notes
- This builds a live ISO.
- First boot should autologin to the live `zaone` account and show the real setup window.
- After setup, the created user gets the selected theme and default wallpaper; users can later change the wallpaper in settings.

## First-setup surgery
This build resets live-only setup state before LightDM, removes accidental test users from the live session, restores the temporary `zaone` autologin account, and relaunches setup until account creation succeeds. No personal username is hardcoded.
