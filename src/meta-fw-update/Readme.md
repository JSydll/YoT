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

**Documentation for sbabic's `swupdate` can be found [here](https://sbabic.github.io/swupdate/overview.html)**. 
The overview also makes up a great introduction into the concepts of embedded firmware updates.

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

The partitioning itself needs to be done in a target specific layer as memory devices and layouts differ from 
platform to platform. Here it is expected that the image features two rootfs partitions (namely p2 and p3) as 
the A/B slots.

## Resources

Almost all code is taken from the [RaspberryPi 3 example by the swupdate developers](https://github.com/sbabic/meta-swupdate-boards), 
with a bit more documentation, some minor enhancements and a restructuring into two layers differentiating 
between general `swupdate` configuration and target specific operations.