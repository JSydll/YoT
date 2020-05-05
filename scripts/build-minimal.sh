#!/bin/bash
export PROJECT_ROOT="$PWD";
export BB_ENV_EXTRAWHITE="$BB_ENV_EXTRAWHITE PROJECT_ROOT" 

source $PROJECT_ROOT/scripts/script-utils.sh
[[ ! -d "poky" ]] && echo_red "Error: Please execute this script from root directory of this repo!" && exit;

echo_orange "### Minimal Yocto build for Raspberry 3 ###"

# Setting up yocto build environment
source $PROJECT_ROOT/poky/oe-init-build-env; # creates and cds into /build
echo 
source $PROJECT_ROOT/scripts/configure.sh

echo_orange "### Starting minimal build ###"
bitbake core-image-base
echo 
if [ $? -eq 0 ]
then
  echo_green "### Building done. ###"
else
  echo_red "### Building failed! ###"
fi
