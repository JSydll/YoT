# -------------------
# General configuration of the systemd package
# -------------------

# Explicitely enable networkd and resolved
PACKAGECONFIG_append = " networkd resolved"
# Ensure the wpa-supplicant is available 
RDEPENDS_${PN}_append = " wpa-supplicant "