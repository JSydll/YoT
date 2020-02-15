#!/bin/bash

# -----------------------------------------------------------
# Dependencies for a Yocto build on an Ubuntu 18.04 LTS host.
# -----------------------------------------------------------

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Yocto only supports python 2.7, Ubuntu comes with python 3 only.
sudo apt install -y python
# Dependencies as mentioned on https://www.yoctoproject.org/docs/2.0/yocto-project-qs/yocto-project-qs.html
sudo apt-get install -y gawk wget git-core diffstat unzip texinfo gcc-multilib \
    build-essential chrpath socat libsdl1.2-dev xterm

