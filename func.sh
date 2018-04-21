
strContains() {
    if [[ $1 == *$2* ]] 
    then 
        echo "find"
        return 0 
    else 
        echo "not find"
        return 1
    fi
}

colorEcho(){
    local currentColor=''
    # Reset
    local colorOff='\033[0m'       # Text Reset
    case "$1" in
    black)
        currentColor='\033[0;30m'        # Black
        ;;
    red)
        currentColor='\033[0;31m'          # Red
        ;;
    green)
        currentColor='\033[0;32m'        # Green
        ;;
    yellow)
        currentColor='\033[0;33m'       # Yellow
        ;;
    blue)
        currentColor='\033[0;34m'         # Blue
        ;;
    purple)
        currentColor='\033[0;35m'       # Purple
        ;;
    cyan)
        currentColor='\033[0;36m'         # Cyan
        ;;
    white)
        currentColor='\033[0;37m'        # White
        ;;
    *)
        currentColor='\033[0;37m'        # White
        ;;
    esac

    echo -e "${currentColor}$2${colorOff}"
}

errorAlert() {
    colorEcho red "$1"
}

success() {
    colorEcho green "$1"
}

warning() {
    colorEcho yellow "$1"
}

infoOutput() {
    colorEcho cyan "$1"
}

lyiEditor() {
    [[ -f "${1}" || -d "${1}" ]] && {
        subl -a $1 || code -a $1 || gedit $1 || nano $1
    }
}

GET_BASH_PATH() {
    unset LYI_BASH_PATH

    [[ -f "${HOME}/.bashrc" ]] && {
        export LYI_BASH_PATH="${HOME}/.bashrc"
        return 0
    }

    [[ -f "${HOME}/.bash_profile" ]] && {
        export LYI_BASH_PATH="${HOME}/.bash_profile"
        return 0
    }

    errorAlert "Fail: can not find .bashrc/.bash_profile in ${HOME}"
    return 1
}

UPDATE_BASH(){
    [[ -f "${HOME}/.bashrc" ]] && source "${HOME}/.bashrc"
    [[ -f "${HOME}/.bash_profile" ]] && source "${HOME}/.bash_profile"
    ret_code=$?
    echo $ret_code
    return $ret_code
}
alias rb=UPDATE_BASH