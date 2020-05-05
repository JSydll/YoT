#!/bin/bash
# ------------------------
# Initializes the project's Yocto environment
# ------------------------
export PROJECT_ROOT="$PWD";
export BB_ENV_EXTRAWHITE="$BB_ENV_EXTRAWHITE PROJECT_ROOT" 

source $PROJECT_ROOT/scripts/utils.sh
[[ ! -d "poky" ]] && echo_red "Error: Please execute this script from root directory of this repo!" && exit;

echo_orange "## Setting up Yocto / bitbake environment... ##"
# Creates and cds into /build
source $PROJECT_ROOT/poky/oe-init-build-env