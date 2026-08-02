# Source validation completed

The source package was checked before being zipped:

- Bash syntax for `build.sh`, `verify.sh`, and every chroot hook
- Python syntax for First Setup, the privileged account helper, and the PAM PIN verifier
- XML parsing for Xfce and Polkit configuration
- PNG dimensions and file signatures
- Real account-creation integration test in an isolated Linux container
- Linux password creation check
- Argon2 PIN success and failure checks
- Root-only PIN file permission checks
- Light and dark theme configuration checks
- Search for unfinished runtime markers

The full multi-gigabyte ISO was not compiled inside the artifact-generation environment. GitHub Actions performs that build and will stop immediately if a required Debian package is unavailable or a build step fails.
