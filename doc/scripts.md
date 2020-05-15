# Scripts

The bash scripts provided in `/scripts` implement the core mechanisms to enable the 
upfront configuration of the build as well as some development utilities.


## Overview of available scripts 

### Dependency management

More on the `gitsubtree.sh` script can be found on the [dependencies documentation](dependencies.md).


### Configuration

`configure.sh` provides the main Yocto configuration files (`local.conf` and `bblayers.conf`) to the 
bitbake build tree and pipes custom environment variables to bitbake leveraging the `BB_ENV_EXTRAWHITE` 
functionality.

`init.sh` only sets up the bitbake environment so that arbitrary operations with bitbake can be made 
in the build tree.


### Building

`build.sh` runs the complete flow from dynamically configuring the Yocto build as described above to 
starting the actual build process. It offers the possibility to pass arbitrary arguments to it that 
end up being appended to the `bitbake` command. With that, you can specify image names and build options, 
for example select another image and show the bitbake environement after the build completes with

```bash
./build.sh -e my-custom-image # expands to: bitbake -e my-custom-image
```


### Inspecting the created image

`image.sh` provides some functionalities to inspect an image built, mainly a shorthand to mount it in the build 
directory (`source scripts/image.sh; image_mount <machineName> <imageName> <mountPoint>`).


### Script utilities 

`utils.sh` provides some convenience functions and helpers used in the other scripts.


