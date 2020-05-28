#!/bin/bash
# ------------------------
# Provides functions to mount/unmount images
# ------------------------

# ------------------------
# Tries to locate an image file named like $2 for target $1
# ------------------------
image_locate() {
    root="$PWD";
    target="$1"
    img_name="$2"
    [[ ! -d "build" ]] && echo "Error: Please execute this function from root directory of this repo!" && return
    img_dir="build/tmp/deploy/images/$target"
    [[ ! -d "$img_dir" ]] && echo "Image directory '$img_dir' not found." && return
    img_path="$img_dir/$img_name-$target.ext4"
    [[ ! -f "$img_path" ]]  && echo "Image '$img_name-$target.ext' not found." && return
    echo "$img_path"
}

# ------------------------
# Mounts an image $2 for target &1 to mountpoint $3
# ------------------------
image_mount() {
    img_path="$(image_locate $1 $2)"
    mnt="$3"
    [[ -z "$img_path" ]] && echo "Error: Could not locate the image!" && return;
    sudo mount $img_path $mnt
    cd $mnt
}