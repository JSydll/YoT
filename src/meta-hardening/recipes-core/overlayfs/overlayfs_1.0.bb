# -------------------
# Installs systemd unit preparing and mounting r/w overlays for specific directories
# 
# Currently adds overlays with read-write access for
#   /etc    - Needs to be r/w for proper system operation
# 
# The rootfs itself must be read-only.
# -------------------

DESCRIPTION = "Adds overlays to the filesystem to control access from the user space"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SECTION = "base"

SRC_URI = " \
    file://etc.mount \
    file://overlayfs-directories.service \
"

inherit systemd

do_install () {
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/etc.mount ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/overlayfs-directories.service ${D}${systemd_system_unitdir}
}

SYSTEMD_SERVICE_${PN} = "etc.mount overlayfs-directories.service"