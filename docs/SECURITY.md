# Account and PIN security

- Account passwords are sent to `chpasswd` over standard input and stored by Linux in `/etc/shadow`.
- PINs are stored in `/etc/zaone/pins` as Argon2id hashes with a unique random salt and root-only permissions.
- The PIN verifier is used only by LightDM and `xfce4-screensaver`.
- `sudo`, package management, and administrative actions continue to require the full account password.
- The setup helper is exposed through a named Polkit action.
- Only the temporary live user in the `zaone-setup` group can run first setup.
- Setup writes a completion state file and cannot silently run twice.
- The temporary password and PIN fields are cleared immediately after the helper returns.
