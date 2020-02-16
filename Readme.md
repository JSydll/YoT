# Yasbi: Yocto-driven Raspberry Pi 3

This is a self-learning project, aiming at creating a custom distro for the Raspi 3 accounting for some usual use cases in connected products / IoT.

## Requirements
- Basic, headless image
- Security features enabled by default
- Ssh-able image without runtime configuration
- Wifi-enabled image without runtime configuration

## Infrastructure and dependencies

To have the possibility to easily get the latest changes from the repositories this repo depends on, `git subtree` is used. This enables easy amendments made to the whole tree without committing to the external repos.

**Dependencies / Yocto layers**:
- yocto/poky: 
  - Repo: https://git.yoctoproject.org/git/poky
  - Branch: zeus
- meta-openembedded:
  - Repo: https://git.openembedded.org/meta-openembedded
  - Branch: zeus 
  - Dependencies: core
- meta-swupdate: 
  - Repo: https://github.com/sbabic/meta-swupdate 
  - Branch: zeus
  - Dependencies: core, meta-oe
- meta-security:
  - Repo: https://git.yoctoproject.org/git/meta-security
  - Branch: zeus
  - Dependencies: meta-oe, meta-networking, meta-python, meta-perl
- meta-raspberrypi:
  - Repo: https://git.yoctoproject.org/git/meta-raspberrypi
  - Branch: zeus 
  - Dependencies: meta-oe, meta-multimedia, meta-networking, meta-python


## Setup

1. Run `sudo ./install-deps.sh` to get required packages for a Yocto build.
2. Run `scripts/build-minimal.sh` to build a minimal image.
   

## Sources
- [Basic Instructable to build a Yocto image](https://www.instructables.com/id/Building-GNULinux-Distribution-for-Raspberry-Pi-Us/)
- [More advanced guide/cutomized build process](https://jumpnowtek.com/rpi/Raspberry-Pi-Systems-with-Yocto.html)
- [Rtfm meta-raspberry-pi](https://meta-raspberrypi.readthedocs.io/en/latest/readme.html)
- [Exporting environment variables to bitbake](https://stackoverflow.com/questions/17366984/is-it-possible-to-pass-in-command-line-variables-to-a-bitbake-build)


## To dos
- Enable build-time configuration of wifi
- Enable build-time configuration of ssh (ports, etc)
- Move custom configuration/functionality in own layer (ie `meta-yasbi`)
  - Leave only dependencies on outermost local.conf, features etc should go into `meta-yasbi`
- Configure swupdate layer
- Configure security layer
- Create minimal sample application in `meta-yasbi-test`