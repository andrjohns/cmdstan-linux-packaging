#!/bin/bash

chroot /var/chroot/debian/$1 /bin/bash << EOF
  cd /home/deb_build/stanc3
  make clean
  git pull
  make
EOF

chroot /var/chroot/debian/$1 /bin/bash << EOF
  cd /home/deb_build/cmdstan
  make clean-all
  git pull
  mkdir -p cmdstan/bin
  mv /home/deb_build/stanc3/_build/default/src/stanc/stanc.exe /home/deb_build/cmdstan/bin/stanc
  make -j8 build
EOF