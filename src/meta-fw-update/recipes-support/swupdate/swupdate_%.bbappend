# -------------------
# Installs a basic swupdate configuration and a partition selection script
# -------------------

FILESEXTRAPATHS_append := "${THISDIR}/files:"

PACKAGECONFIG_CONFARGS = ""

SRC_URI += " \
    file://09-swupdate-args \
    file://swupdate.cfg \
    "
# Use the preplace class to patch template source files
inherit preplace
require generate_config.inc

TEMPLATE_FILES = "\
    ${WORKDIR}/swupdate.cfg \
    ${WORKDIR}/09-swupdate-args \
    "

python do_patch_append() {
    params = generate_config(d)
    files = d.getVar('TEMPLATE_FILES', True).split()
    for file in files:
        preplace_execute(file, params)
}

do_install_append() {
    install -m 0644 ${WORKDIR}/09-swupdate-args ${D}${libdir}/swupdate/conf.d/

    install -d ${D}${sysconfdir}
    install -m 644 ${WORKDIR}/swupdate.cfg ${D}${sysconfdir}
}
