#!/bin/bash

[[ ! -d "poky" ]] && echo "Error: Please execute this script from root directory of this repo!" && exit;

cd poky;
# Create the build tree
source oe-init-build-env; # Ends up in poky/build

echo "Copying raspberry pi specific config files..."
cp -f ../../conf/*.conf conf;
echo

echo "Starting minimal build.."
bitbake rpi-basic-image
echo
echo "Building done."