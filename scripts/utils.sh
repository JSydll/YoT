#!/bin/bash
# ------------------------
# Utilities and helpers for bash scripting
# 
# - Colored output with echo
# ------------------------
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export ORANGE='\033[0;33m'
export NC='\033[0m'

echo_red() { echo -e "${RED}$1${NC}"; }
echo_green() { echo -e "${GREEN}$1${NC}"; }
echo_orange() { echo -e "${ORANGE}$1${NC}"; }

# ------------------------
# Parses a yaml file 
#
# @param 1 path
# ------------------------
parse_yaml() {
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   sed -ne "s|^\($s\):|\1|" \
        -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
   awk -F$fs '{
      levels = length($1)/2;
      vname[levels] = $2;
      if (length($3) > 0) {
         vn=""; for (i=0; i<levels; i++) {vn=(vn)(vname[i])("_")}
         vn=(vn)(vname[levels])
         printf("%s=%s\n", toupper(vn), $3);
      }
   }'
}