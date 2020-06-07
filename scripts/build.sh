#!/bin/bash
# ------------------------
# Builds the minimal image
# ------------------------

# Capture command line parameters to avoid interference with bitbake oe-init
PARAMS="$@"
shift $#

export PROJECT_ROOT="$PWD";
source $PROJECT_ROOT/scripts/init.sh &> /dev/null

echo_orange "### Customized Yocto build ###"
echo 
source $PROJECT_ROOT/scripts/configure.sh

echo_orange "### Starting image build ###"
# Use update-image if nothing is provided
if [[ -z "$PARAMS" ]]; then 
    [[ "$UPDATE_ENABLED" = "1" ]] && PARAMS="update-image" || PARAMS="core-image-base"
    echo "- No parameters given, defaulting to '$PARAMS'."
    echo "- Note: As several layers use IMAGE_INSTALL_append, using 'core-image-minimal' will lead to missing packages on the target."
    echo "        If you need a smaller image than the base image, you need to create a derivative of the minimal image."
    echo 
fi
eval "bitbake $PARAMS"
echo 
if [[ $? -eq 0 ]]; then 
    echo_green "### Building done. ###"
else
    echo_red "### Building failed! ###"
fi