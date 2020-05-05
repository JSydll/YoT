#!/bin/bash
[[ -z "$PROJECT_ROOT" ]] && echo_red "Error: Environment variable PROJECT_ROOT not set." && exit;
[[ -z "$BBPATH" ]] && echo_red "Error: Yocto build environment not initialized (oe-init-build-env should be called before)." && exit;

echo_orange "### Custom configuration ###"

echo "- Available variables: "
echo "-     TARGET_MACHINE  - Selects the hardware specific configuration. Default: raspberrypi3"
export TARGET_MACHINE=${TARGET_MACHINE:-"raspberrypi3"}
echo "-     ROOT_PASS  - Sets a custom root password (also used for ssh). Default: yasbi"
export ROOT_PASS=${ROOT_PASS:-"yasbi"}
echo "-     FIXED_IP   - Configure a fixed IP for easy ssh access. Default: empty"
echo "-     WIFI_SSID  - Self-explanatory. Default: empty"
echo "-     WIFI_PWD   - Self-explanatory. Default: empty"
echo "- Set custom ones by exporting them or prepending the build command with them. "

# Make sure, the target machine configuration can be found
if [[ ! -d "$PROJECT_ROOT/conf/$TARGET_MACHINE/" || ! -f "$PROJECT_ROOT/conf/$TARGET_MACHINE/local.conf" ]]; then
    echo_red "Error: Could not find conf/$TARGET_MACHINE/local.conf for the specified target."
    echo_red "Aborting build."
    exit
fi

echo "- Generating Yocto config files in the build tree..."
cp -f $PROJECT_ROOT/conf/bblayers.conf $PROJECT_ROOT/build/conf; 

cat $PROJECT_ROOT/conf/common/build.conf \
    $PROJECT_ROOT/conf/common/features.conf \
    $PROJECT_ROOT/conf/common/system.conf \
    $PROJECT_ROOT/conf/$TARGET_MACHINE/local.conf > $PROJECT_ROOT/build/conf/local.conf; 

echo "- Setting default user and access configuration..."
# Making bitbake aware of the environment files
export BB_ENV_EXTRAWHITE="$BB_ENV_EXTRAWHITE ROOT_PASS FIXED_IP WIFI_SSID WIFI_PWD" 

echo 