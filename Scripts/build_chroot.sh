#!/bin/bash

mkdir -p /var/chroot/debian/$1
debootstrap --arch $1 bullseye /var/chroot/debian/$1 http://deb.debian.org/debian/
mkdir -p /var/chroot/debian/$1/home/deb_build/stanc3
mount --bind ~/.stanc3/stanc3/ /var/chroot/debian/$1/home/deb_build/stanc3
mount -t proc proc /var/chroot/debian/$1/proc

chroot /var/chroot/debian/$1 /bin/bash << EOF
  apt update
  apt install opam curl bzip2 git tar curl ca-certificates openssl \\
              m4 bash libboost-math-dev libeigen3-dev libpcre3-dev \\
              libtbb-dev libsundials-dev opencl-headers -y
EOF

chroot /var/chroot/debian/$1 /bin/bash << EOF
  cd /home/deb_build/stanc3
  opam init --disable-sandboxing -y
  eval \$(opam env)
  opam switch create 4.07.0
  opam switch 4.07.0
  eval \$(opam env)
  bash -x scripts/install_build_deps.sh
  eval \$(opam env)
EOF
