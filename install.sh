#!/bin/bash
set -e
SET_ROOT() {
    [[ -f "${HOME}/.bashrc" && -z $LYI_BASH ]] && {
        echo '' >> ${HOME}/.bashrc
        echo "source \"$(pwd)/bash.sh\"" >> ${HOME}/.bashrc
        [[ $? -eq 0 ]] && { echo "Changed bashrc"; exit 0; }
        [[ $? -eq 0 ]] || exit 1
    }

    [[ -f "${HOME}/.bash_profile" && -z $LYI_BASH ]] && {
        echo '' >> ${HOME}/.bash_profile
        echo "source \"$(pwd)/bash.sh\"" >> ${HOME}/.bash_profile
        [[ $? -eq 0 ]] && { echo "Changed bash_profile"; exit 0;}
        [[ $? -eq 0 ]] || exit 1
    }
    exit 1
}
SET_ROOT