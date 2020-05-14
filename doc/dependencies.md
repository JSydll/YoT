# Dependencies

To have the possibility to easily get the latest changes from the repositories this repo depends on, 
`git subtree` is used. This enables amendments made to the whole tree without committing to the 
external repos. [More info on git subtree here](https://www.netways.de/blog/2016/01/14/working-with-git-subtree/).

To ease up the interaction with the subtrees, a small wrapper script is provided (`scripts/gitsubtree.sh`) 
which can be `source`d so that the following commands are available:

```bash
gitsubmodule_list
gitsubmodule_add <directory> <repo url> <branch>
gitsubmodule_pull <directory>
gitsubmodule_pull_all
gitsubmodule_remove <directory>
```

All dependencies listed below are stored in the `subtrees.conf` file so that they can be pulled easily.

**Dependencies / Yocto layers**:

- yocto/poky: 
  - Repo: https://git.yoctoproject.org/git/poky
  - Branch: zeus
- meta-openembedded:
  - Repo: https://git.openembedded.org/meta-openembedded
  - Branch: zeus 
  - Dependencies: core
- meta-swupdate: 
  - Repo: https://github.com/sbabic/meta-swupdate 
  - Branch: zeus
  - Dependencies: core, meta-oe
- meta-security:
  - Repo: https://git.yoctoproject.org/git/meta-security
  - Branch: zeus
  - Dependencies: meta-oe, meta-networking, meta-python, meta-perl
- meta-raspberrypi:
  - Repo: https://git.yoctoproject.org/git/meta-raspberrypi
  - Branch: zeus 
  - Dependencies: meta-oe, meta-multimedia, meta-networking, meta-python