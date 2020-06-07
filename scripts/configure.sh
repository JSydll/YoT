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
# Checks wether the provided path points to a regular conf file
# ------------------------
is_conf_file() {
    [[ -f "$PROJECT_ROOT/conf/$1" ]] && echo 0 || echo 1
}

# ------------------------
# Checks for existance and writes the content of one or more config files ($1) into the build config file ($2)
# Appends to the file if $3 is provided and true.
# Does not perform any checks and is meant for use here only.
# ------------------------
write_conf() {
    srcs=""
    params=($1)
    # Enable several source configuration files to be passed in
    # and prepend the config folder
    for src in "${params[@]}"; do
        if [[ $(is_conf_file "$src") ]]; then
            srcs="$srcs $PROJECT_ROOT/conf/$src"
        fi
    done
    if [[ -z "$3" || "$3" = false ]]; then
        cat $srcs > $PROJECT_ROOT/build/conf/$2
    else
        cat $srcs >> $PROJECT_ROOT/build/conf/$2     
    fi
}
echo_orange "### Custom configuration ###"

echo "You can customize the configuration by providing a config.yml file in the root folder. \
It will be automatically loaded and all variables in it exported to the build environment."
echo "For available options check out the layer desciptions. The only top level options set here are: "
echo " - TARGET_MACHINE, selecting the hardware specific configurations (defaults to 'raspberrypi3')"
export TARGET_MACHINE=raspberrypi3
echo " - UPDATE_ENABLED, controlling the update behavior (defaults to '1')"
export UPDATE_ENABLED=1
echo 

# Try to locate .env script, export the variables and forward them to bitbake.
if [[ -f "$PROJECT_ROOT/config.yml" ]]; then 

    envars=($(parse_yaml $PROJECT_ROOT/config.yml)) 
    for pair in "${envars[@]}"; do
        export "$pair"
        kv=(${pair//=/ })
        export BB_ENV_EXTRAWHITE="$BB_ENV_EXTRAWHITE ${kv[0]}"
    done
    echo "-- Custom configuration found: "
    env_pretty_print $envars
    echo 

    if [[ -z "$USERS_ROOT_PWD" ]]; then
        echo_orange "No root password supplied - generating one..."
        export USERS_ROOT_PWD=$(openssl rand -hex 16)
        export BB_ENV_EXTRAWHITE="$BB_ENV_EXTRAWHITE USERS_ROOT_PWD"
        echo_green "Generated password (please save, will not be stored): $USERS_ROOT_PWD"
        echo 
    fi
fi

# Make sure, the target machine configuration can be found
TARGET_LAYERS="targets/$TARGET_MACHINE/layers"
TARGET_CONF="targets/$TARGET_MACHINE/conf"
NON_DEFAULT_TARGET=0
if [[ ! $(is_conf_file "$TARGET_LAYERS/bsp.conf") || ! $(is_conf_file "$TARGET_CONF/machine.conf") ]]; then
    echo_red "Error: Could not find machine.conf or bsp.conf for the specified target."
    echo_orange "Assuming a natively supported target and including 'meta-yocto-bsp'..."
    echo 
    NON_DEFAULT_TARGET=1
fi

echo "Generating Yocto config files in the build tree..."

# General configuration
write_conf "bblayers.conf" "bblayers.conf"
write_conf "local.conf" "local.conf"

# Target configuration
if [ NON_DEFAULT_TARGET ]; then
    write_conf "$TARGET_LAYERS/bsp.conf" "bblayers.conf" true
    write_conf "$TARGET_CONF/machine.conf" "local.conf" true 
else
    write_conf "targets/default.conf" "bblayers.conf" true
fi

# Features
# Debugging
[[ "$DEBUG_ENABLED" = "1" ]] && write_conf "image/debug.conf" "local.conf" true;

# Connectivity
[[ "$WIFI_ENABLED" = "1" || "$BT_ENABLED" = "1" ]] && write_conf "layers/connectivity.conf" "bblayers.conf" true;
[[ "$WIFI_ENABLED" = "1" ]] && write_conf "$TARGET_CONF/wifi.conf" "local.conf" true;

# Firmware update
if [[ "$UPDATE_ENABLED" = "1" ]]; then
    write_conf "layers/fw-update.conf" "bblayers.conf" true
    write_conf "$TARGET_LAYERS/fw-update.conf" "bblayers.conf" true
    write_conf "$TARGET_CONF/fw-update.conf" "local.conf" true
fi

# Application
[[ -n "$APP_CMAKE_URL" ]] && write_conf "layers/application.conf" "bblayers.conf" true;

# Image generation
[[ "$IMAGE_MEM_DEVICE" != "mmc" ]] && echo_red "Creating images for '$IMAGE_MEM_DEVICE' is currently not supported." && exit 
if [[ "$UPDATE_ENABLED" = "1" && "$UPDATE_MODE" = "dual-copy" ]]; then
    write_conf "image/secure-dual-copy-$IMAGE_MEM_DEVICE.conf" "local.conf" true
else 
    write_conf "image/secure-base-$IMAGE_MEM_DEVICE.conf" "local.conf" true
fi

echo 
echo_green "### Custom configuration done. ###"
echo 