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

1. Run `sudo ./installDependencies.sh` to get required packages for a yocto build.
   