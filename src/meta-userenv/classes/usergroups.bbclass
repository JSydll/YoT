# -------------------
# Creates and modifies users and groups in the rootfs
# -------------------

# Depends on the following custom env vars exported to the yocto build:
# - GROUPS_ADD
# - USERS_ADD

inherit flatarray
# -------------------
# Creates groupadd commands to be executed by the extrausers extension
# -------------------
def usergroups_setup_groups(d):
    groups = flatarray_parse(d.getVar('GROUPS_ADD'))
    cmd = ""
    for group in groups:
        if group != "":
            cmd += "groupadd " + group + "; "
    return cmd

# -------------------
# Creates useradd commands to be executed by the extrausers extension
# -------------------
def usergroups_setup_users(d):
    users = flatarray_parse(d.getVar('USERS_ADD'))
    cmd = ""
    for user in users:
        # Expecting properties to be in form name|password[|group(s)]
        props = flatarray_parse(user, '|')
        # Do not allow empty passwords (and of course no empty names either)
        if len(props) < 2 or len(props[0]) == 0 or len(props[1]) == 0:
            continue
        # Assume clear-text password here (-P option - would be -p if encrypted)
        cmd += "useradd -P " + props[1] + " " + props[0] + "; "
        if len(props) == 3:
            groups = flatarray_parse(props[2], ',')
            for group in groups:
                # Append the user (-a) to secondary groups (-G)
                cmd += "usermod -a -G " + group + " " + props[0] + "; "
    return cmd

EXPORT_FUNCTIONS setup_groups setup_users