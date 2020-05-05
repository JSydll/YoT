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

- [Explanation of the repository structure](doc/Structure.md)
- [Software foundation and dependencies](doc/Dependencies.md)
- [Scripts for execution and convenience](doc/Scripts.md)
- [Configuration of the build process and image](doc/Configuration.md)
- [Resources and further reading](doc/Resources.md)

## Setup

1. Run `sudo ./install-deps.sh` to get required Ubuntu packages for a Yocto build.
2. Run `./scripts/build-minimal.sh` to build a minimal image.
   
## Configuration

Customizing the image works via environment variables. The currently supported set of 
variables (aside from those natively used by Yocto) can be found in the `.env.sample` 
file. Details how it works are documented on the [Configuration page](doc/Configuration.md).


## To dos
- Enable build-time configuration of wifi
- Enable build-time configuration of ssh (ports, etc)
- Move custom configuration/functionality in own layer (ie `meta-user`)
  - Leave only dependencies on outermost local.conf, features etc should go into `meta-user`
- Configure swupdate layer
- Configure security layer
- Create minimal sample application in `meta-app`