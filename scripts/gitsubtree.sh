#!/bin/bash
# ------------------------
# Convenience functions for interacting with git subtree
#
# - Listing all subtree folders
# - Pulling all subtree repos
# - Adding a subtree
# - Removing a subtree folder
#
# Note: This depends on a configuration file (subtrees.conf) in 
# which all currently integrated subtrees are listed. 
# ------------------------
SUBTREE_CONF=subtrees.conf

# ------------------------
# Escapes forward and backward slashes in a string path
# ------------------------
escape_path() {
    echo $1 | sed 's;/;\\/;g'
}

# ------------------------
# List all currently included subtree directories
# ------------------------
gitsubtree_list() {
    git log | grep git-subtree-dir | tr -d ' ' | cut -d ":" -f2 | sort | uniq | xargs -I {} bash -c 'if [ -d $(git rev-parse --show-toplevel)/{} ] ; then echo {}; fi'
}

# ------------------------
# Add a new subtree in the $1 folder referencing the $2 repo on $3 branch
# 
# Also registers the submodule and it's configuration in the subtrees.conf 
# file used to pull all or specific subtrees.
# ------------------------
gitsubtree_add() {
    if [[ -z "$1" && -z "$2" && -z "$3" ]]; then 
        echo "Missing parameters: "
        echo "\t\$1 is subtree location, \$2 is repository url, \$3 is branch reference."
        return
    fi
    source $SUBTREE_CONF
    [[ -n "${subtrees[$1]}" ]] && echo "Error: Subtree $1 already in use. Did you meant to run gitsubtree_pull?" && return
    
    git subtree add --prefix $1 $2 $3
    echo "subtrees[$1]=\"$2 $3\"" >> $SUBTREE_CONF

    echo "Added subtree $1 referencing $2 on branch $3."
}

# ------------------------
# Remeove a registered subtree 
# 
# Also removes the entry from the subtrees.conf file.
# ------------------------
gitsubtree_remove() {
    [[ -z "$1" ]] && echo "Missing parameters: \n\t\$1 is the subtree location." && return
    
    read -p "Are you sure to remove subtree $1 (including the directory)? This cannot be reversed. [y/n] " -n 1 -r
    [[ ! $REPLY =~ ^[Yy]$ ]] && return
    echo 

    rm -rfd $1
    sed -i "/$(escape_path $1)/d" $SUBTREE_CONF
    echo "Removed subtree from source tree and $SUBTREE_CONF."
}

# ------------------------
# Pull a registered subtree
# 
# Assumes that the subtree was registered in the subtrees.conf file.
# ------------------------
gitsubtree_pull() {
    [[ -z "$1" ]] && echo "No subtree specified." && return

    source $SUBTREE_CONF
    [[ -z "${subtrees[$1]}" ]] && echo "The subtree $1 was not registered in $SUBTREE_CONF. Cannot auto-pull." && return

    echo "Updating $1 [${subtrees[$1]}]..."
    git subtree pull --prefix $(echo $1 ${subtrees[$1]})
}

# ------------------------
# Pull all registered subtrees
# ------------------------
gitsubtree_pull_all() {
    treelist=($(gitsubtree_list))
    for sub in "${treelist[@]}"; do
        gitsubtree_update $sub
    done
}