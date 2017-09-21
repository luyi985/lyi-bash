nvm use 8.4.0
export WORK_PLACE="$HOME/git/lyi"
echo "WORK_PLACE: $WORK_PLACE"

export LYI_BASH="$WORK_PLACE/lyi-bash"
echo "LYI_BASH: $LYI_BASH"

source "$LYI_BASH/proxy"
source "$LYI_BASH/func"
source "$LYI_BASH/workplace"
source "$LYI_BASH/docker"
source "$LYI_BASH/bxm-script"
source "$LYI_BASH/digital-ocean"