#!/bin/bash
set -e
#set -x

source "./func.sh"
source "./bash-setting.sh"

SET_ROOT() {
    local status
    [[ -z $LYI_BASH ]] && {
        export LYI_BASH="$(pwd)"
        echo '' >> $1
        echo "export LYI_BASH=\"$(pwd)\"" >> $1
        echo "source \"$(pwd)/bash.sh\"" >> $1
        status=$?
        [[ status -eq 0 ]] && success "Bash updated"
        [[ status -eq 0 ]] || errorAlert "Bash update fail"
    }
    return $status
}

INIT() {
    echo $LYI_BASH
    GET_BASH_PATH
    [[ $? -eq 0 && -n $LYI_BASH_PATH ]] && {
        SET_ROOT "${LYI_BASH_PATH}"
        exitCode=$?
        [[ $exitCode -eq 0 ]] && setOptions
        [[ $exitCode -eq 0 ]] || {
            errorAlert "Write LYI_BASH fail"
            infoOutput "Please manually append following scipt to ${LYI_BASH_PATH}"
            infoOutput "export LYI_BASH=\"$(pwd)\" source \"$(pwd)/bash.sh\""
            lyiEdit "${LYI_BASH_PATH}"
        }
    }
}

[[ -z $LYI_BASH ]] && INIT

[[ -d $LYI_BASH ]] || INIT

[[ -d $LYI_BASH ]] && warning "LYI BASH has been installed"