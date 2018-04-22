nvm use 8.9.0

if [[ -n $LYI_BASH ]]; then
    echo "Sourcing Bash..."
    source "${LYI_BASH}/func.sh"
    source "${LYI_BASH}/config/config.sh"
    source "${LYI_BASH}/workplace.sh"
    source "${LYI_BASH}/bash-setting.sh"
    source "${LYI_BASH}/git.sh"
    source "${LYI_BASH}/bxm-script.sh"
    source "${LYI_BASH}/docker.sh"
    infoOutput "\$LYI_BASH : $LYI_BASH"
fi

[[ -z $WORK_PLACE ]] || cd $WORK_PLACE
[[ -z $WORK_PLACE ]] || infoOutput "\$WORK_PLACE: ${WORK_PLACE}"
[[ -z $SITE_ARR ]] || infoOutput "\$SITE_ARR: ${SITE_ARR}"
