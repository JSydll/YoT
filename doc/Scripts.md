# Scripts

## Overview of the scripts provided in `/scripts`

### Dependency management

More on the `gitsubtree.sh` script can be found on the [Dependencies page](Dependencies.md).

### Script utilities 

`script-utils.sh` provides some convenience functions and helpers used in the other scripts.

### Configuration

`configure.sh` provides the main Yocto configuration files (`local.conf` and `bblayers.conf`) to the 
bitbake build tree and pipes custom environment variables to bitbake leveraging the `BB_ENV_EXTRAWHITE` 
functionality.

