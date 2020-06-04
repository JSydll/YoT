# meta-fw-update-raspberrypi

Aside from some general configuration for firmware updates, very target specific adjustments 
of the build are necessary to have a running and updateable image. This layer provides these 
for the raspberrypi machine, also using the `swupdate` framework.

This layer depends on `meta-fw-update` for general `swupdate` configuration and `meta-hardening` 
in particular for a secure `overlayfs` configuration. As stated in the documentation of `meta-fw-update`, 
the main tasks to be performed are configuring the U-Boot bootloader as well as providing a 
proper partition layout.

## Configuring U-Boot

The BSP layer for the RaspberryPi (`meta-raspberrypi`) comes with a recipe to install the boot 
script: `recipes-bsp/rpi-uboot-scr`. This layer overwrites the default script with one based on 
a *bootloader environment variable* indicating which partition should be booted. It will be set 
after successful download of the update file or when something during the process failed.

This variable is named **fw_part** and stores the *partition number* of the active partition.

Additionally, a proper configuration file for `libubootenv` depending on the memory layout of 
the target is provided.

## Creating a partition layout

A common security practice is to hide the rootfs from the user by only exposing certain parts of it, 
using an overlay. Therefore, the rootfs itself *should be read-only* by default. 

Expected partition layout (needed by `meta-fw-update`):
```
p1 - boot
p2 - rootfs copy1 [r/o squashfs]
p3 - rootfs copy2 [r/o squashfs]
p4 - system (mount point for overlayfs) [r/w ext4]
p5 - data (user/application data) [r/w ext4]
```

## Resources

Almost all code is taken from the [RaspberryPi 3 example by the swupdate developers](https://github.com/sbabic/meta-swupdate-boards), 
with a bit more documentation, some minor enhancements and a restructuring into two layers differentiating 
between general `swupdate` configuration and target specific operations.