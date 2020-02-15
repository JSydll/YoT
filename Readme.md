# Yasbi: Yocto-driven Raspberry Pi

## Infrastructure and dependencies

To have the possibility to easily get the latest changes from the repositories this repo depends on, `git subtree` is used. This enables easy amendments made to the whole tree without committing to the external repos.

**Dependencies**:
- yocto/poky: 
  - Repo: https://git.yoctoproject.org/git/poky
  - Branch: zeus
- meta-raspberrypi:
  - Repo: https://git.yoctoproject.org/git/meta-raspberrypi
  - Branch: zeus 

## Setup

1. Run `sudo ./install-deps.sh` to get required packages for a Yocto build.
2. Run `scripts/build-minimal.sh` to build a minimal image.
   

## Sources
- [Basic Instructable to build a Yocto image](https://www.instructables.com/id/Building-GNULinux-Distribution-for-Raspberry-Pi-Us/)
- [More advanced guide/cutomized build process](https://jumpnowtek.com/rpi/Raspberry-Pi-Systems-with-Yocto.html)
- [Rtfm meta-raspberry-pi](https://meta-raspberrypi.readthedocs.io/en/latest/readme.html)
- [Exporting environment variables to bitbake](https://stackoverflow.com/questions/17366984/is-it-possible-to-pass-in-command-line-variables-to-a-bitbake-build)