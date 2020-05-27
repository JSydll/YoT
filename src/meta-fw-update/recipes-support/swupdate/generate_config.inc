# -------------------
# Sets all parameters used to patch the configuration template file
# -------------------
def generate_config(datastore):
    params = { 
        "IDENTITY_NAME": datastore.getVar("MACHINE"),
        "IDENTITY_VERSION": "1.0",
        "ROOTFS_OVERLAY_PATH": "/media/etc"
        }
    return params