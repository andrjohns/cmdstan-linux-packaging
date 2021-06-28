#!/bin/bash

declare -a ArchArray=("arm64" "armel" "armhf" "i386"
                      "amd64" "mipsel" "mipsel64"
                      "ppc64el" "s390x")
for arch in "${ArchArray[@]}"; do
  bash Scripts/build_chroot.sh $arch
done