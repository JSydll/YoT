# -------------------
# Configuration/creation of systemd network files
# -------------------

# Depends on the following custom env vars exported to the yocto build:
# - STATIC_IP_V4
# - STATIC_IP_V6
# - WIFI_ENABLED
# - WIFI_SSID
# - WIFI_PWD

# The default setting is to use DHCP.

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://eth.network \
    file://en.network \
    file://wlan.network \
"

FILES_${PN} += " \
    ${sysconfdir}/systemd/network/eth.network \
    ${sysconfdir}/systemd/network/en.network \
    ${sysconfdir}/systemd/network/wlan.network \
"

# Use the preplace class to patch template source files
inherit preplace
include generate_config.inc

WORK_FILES = "\
    ${WORKDIR}/en.network \
    ${WORKDIR}/eth.network \
    ${WORKDIR}/wlan.network \
"

python do_patch_append() {
    params = generate_config(d)
    files = d.getVar('WORK_FILES', True).split()
    for file in files:
        preplace_do_replace(file, params)
}

do_install_append() {
    install -d ${D}${sysconfdir}/systemd/network
    install -m 0644 ${WORKDIR}/eth.network ${D}${sysconfdir}/systemd/network
    install -m 0644 ${WORKDIR}/en.network ${D}${sysconfdir}/systemd/network
    install -m 0644 ${WORKDIR}/wlan.network ${D}${sysconfdir}/systemd/network
}