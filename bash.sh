UPDATE_BASH(){
    [[ -f "${HOME}/.bashrc" ]] && source "${HOME}/.bashrc"
    [[ -f "${HOME}/.bash_profile" ]] && source "${HOME}/.bash_profile"
    ret_code=$?
	echo $ret_code
    return $ret_code
}
alias rb=UPDATE_BASH


#nvm use 8.9.0
if [[ -n $LYI_BASH ]]; then
    echo "Sourcing Bash..."
    source "${LYI_BASH}/func.sh"
    source "${LYI_BASH}/config/config.sh"
    source "${LYI_BASH}/workplace.sh"
    source "${LYI_BASH}/bash-setting.sh"
    source "$LYI_BASH/git.sh"
    source "$LYI_BASH/bxm-script.sh"
    infoOutput "\$LYI_BASH : $LYI_BASH"
fi

[[ -z $WORK_PLACE ]] || cd $WORK_PLACE
[[ -z $WORK_PLACE ]] || infoOutput "\$WORK_PLACE: ${WORK_PLACE}"
[[ -z $SITE_ARR ]] || infoOutput "\$SITE_ARR: ${SITE_ARR[*]}"
#export WORK_PLACE="$HOME/git/lyi"
#echo "WORK_PLACE: $WORK_PLACE"
# source "$LYI_BASH/proxy"
# 
# 
# source "$LYI_BASH/bash-setting"
# source "$LYI_BASH/git"

# source "$LYI_BASH/docker"
# source "$LYI_BASH/bxm-script"
# source "$LYI_BASH/digital-ocean"

#export WORK_PLACE="$HOME/git/lyi"
# echo "WORK_PLACE: $WORK_PLACE"