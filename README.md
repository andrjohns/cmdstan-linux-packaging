# cmdstan-linux-packaging
Packaging `cmdstan` for distribution on Linux systems

This requires QEMU & debootstrap for creating multiple architecture chroots.
```
apt install binfmt-support qemu qemu-user-static debootstrap
```

## Steps

### Create chroot build environments for target architectures
Create `arm64` chroot:

```
bash build_chroot.sh arm64
```

- Creates `chroot` in `/var/chroot/debian/arm64`
- Installs dependencies for building `stanc3` and `cmdstan`
- Downloads `stanc3` and `cmdstan` repositories from GitHub

### Fetch updates from GitHub

```
bash update_cmdstan.sh arm64
```

Pulls any updates from the Git repositories for `cmdstan` and `stanc3` and updates the `arm64` chroot

### Build Debian package

```
bash package_cmdstan.sh arm64
```

- Builds `stanc` binary and `cmdstan` binaries
- Copies binaries and headers into format required for `.deb` package
- Create package metadata and un/installation scripts
- Build `.deb` package
