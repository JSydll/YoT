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
# Creates and modifies users and groups in the rootfs
# -------------------

# Depends on the following custom env vars exported to the yocto build:
# - GROUPS_ADD_NAMES
# - USERS_ROOT_PWD
# - USERS_ADD_NAMES
# - USERS_ADD_PWDS
# - USERS_ADD_GROUPS

inherit flatarray
# -------------------
# Creates groupadd commands to be executed by the extrausers extension
# -------------------
def get_groupadds(d):
    groups = flatarray_parse(d.getVar('GROUPS_ADD_NAMES'))
    cmd = ""
    for group in groups:
        if group != "":
            cmd += "groupadd " + group + "; "
    return cmd

# -------------------
# Creates useradd commands to be executed by the extrausers extension
# -------------------
def get_useradds(d):
    names = flatarray_parse(d.getVar('USERS_ADD_NAMES'))
    pwds = flatarray_parse(d.getVar('USERS_ADD_PWDS'))
    groups = flatarray_parse(d.getVar('USERS_ADD_GROUPS'))
    if len(names) != len(pwds):
        return ""
    cmd = ""
    for i in range(len(names)):
        # Do not allow empty passwords (and of course no empty names either)
        if pwds[i] == "" or names[i] == "":
            continue
        # Assume clear-text password here (-P option - would be -p if encrypted)
        cmd += "useradd -P " + pwds[i] + " " + names[i] + "; "
        if groups[i] != None and groups[i] != "":
            # Append the user (-a) to secondary groups (-G)
            cmd += "usermod -a -G " + groups[i] + " " + names[i] + "; "
    return cmd

inherit extrausers
EXTRA_USERS_PARAMS = "\
    usermod -P ${USERS_ROOT_PWD} root; \
    ${@get_groupadds(d)} \
    ${@get_useradds(d)} \
"