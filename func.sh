
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