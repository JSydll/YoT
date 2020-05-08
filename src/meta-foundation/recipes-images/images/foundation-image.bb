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

# -------------------
# Creates useradd commands to be executed by the extrausers extension
# -------------------
def get_useradd_commands(d):
    names = d.getVar('USERS_ADD_NAMES')
    names = [] if names == None else names.split(';')
    pwds = d.getVar('USERS_ADD_PWDS')
    pwds = [] if pwds == None else pwds.split(';')
    if len(names) != len(pwds):
        return ""
    cmd = ""
    for i in range(len(names)):
        cmd += "useradd -P " + pwds[i] + " " + names[i] + "; "
    return cmd

inherit extrausers
EXTRA_USERS_PARAMS = "\
    usermod -P ${USERS_ROOT_PWD} root; \
    ${@get_useradd_commands(d)} \
"

IMAGE_INSTALL_append = " loadkeys "