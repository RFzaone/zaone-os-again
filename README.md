# Zaone build fix patch

This replaces `.github/workflows/build-iso.yml`.

It fixes:
- old Ubuntu live-build tools
- broken Trixie repository handling
- Docker container mount permission errors
- missing `/proc` and `/dev/pts` access

## Apply in Codespaces

Upload this patch ZIP, then run:

```bash
unzip -o zaone-build-fix-patch.zip
rm zaone-build-fix-patch.zip
git add .github/workflows/build-iso.yml
git commit -m "Fix ISO build environment"
git push
```

A new GitHub Actions build will start automatically.
