#!/bin/bash
# ------------------------
# Customization and configuration of the Yocto image
#
# It creates all necessary configuration files and prepares the 
# image building.
# ------------------------

[[ -z "$PROJECT_ROOT" ]] && echo_red "Error: Environment variable PROJECT_ROOT not set." && exit;
[[ -z "$BBPATH" ]] && echo_red "Error: Yocto build environment not initialized (oe-init-build-env should be called before)." && exit;

# ------------------------
# Writes the content of one or more config files ($1) into the build config file ($2)
# Appends to the file if $3 is provided and true.
# Does not perform any checks and is meant for use here only.
# ------------------------
write_conf() {
    if [[ -z "$3" || "$3" = false ]]; then
        cat $1 > $PROJECT_ROOT/build/conf/$2
    else
        cat $1 >> $PROJECT_ROOT/build/conf/$2     
    fi
}

echo_orange "### Custom configuration ###"

echo "- Variables exported to the bitbake environment: "
echo "-     TARGET_MACHINE  - Selects the hardware specific configuration. Default: 'raspberrypi3'"
export TARGET_MACHINE=${TARGET_MACHINE:-"raspberrypi3"}
echo "-     ROOT_PASS       - Sets a custom root password (also used for ssh). Default: 'yasbi'"
export ROOT_PASS=${ROOT_PASS:-"yasbi"}
echo "-     WIFI_ENABLED    - Enables or disables the wifi feature. Default: true"
export WIFI_ENABLED=${WIFI_ENABLED:-true}
echo "-     BT_ENABLED      - Enables or disables the bluetooth feature. Default: true"
export BT_ENABLED=${BT_ENABLED:-true}
echo "-     WIFI_MODE       - 'client' (in existing network) or 'router' (access point) mode. Default: 'client'"
export WIFI_MODE=${WIFI_MODE:-"client"}
echo "-     WIFI_SSID       - Network to connect to or to serve as router. Default: 'yasbinet'"
export WIFI_SSID=${WIFI_SSID:-"yasbinet"}
echo "-     WIFI_PWD        - Password to for the network. Default: 'fortytwo'"
export WIFI_PWD=${WIFI_PWD:-"fortytwo"}
echo "-     WIFI_STATIC_IP  - Defines a static IP within the network (only useful in client mode). Default: not set (DHCP is used)"
echo "- Set values by exporting them or prepending the build command with them. "
echo 
export BB_ENV_EXTRAWHITE="$BB_ENV_EXTRAWHITE ROOT_PASS \
                            WIFI_ENABLED WIFI_MODE WIFI_SSID WIFI_PWD WIFI_STATIC_IP" 

echo "- Generating Yocto config files in the build tree..."

CONF_DIR="$PROJECT_ROOT/conf"

# Make sure, the target machine configuration can be found
if [[ ! -d "$CONF_DIR/$TARGET_MACHINE/" \
      || ! -f "$CONF_DIR/$TARGET_MACHINE/machine.conf" \
      || ! -f "$CONF_DIR/$TARGET_MACHINE/bblayers.append.conf" ]]; then
    echo_red "Error: Could not find machine.conf or bblayers.append.conf for the specified target. Aborting build." && exit
fi

write_conf "$CONF_DIR/bblayers.conf" "bblayers.conf"
write_conf "$CONF_DIR/$TARGET_MACHINE/bblayers.append.conf" "bblayers.conf" true

write_conf "$CONF_DIR/common/build.conf \
            $CONF_DIR/common/system.conf \
            $CONF_DIR/common/features/base.conf" "local.conf"

if [[ "$WIFI_ENABLED" = true ]]; then 
    write_conf "$CONF_DIR/common/features/wifi.conf" "local.conf" true
    if [[ -f "$CONF_DIR/$TARGET_MACHINE/features/wifi.append.conf" ]]; then 
        write_conf "$CONF_DIR/$TARGET_MACHINE/features/wifi.append.conf" "local.conf" true
    fi
fi

if [[ "$BT_ENABLED" = true ]]; then 
    write_conf "$CONF_DIR/common/features/bluetooth.conf" "local.conf" true
fi

write_conf "$CONF_DIR/$TARGET_MACHINE/machine.conf" "local.conf" true 

echo 
echo_green "### Custom configuration done. ###"
echo 