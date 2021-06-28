#!/bin/bash

mkdir -p /var/chroot/debian/$1
debootstrap --arch $1 bullseye /var/chroot/debian/$1 http://deb.debian.org/debian/
mount -t proc proc /var/chroot/debian/$1/proc

chroot /var/chroot/debian/$1 /bin/bash << EOF
  apt update
  apt install opam curl bzip2 git tar curl ca-certificates openssl \\
              m4 bash libboost-math-dev libeigen3-dev \\
              libtbb-dev libsundials-dev opencl-headers -y
EOF

chroot /var/chroot/debian/$1 /bin/bash << EOF
  opam init --disable-sandboxing -y
  opam switch create 4.07.0
  eval \$(opam env)
  opam repo add internet https://opam.ocaml.org
  opam update
EOF

chroot /var/chroot/debian/$1 /bin/bash << EOF
  mkdir -p /home/deb_build && cd /home/deb_build
  git clone https://github.com/stan-dev/stanc3
  git clone --recursive https://github.com/stan-dev/cmdstan
  echo SYS_LIBS=true >> cmdstan/make/local
EOF