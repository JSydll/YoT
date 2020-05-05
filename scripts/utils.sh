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