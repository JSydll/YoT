# General learnings about Yocto

## Basic principles

One of Yocto's key concepts is the separation of functionality/configuration 
into layers. Upper layers extend or override lower ones (with `.bbappend` files). 
The base functionality is usually provided by the core poky layers.

## General insights

- [Bitbake beginner's tutorial](https://a4z.bitbucket.io/docs/BitBake/guide.html)

## Writing recipes

- [Documentation on recipes](https://www.yoctoproject.org/docs/current/dev-manual/dev-manual.html#new-recipe-writing-a-new-recipe)
- [Recipe syntax](https://www.yoctoproject.org/docs/current/dev-manual/dev-manual.html#recipe-syntax)
- [Detailed bitbake documentation of the recipe/task syntax](https://www.yoctoproject.org/docs/3.1/bitbake-user-manual/bitbake-user-manual.html#bitbake-user-manual-metadata)
- [Variables in the recipe context](https://www.yoctoproject.org/docs/3.1/ref-manual/ref-manual.html#ref-varlocality-recipe-required)

## Writing tasks

- Tasks can only be implemented as shell or Bitbake-style functions


## Existing layers (for future extensions)

- https://layers.openembedded.org/layerindex/branch/master/layer/meta-docker/
- https://layers.openembedded.org/layerindex/branch/master/layer/meta-readonly-rootfs-overlay/
- https://github.com/sbabic/meta-swupdate-boards/tree/master/
- https://layers.openembedded.org/layerindex/branch/master/layer/meta-encrypted-storage/
- https://layers.openembedded.org/layerindex/branch/master/layer/meta-selinux/