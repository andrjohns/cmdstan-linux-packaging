#!/bin/bash

declare -a ArchArray=("arm64" "armel" "armhf" "i386"
                      "amd64" "mipsel" "mipsel64"
                      "ppc64el" "s390x")
for arch in "${ArchArray[@]}"; do
  bash Scripts/update_cmdstan.sh $arch
  bash Scripts/package_cmdstan.sh $arch
done