#!/bin/bash
#set -e

[[ -z $LYI_BASH ]] && {
    bash $(pwd)/install.sh
    exit $?
}

[[ -d $LYI_BASH ]] && {
    echo "LYI BASH has been installed, no need to relocat"
    exit 0
}

[[ -d $LYI_BASH ]] || {
    bash $(pwd)/install.sh
    exit $?
}