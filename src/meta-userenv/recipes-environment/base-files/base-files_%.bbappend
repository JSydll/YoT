# -------------------
# Adjustments to the basic configuration files
# -------------------

# Depends on the following custom env vars exported to the yocto build:
# - ENV_HOSTNAME

hostname="${ENV_HOSTNAME}"

# -------------------
# Overwrites the /etc/issue file with custom distro info
# ------------------
overwrite_issue(){
    printf "%s " "${ENV_DISTRO_NAME}" > ${D}${sysconfdir}/issue
    printf "%s " "${ENV_DISTRO_VERSION}" >> ${D}${sysconfdir}/issue
    printf "\\\n \\\l\n" >> ${D}${sysconfdir}/issue
	echo >> ${D}${sysconfdir}/issue
}

do_install_append(){
    overwrite_issue
}