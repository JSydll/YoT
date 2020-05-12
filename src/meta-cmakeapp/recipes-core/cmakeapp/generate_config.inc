# -------------------
# Sets all parameters used to patch the service template file
# -------------------
def generate_config(datastore):
    params = { 
        "EXECUTABLE": datastore.getVar("APP_CMAKE_EXECUTABLE"),  
        "EXEC_USER": datastore.getVar("APP_CMAKE_EXEC_USER"),
        "PATH": datastore.getVar("APP_CMAKE_INSTALL_PATH")
        }
    return params