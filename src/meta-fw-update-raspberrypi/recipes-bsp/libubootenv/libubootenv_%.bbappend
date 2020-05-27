# -------------------
# Overwrites the source files for the U-Boot fw_env configuration
# -------------------

# Instead of the initial implementation, the files provided here should be used:
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

COMPATIBLE = "raspberrypi3"