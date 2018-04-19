#nvm use 8.9.0
set -e

export LYI_BASH="$(pwd)"
echo "\$LYI_BASH : $LYI_BASH"
source "${LYI_BASH}/func.sh"
echo "WORK_PLACE: $WORK_PLACE"
source "${LYI_BASH}/config/config.sh"
source "${LYI_BASH}/workplace.sh"
source "${LYI_BASH}/bash-setting.sh"
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