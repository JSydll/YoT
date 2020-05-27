# -------------------
# Provides an swupdate compatible image
# -------------------

# Depends on the following custom env vars exported to the yocto build:
# - UPDATE_IMAGE_BASE
DESCRIPTION = "Provides an image with update capability"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit swupdate

SRC_URI = "\
    file://emmcsetup.lua \
    file://sw-description \
"

# Image to build before the swupdate image and to include in the .swu image
IMAGE_DEPENDS = "${UPDATE_IMAGE_BASE}"
SWUPDATE_IMAGES = "${UPDATE_IMAGE_BASE}"

SWUPDATE_IMAGES_FSTYPES += ".ext4.gz"

# Use the preplace class to patch template source files
inherit preplace
require generate_config.inc

TEMPLATE_FILES = "\
    ${WORKDIR}/install.lua \
    ${WORKDIR}/sw-description \
    "

python do_patch_append() {
    params = generate_config(d)
    files = d.getVar('TEMPLATE_FILES', True).split()
    for file in files:
        preplace_execute(file, params)
}