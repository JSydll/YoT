# -------------------
# meta-foundation development image
#
# Mainly extends the core image with new recipes introduced in this layer
# (appends will be automatically added) and performs global image operations
# -------------------
SUMMARY = "Same as the fnd-prod-image but with some debug facilities"

IMAGE_LINGUAS = " "

LICENSE = "MIT"

inherit core-image
require fnd-prod-image.bb

IMAGE_FEATURES_append = " tools-debug debug-tweaks "