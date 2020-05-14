# -------------------
# Configuration of openssh
# -------------------

# Depends on the following custom env vars exported to the yocto build:
# - DEBUG_SSH_ROOT
# - SSH_PREINSTALLED_KEYS

require key_provisioning.inc

FILES_${PN} += "${@ generated_files(d) }"

do_install_append() {
    if [ "${DEBUG_SSH_ROOT}" = "1" ]; then
        sed -i 's|^#\(PermitRootLogin\).*|\1 yes|' ${D}${sysconfdir}/ssh/sshd_config
    fi
    if [ -n "${SSH_PREINSTALLED_KEYS}" ]; then
        eval "${@ install_keys(d) }"
    fi
}