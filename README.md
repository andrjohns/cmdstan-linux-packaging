# cmdstan-linux-packaging
Packaging `cmdstan` for distribution on Linux systems

This requires QEMU & debootstrap for creating multiple architecture chroots.
```
apt install binfmt-support qemu qemu-user-static debootstrap
```

## Steps

### Create chroot build environments for all architectures
Initialises `chroot` environments for all 'Supported' Debian architectures, currently:
- `arm64`
- `armel`
- `armhf`
- `i386`
- `amd64`
- `mipsel`
- `mipsel64`
- `ppc64el`
- `s390x`

```
bash init_all_chroots.sh
```

- Creates `chroot` in `/var/chroot/debian/$(ARCH)`
- Installs dependencies for building `stanc3` and `cmdstan`
- Downloads `stanc3` and `cmdstan` repositories from GitHub

### Package latest Github

```
bash package_all_archs.sh
```

- Pulls any updates from the Git repositories for `cmdstan` and `stanc3`
- Builds `stanc` binary and `cmdstan` binaries
- Copies binaries and headers into directory format required for `.deb` package
- Create package metadata and un/installation scripts
- Build `.deb` package
