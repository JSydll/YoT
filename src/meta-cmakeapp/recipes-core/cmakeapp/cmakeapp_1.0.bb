# -------------------
# Builds an application hosted on a remote git and (optionally) creates a systemd service that launches it on system boot
# -------------------

# Depends on the following custom env vars exported to the yocto build:
# - APP_CMAKE_URL
# - APP_CMAKE_TAG
# - APP_CMAKE_AUTOLOAD
# - APP_CMAKE_EXECUTABLE
# - APP_CMAKE_INSTALL_PATH
# - APP_CMAKE_EXEC_USER

DESCRIPTION = "Setup a specific keyboard-layout for the console"

LICENSE = "CLOSED"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRCREV = "${AUTOREV}"
SRC_URI = "git://${APP_CMAKE_URL};protocol=https;${@ 'tag=' + d.getVar('APP_CMAKE_TAG') if d.getVar('APP_CMAKE_TAG') != None else ''} \
    file://app-autostart.service \
"

S = "${WORKDIR}/git"

inherit pkgconfig cmake systemd

SYSTEMD_AUTO_ENABLE = "enable"
SYSTEMD_SERVICE_${PN}_append = " ${APP_CMAKE_EXECUTABLE}.service "

# Use the preplace class to patch template source files
inherit preplace
require generate_config.inc

TEMPLATE_FILE = "${WORKDIR}/app-autostart.service"

python do_patch_append() {
    params = generate_config(d)
    preplace_execute(d.getVar('TEMPLATE_FILE', True), params)
}

do_install_append () {
    install -D -p -m 0644 ${WORKDIR}/app-autostart.service ${D}${systemd_unitdir}/system/${APP_CMAKE_EXECUTABLE}.service
}