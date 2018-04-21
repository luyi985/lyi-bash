#!/bin/bash
set -e
#set -x
SET_ROOT() {
    local status
    [[ -f "${HOME}/.bashrc" && -z $LYI_BASH ]] && {
        echo '' >> ${HOME}/.bashrc
        echo "export LYI_BASH=\"$(pwd)\"" >> ${HOME}/.bashrc
        echo "source \"$(pwd)/bash.sh\"" >> ${HOME}/.bashrc
        status=$?
    }

    [[ -f "${HOME}/.bash_profile" && -z $LYI_BASH ]] && {
        echo '' >> ${HOME}/.bash_profile
        echo "export LYI_BASH=\"$(pwd)\"" >> ${HOME}/.bash_profile
        echo "source \"$(pwd)/bash.sh\"" >> ${HOME}/.bash_profile
        status=$?
    }

    [[ status -eq 0 ]] && echo "Bash updated"
    [[ status -eq 0 ]] || echo "Bash update fail"
    exit $status
}


[[ -z $LYI_BASH ]] && {
    SET_ROOT ]
    export exitCode=$?
}

[[ -d $LYI_BASH ]] && {
    echo "LYI BASH has been installed, no need to relocat";
    export exitCode=0;
}

[[ -d $LYI_BASH ]] || {
    SET_ROOT;
    export exitCode=$?;
}

exit $exitCode