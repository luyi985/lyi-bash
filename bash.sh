#nvm use 8.9.0
echo "\$LYI_BASH : $LYI_BASH"
source "${LYI_BASH}/func.sh"
source "${LYI_BASH}/config/config.sh"
source "${LYI_BASH}/bash-setting.sh"
source "${LYI_BASH}/workplace.sh"
source "$LYI_BASH/git.sh"
source "$LYI_BASH/bxm-script.sh"

[[ -z $WORK_PLACE ]] || cd $WORK_PLACE
[[ -z $WORK_PLACE ]] || infoOutput "WORK_PLACE: ${WORK_PLACE}"
[[ -z $SITE_ARR ]] || infoOutput "SITE_ARR: ${SITE_ARR[*]}"
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