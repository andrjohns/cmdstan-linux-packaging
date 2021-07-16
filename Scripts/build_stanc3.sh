#!/bin/bash

cd ~/.stanc3/stanc3
eval $(opam env)
dune subst

chroot /var/chroot/debian/$1 /bin/bash << EOF
  cd /home/deb_build/stanc3
  dune build @install --profile static
  mkdir -p bin 
  mv \$(find _build -name stanc.exe) bin/linux-$1-stanc
EOF
