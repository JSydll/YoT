# YoT: Yocto-driven IoT devices

This project aims at creating a custom reference distro for embedded devices (like the Raspberry Pi 3 
and possibly later on some more hardware platforms) in the context of connected products / IoT. 

It leverages existing software layers from the Yocto/OpenEmbedded community whenever possible and 
extends their configuration / default settings.

With the provided wrapper scripts around bitbake and the *YAML*-based configuration file, 
a user is able to specify the desired setup (e.g. what functionality to include, which settings 
to default to) *before* running the build in a transparent manner. The layers in `src` dynamically 
build the desired configuration depending on environment variables exported into the bitbake execution 
context.

So far, the implementation is based on the following approaches:
- one main configuration file (`config.yml`) defines environment variables exported to bitbake
- *bash*-scripts generate appropriate build-files (mainly `bblayers.conf` and `local.conf`), 
  export the env vars to bitbake and run the Yocto build
- layers in `src` extend existing packages (e.g. `systemd` or `openssh`), implementing 
  additional functionalities mostly in pure python or shell 

A few requirements drove what is currently implemented or planned to be:

## Requirements

**Appliance**
- The target is supposed to run *headless* (no keyboard/monitor attached)
  
**General system environment**
- Predefined users and groups should already be set up
- It should be *convenient* to use the system by providing usual tools and settings

**Connectivity**
- If the target supports wired or wireless connections, it should be able to connect to 
  existing networks out-of-the-box
- A user should be able to ssh onto the target without further setup

**Security**
- State-of-the-art security features should be enabled by default

**Firmware updates**
- It should be possible to update the firmware remotely.

**Application integration**
- The system should provide a way to import an existing (CMake) application and include it in the image.
- The application should run on boot.

**Development**
- Developers should be able to debug the system with an extended set of tools / configuration.


## Documentation 

- [Explanation of the repository structure](doc/structure.md)
- [Software foundation and dependencies](doc/dependencies.md)
- [Scripts for execution and convenience](doc/scripts.md)
- [Configuration of the build process and image](doc/configuration.md)
- [Resources and further reading](doc/resources.md)


## Overview of current features

Aside from collecting the required layers and configuring them, this projects adds scripts to configure 
the images as well as some custom layers with additional functionality. Among these are:

- `meta-common` [doc](src/meta-common/Readme.md)
  Provides commonly used classes to process the configuration variables and deal with template files.
- `meta-userenv` [doc](src/meta-userenv/Readme.md)
  Sets up users, groups and general system settings like hostname or keyboard layout.
- `meta-connectivity` [doc](src/meta-connectivity/Readme.md)
  Connectivity related features like compile-time network/wifi configuration or ssh setup.
- `meta-fota` [doc](src/meta-fota/Readme.md)
  Adds update related functionalities to the image.
- `meta-hardening` [doc](src/meta-hardening/Readme.md)
  Extends/configures the security layer to provide a secure system.
- `meta-application` [doc](src/meta-application/Readme.md)
  Provides a wrapper for an external application built and deployed in the image (currently only for a 
  CMake-based project).


## Installation

So far, only an Ubuntu 18.04. host was tested for building the project. On that, you can simply 
clone this repo and run `sudo ./install-deps.sh` to get required Ubuntu packages for a Yocto build.

Thanks to `git subtree` (see [dependency docs](doc/dependencies.md) for more) you do not need to 
pull any submodules.


## Configuration

Configuring and customizing the image works via one file, `config.yml`. The currently supported set 
of variables (aside from those natively used by Yocto) can be found in the `config-sample.yml` 
file. Details how it works are documented in the [configuration docs](doc/configuration.md).


## Execution

You can run arbitrary commands within the bitbake environment (e.g. `bitbake-layers create-layer`) with
```bash
source ./scripts/init.sh
```

To build an YoT image, you have to create a `config.yml` file first (see above). Afterwards, you can 
build the default image with
```bash
./scripts/build.sh
```

If you need to pass additional parameters to bitbake, you can treat the script as the bitbake command and 
do something like `./scripts/build.sh -e core-image-base | grep ^INSTALL_IMAGE=`. More on debugging in 
[the docs](doc/yocto-debugging.md).

Note that all script assume you execute them in the project root directory.


## To dos

Several features are not complete or not existant at all. This is the project's todo list:
- Wifi AP mode?
- Remove meta-yocto-bsp?
- Firewall setup (iptables)
- Overlay fs w/ data partition filling whole space
- Enable build-time configuration of ssh
  - ports
  - installed pub keys
- Testing the image
- Configure swupdate layer
- Configure security layer