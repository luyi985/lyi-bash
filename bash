nvm use 8.9.0

export red='\033[0;31m'
export green='\033[00;32m'
export yellow='\033[00;33m'
export blue='\033[00;34m'
export back='\e[0m'


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