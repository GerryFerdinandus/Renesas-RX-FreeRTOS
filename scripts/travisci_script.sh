#!/bin/bash

# download the Renesas RX gcc compiler file
wget -O gcc_rx.tar.xz https://github.com/GerryFerdinandus/Renesas-RX-GCC/releases/download/V4.8.0.201603/gcc_rx.tar.xz

# extract the gcc compiler to folder prefix
mkdir prefix
tar -xf gcc_rx.tar.xz -C prefix --strip-components 1

# Export path to the gcc compiler in folder prefix
export PATH="$PWD/prefix/bin:$PATH"

# Show the GCC version
rx-elf-gcc --version

# Start building the program. Stop when error in 'make' is detected.
make clean
make || exit 1

# Start coverity scan
make clean
source ./scripts/travisci_build_coverity_scan.sh

