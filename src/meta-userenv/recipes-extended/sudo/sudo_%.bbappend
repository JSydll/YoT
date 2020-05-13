# -------------------
# Enables sudo group
# -------------------

# Depends on the following custom env vars exported to the yocto build:
# - ENV_SUDO_ENABLED
# - ENV_SUDO_NOPASSWD

do_install_append() {
    if [ "${ENV_SUDO_ENABLED}" = "1"]; then
        # Searches for the line '# %sudo' and uncomments it
        sed -i 's/^#\s*\(%sudo)/\1/' ${D}${sysconfdir}/sudoers
        if [ "${ENV_SUDO_NOPASSWD}" = "1" ]; then
            # Searches for the %sudo line without the NOPASSWD setting
            sed -i 's/^\(%sudo\s\+ALL=(ALL:ALL)\)\s\+\(ALL\)/\1 NOPASSWD:\2/' ${D}${sysconfdir}/sudoers
        fi
    fi
}