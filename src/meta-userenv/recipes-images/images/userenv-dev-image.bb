# -------------------
# meta-userenv development image
#
# Mainly extends the core image with new recipes introduced in this layer
# (appends will be automatically added) and performs global image operations
# -------------------
SUMMARY = "Same as the userenv-prod-image but with some debug facilities"

IMAGE_LINGUAS = " "

LICENSE = "MIT"

inherit core-image
require userenv-prod-image.bb

IMAGE_FEATURES_append = " tools-debug debug-tweaks "