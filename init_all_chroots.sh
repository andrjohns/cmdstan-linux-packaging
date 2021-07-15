#!/bin/bash

mkdir -p ~/.stanc3 && cd ~/.stanc3
git clone https://github.com/stan-dev/stanc3 && cd stanc3
bash -x scripts/install_ocaml.sh
bash -x scripts/install_build_deps.sh

declare -a ArchArray=("arm64" "armel" "armhf" "i386"
                      "amd64" "mipsel" "mipsel64"
                      "ppc64el" "s390x")
for arch in "${ArchArray[@]}"; do
  bash Scripts/build_chroot.sh $arch
done
