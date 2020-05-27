# meta-fw-update

There are several possibilities to enable (remote) updates for a Linux distribution built with Yocto. 
A comprehensive list of community layers for this functionality with the respective pros and cons can 
be found [here](https://wiki.yoctoproject.org/wiki/System_Update).

Updates can be performed incrementally or in A/B mode - the former reduces the transmission size 
significantly but comes with the risk of unstable system state if one increment is dysfunctional, 
the latter has the disadvantage of large update files while providing a fully isolated second rootfs. 
For simplicity, this layer only implements the A/B schema.

As one of the well documented and maintained update solutions is sbabic's **`swupdate`**, this layer 
builds on top of it.

Three main tasks need to be done:
- Creating an image with the correct partitioning layout
- Preparing the target to use U-Boot and specific bootloader env vars
- Configuring `swupdate` (by providing update scripts and configuration files)

Some parts of these tasks can be generalized (mostly using file templates or generating files during build) 
which is the main goal of this layer. Others depend on the target (like partitioning by providing a wks file) 
hence need to be implemented in a distinct `meta-fw-update-<machine>` layer.

## Configuring U-Boot

`meta-swupdate` comes with a recipe to make sure proper binaries of U-Boot are installed and environment 
variables can be passed to it (`libubootenv`). In this layer, the installation of a configuration file is 
performed, expecting actual configuration to happen in the target specific layer again.

## Partitioning

Expected: p2 and p3 are rootfs partitions