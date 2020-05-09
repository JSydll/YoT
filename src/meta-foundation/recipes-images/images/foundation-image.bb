# -------------------
# meta-foundation image
#
# Mainly extends the core image with new recipes introduced in this layer
# (appends will be automatically added) and performs global image operations
# -------------------
SUMMARY = "Foundation image built on top of the core-image-minimal \
with additional features provided in the meta-foundation layer"

IMAGE_LINGUAS = " "

LICENSE = "MIT"

inherit core-image

# -------------------
# Adds custom recipes of this layer
# -------------------
IMAGE_INSTALL_append = " loadkeys "


# -------------------
# Setups users and groups
# -------------------

# Depends on the following custom env vars exported to the yocto build:
# - USERS_ROOT_PWD

inherit usergroups
inherit extrausers

EXTRA_USERS_PARAMS = "\
    usermod -P ${USERS_ROOT_PWD} root; \
    ${@usergroups_setup_groups(d)} \
    ${@usergroups_setup_users(d)} \
"