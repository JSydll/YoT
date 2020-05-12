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
    srcs=""
    params=($1)
    # Enable several source configuration files to be passed in
    # and prepend the config folder
    for src in "${params[@]}"; do
        srcs="$srcs $PROJECT_ROOT/conf/$src"
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
echo "For available options check out the layer desciptions. The only top level option set here \
is the TARGET_MACHINE, selecting the hardware specific configurations (defaults to 'raspberrypi3')."
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

# Configuration source path
CONF="$PROJECT_ROOT/conf"

# Make sure, the target machine configuration can be found
if [[ ! -f "$CONF/targets/$TARGET_MACHINE/machine.conf" \
      || ! -f "$CONF/targets/$TARGET_MACHINE/bblayers.append.conf" ]]; then
    echo_red "Error: Could not find machine.conf or bblayers.append.conf for the specified target. Aborting build." && exit
fi

echo "Generating Yocto config files in the build tree..."

# Basic config
write_conf "bblayers.conf" "bblayers.conf"
write_conf "local.conf" "local.conf"

# Target settings
write_conf "targets/$TARGET_MACHINE/bblayers.append.conf" "bblayers.conf" true
write_conf "targets/$TARGET_MACHINE/machine.conf" "local.conf" true 

# Adjustments according to imported configuration

if [[ "$DEBUG" = "1" ]]; then
    write_conf "image/debug.conf" "local.conf" true
fi

if [[ "$WIFI_ENABLED" = "1" || "$BT_ENABLED" = "1" ]]; then
    write_conf "layers/connectivity.conf" "bblayers.conf" true
fi
if [[ "$WIFI_ENABLED" = "1" && -f "$CONF/targets/$TARGET_MACHINE/wifi.append.conf" ]]; then 
    write_conf "targets/$TARGET_MACHINE/wifi.append.conf" "local.conf" true
fi

if [[ -n "$APP_CMAKE_URL" ]]; then
    write_conf "layers/cmakeapp.conf" "bblayers.conf" true
fi

echo 
echo_green "### Custom configuration done. ###"
echo 