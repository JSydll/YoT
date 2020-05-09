#!/bin/bash
# ------------------------
# Builds the minimal image
# ------------------------

# Capture command line parameters to avoid interference with bitbake oe-init
PARAMS="$@"
shift $#

export PROJECT_ROOT="$PWD";
source $PROJECT_ROOT/scripts/init.sh &> /dev/null

echo_orange "### Minimal Yocto build for Raspberry 3 ###"
echo 
source $PROJECT_ROOT/scripts/configure.sh

echo_orange "### Starting minimal build ###"
eval $(echo "bitbake $PARAMS")
echo 
if [[ $? -eq 0 ]]; then 
    echo_green "### Building done. ###"
else
    echo_red "### Building failed! ###"
fi