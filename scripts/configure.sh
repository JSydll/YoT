#!/bin/bash
[[ -z "$PROJECT_ROOT" ]] && echo_red "Error: Environment variable PROJECT_ROOT not set." && exit;
[[ -z "$BBPATH" ]] && echo_red "Error: Yocto build environment not initialized (oe-init-build-env should be called before)." && exit;

echo_orange "### Custom configuration ###"

echo "- Copying global Yocto config files..."
cp -f $PROJECT_ROOT/conf/bblayers.conf $PROJECT_ROOT/build/conf; 
cp -f $PROJECT_ROOT/conf/local.conf $PROJECT_ROOT/build/conf; 

echo "- Setting default user and access configuration..."
echo "- Set custom ones by exporting them or prepending the build command with them. "
echo "- Available variables: "
echo "-     ROOT_PASS  - Sets a custom root password (also used for ssh). Default: yasbi"
echo "-     FIXED_IP   - Configure a fixed IP for easy ssh access. Default: empty"
echo "-     WIFI_SSID  - Self-explanatory. Default: empty"
echo "-     WIFI_PWD   - Self-explanatory. Default: empty"
export ROOT_PASS=${ROOT_PASS:-"yasbi"}

# Making bitbake aware of the environment files
export BB_ENV_EXTRAWHITE="$BB_ENV_EXTRAWHITE ROOT_PASS FIXED_IP WIFI_SSID WIFI_PWD" 

echo