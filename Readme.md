# Yasbi: Yocto-driven Raspberry Pi 3

This is an evolving project, aiming at creating a custom distro for the Raspi 3 (and possibly later 
some more hardware platform) accounting for some usual use cases in connected products / IoT.

## Requirements for the image
- Basic, headless image
- Security features enabled by default
- Ssh-able without runtime configuration
- Wifi-enabled without runtime configuration
- Wrapper layer that fetches a repository, builds it with CMake, puts it in the image and 
  configures a systemd service to have it running

## Documentation 

- [Explanation of the repository structure](doc/structure.md)
- [Software foundation and dependencies](doc/dependencies.md)
- [Scripts for execution and convenience](doc/scripts.md)
- [Configuration of the build process and image](doc/configuration.md)
- [Resources and further reading](doc/resources.md)

## Prerequisites

Clone this repo and run `sudo ./install-deps.sh` to get required Ubuntu packages for a Yocto build.

## Execution

- Run `source ./scripts/init.sh` to initialize the yocto environment and to issue custom commands.
- Run `./scripts/build-minimal.sh` to build a minimal image. You can forward additional parameters 
  to the bitbake command by adding them to this call.
   
## Configuration

Customizing the image works via environment variables. The currently supported set of 
variables (aside from those natively used by Yocto) can be found in the `.env.sample` 
file. Details how it works are documented on the [Configuration page](doc/configuration.md).

## Main contents

Aside from collecting the required layers and configuring them, this projects adds 
scripts to configure the images as well as some custom layers with additional functionality. 
Among these are:

- `meta-foundation` with some foundational features like compile-time wifi configuration
- `meta-application` providing a wrapper for a CMake-based application built and deployed in the image


## To dos
- Support disabling of functionalities (on the layer/recipes levels)
- Wifi AP mode
- Hostname
- Debug image
- Keyboard layout
- Overlay fs w/ data partition filling whole space
- Enable build-time configuration of ssh (ports, etc)
- Configure swupdate layer
- Configure security layer
- Create minimal sample application in `meta-application`