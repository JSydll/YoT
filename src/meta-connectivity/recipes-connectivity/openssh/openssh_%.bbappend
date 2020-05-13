# -------------------
# Configuration of openssh
# -------------------

# Depends on the following custom env vars exported to the yocto build:
# - DEBUG_SSH_ROOT

do_install_append() {
    if [ "${DEBUG_SSH_ROOT}" = "1" ]; then
        sed -i 's|^#\(PermitRootLogin\).*|\1 yes|' ${D}${sysconfdir}/ssh/sshd_config
    fi
}