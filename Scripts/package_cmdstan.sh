#!/bin/bash

chroot /var/chroot/debian/$1 /bin/bash << EOF
  # Create directory structure for debian package
  cd /home/deb_build/cmdstan
  mkdir -p cmdstan_deb
  mkdir -p cmdstan_deb/DEBIAN
  mkdir -p cmdstan_deb/usr/bin
  mkdir -p cmdstan_deb/usr/include/cmdstan
  mkdir -p cmdstan_deb/usr/include/cmdstan/bin
  mkdir -p cmdstan_deb/usr/include/cmdstan/stan
  mkdir -p cmdstan_deb/usr/include/cmdstan/stan/lib/stan_math

  # Copy cmdstan binaries to new directory
  cp bin/stanc cmdstan_deb/usr/bin/stanc
  cp bin/diagnose cmdstan_deb/usr/bin/standiagnose
  cp bin/print cmdstan_deb/usr/bin/stanprint
  cp bin/stansummary cmdstan_deb/usr/bin/stansummary

  # Copy cmdstan headers and makefiles
  cp -r lib cmdstan_deb/usr/include/cmdstan/lib
  cp -r examples cmdstan_deb/usr/include/cmdstan/examples
  cp -r make cmdstan_deb/usr/include/cmdstan/make
  cp -r src cmdstan_deb/usr/include/cmdstan/src
  cp makefile cmdstan_deb/usr/include/cmdstan/makefile

  # Copy Stan headers and makefiles
  cp -r stan/src cmdstan_deb/usr/include/cmdstan/stan/src
  cp -r stan/make cmdstan_deb/usr/include/cmdstan/stan/make
  cp stan/makefile cmdstan_deb/usr/include/cmdstan/stan/makefile

  # Copy Math headers and makefiles
  cp -r stan/lib/stan_math/make cmdstan_deb/usr/include/cmdstan/stan/lib/stan_math/make
  cp -r stan/lib/stan_math/stan cmdstan_deb/usr/include/cmdstan/stan/lib/stan_math/stan
  cp stan/lib/stan_math/makefile cmdstan_deb/usr/include/cmdstan/stan/lib/stan_math/makefile

  # Create bash script wrapper around 'make' call
  echo '#!/bin/bash' >> cmdstan_deb/usr/bin/stanmodel
  echo 'make -C /usr/include/cmdstan \$(realpath --relative-to=/usr/include/cmdstan \$1)' >> cmdstan_deb/usr/bin/stanmodel
  chmod +x cmdstan_deb/usr/bin/stanmodel

  # Create Debian control file
  echo 'Package: cmdstan' >> cmdstan_deb/DEBIAN/control
  echo 'Version: '\$(cat makefile | grep 'CMDSTAN_VERSION :=' | cut -d ":" -f 2 | cut -d " " -f 2) >> cmdstan_deb/DEBIAN/control
  echo 'Maintainer: Andrew Johnson <andrew.r.johnson@graduate.curtin.edu.au>' >> cmdstan_deb/DEBIAN/control
  echo 'Description: CmdStan is the command line interface to Stan' >> cmdstan_deb/DEBIAN/control
  echo 'Homepage: https://github.com/stan-dev/cmdstan' >> cmdstan_deb/DEBIAN/control
  echo 'Architecture: '\$(dpkg --print-architecture) >> cmdstan_deb/DEBIAN/control
  echo 'Depends: build-essential, libboost-math-dev (>=1.74), libeigen3-dev (>=3.3.9), libtbb-dev (>=2020.3), libsundials-dev (>= 4.1), opencl-headers (>= 3.0~2020)' >> cmdstan_deb/DEBIAN/control

  # Compile example model on installation to build pre-compiled headers and main object file
  echo 'stanmodel /usr/include/cmdstan/examples/bernoulli/bernoulli' >> cmdstan_deb/DEBIAN/postinst
  chmod 755 cmdstan_deb/DEBIAN/postinst

  # Remove any compiled objects on package uninstallation
  echo 'make -C /usr/include/cmdstan clean-all' >> cmdstan_deb/DEBIAN/prerm
  chmod 755 cmdstan_deb/DEBIAN/prerm

  # Build .deb package
  dpkg -b ./cmdstan_deb ./cmdstan_2.27.0-0_\$(dpkg --print-architecture).deb
EOF