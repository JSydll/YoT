# -------------------
# meta-foundation image
# -------------------

# Depends on the following custom env vars exported to the yocto build:
# - USERS_ROOT_PWD

SUMMARY = "Foundation image built on top of the core-image-minimal \
with some minor adjustments"

IMAGE_LINGUAS = " "

LICENSE = "MIT"

inherit core-image

inherit extrausers
EXTRA_USERS_PARAMS = "\
    usermod -P ${USERS_ROOT_PWD} root; \
"

IMAGE_INSTALL_append = " loadkeys "