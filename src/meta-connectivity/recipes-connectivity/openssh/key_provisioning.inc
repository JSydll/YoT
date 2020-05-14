# -------------------
# Implementations for the provisioning of ssh keys
# -------------------

inherit flatarray

# -------------------
# Fetches users and their key paths from the datastore
# ------------------
def get_userkeys(d):
    userkeys = {}
    arr = d.getVar('SSH_PREINSTALLED_KEYS')
    if (arr == None) or (len(arr) == 0):
        return userkeys
    pairs = flatarray_parse(arr)
    for pair in pairs:
        kv = flatarray_parse(pair, ':')
        userkeys[kv[0]] = kv[1]
    return userkeys

# -------------------
# Lists files that are installed
# ------------------
def generated_files(d):
    userkeys = get_userkeys(d)
    if len(userkeys) == 0: 
        return ""
    return "/home/*"

# -------------------
# Creates useradd commands to be executed by the extrausers extension
# -------------------
def install_keys(d):
    script = ""
    workdir = d.getVar('WORKDIR')
    userkeys = get_userkeys(d)
    for usr, key in userkeys.items():
        tmp = workdir + '/ssh_keys/' + usr 
        # Create local authorized_keys file
        script += "mkdir -p " + tmp + "; "
        src = tmp + "/authorized_keys" 
        script += "echo \"$(cat " + key + ")\" > " + src + "; "
        # Install local file with correct permissions
        # TODO Use proper permmissions
        # perm = "-o " + usr + " -g " + usr
        perm = ""
        dest = d.getVar('D') + '/home/' + usr + '/.ssh/authorized_keys'
        script += "install -D" + perm + " -m 600 " + src + " " + dest + "; "
    return script