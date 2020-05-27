# -------------------
# Sets all parameters used to patch the configuration template file
# -------------------
def generate_config(datastore):
    params = { 
        "UPDATE_IMAGE_VERSION": datastore.getVar("UPDATE_IMAGE_VERSION"),
        "UPDATE_IMAGE_HWCOMPAT": datastore.getVar("UPDATE_IMAGE_HWCOMPAT"),
        "UPDATE_IMAGE_FILENAME": datastore.getVar("UPDATE_IMAGE_FILENAME"),
        "UPDATE_MEM_DEVICE": datastore.getVar("UPDATE_MEM_DEVICE")
        }
    return params