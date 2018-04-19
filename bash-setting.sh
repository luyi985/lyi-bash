infoOutput "bash setting"
configToUpdate=""

set -e

updateConfig() {
    source "$LYI_BASH/config/config.sh"
}

writeConfig(){
    [[ configToUpdate == "workpace" ]] && {
        echo ""
    }
}

addProjectFolders() {
    infoOutput "Here is the subfolder under ${WORK_PLACE}"
    cd ${WORK_PLACE}
    local INDEX=0
    local folderArr
    for i in $(ls -d */); do 
        echo ${INDEX}_$i
        let INDEX=${INDEX}+1 
        folderArr+=(${i})
    done
    infoOutput "Please select number before folders and split with space"
    read selectedFolderIndex
    local indexArr=(${selectedFolderIndex})
    local selectedFolder
    for id in ${indexArr[*]}; do 
        [[ -d "${WORK_PLACE}/${folderArr[$id]}" ]] && {
            selectedFolder+=("${WORK_PLACE}/${folderArr[$id]}")
        }
    done
    echo "export SITE_ARR=($(printf "\"%s\" " ${selectedFolder[*]}))" > $LYI_BASH/config/project.config
    success "${selectedFolder[*]}"
}

removeWorkplace() {
    echo ""
}


setWorkPlace(){
    infoOutput "Please input the workplace path"
    read WORK_PLACE
    echo $WORK_PLACE
    [[ -d "${WORK_PLACE}" ]] || {
        errorAlert "Can not find folder at \(${WORK_PLACE}\)"
        setWorkPlace
    }
    [[ -d "${WORK_PLACE}" ]] && {
        echo "export WORK_PLACE=\"${WORK_PLACE}\"" > $LYI_BASH/config/workplace.config
        [[ $? -eq 0 ]] && {
            config=$(updateConfig)
            [[ $config -eq 0 ]] && success "WORK_PLACE=\"${WORK_PLACE}\""
            [[ $config -eq 0 ]] || setWorkPlace
        }
    }
}

setOptions() {
    infoOutput "You can select following setting options"
    infoOutput "Select by typing a number before option"
    local options=("[0] Set workplace folder" "[1] Add project folders" "[2] exit")
    
    for op in "${options[@]}"
    do
        infoOutput "$op"
    done

    read currentOptions

    case "${currentOptions}" in
        0)
            success "You selected ${options[0]}" && setWorkPlace
        ;;
        1)
            success "You selected ${options[1]}" && addProjectFolders
        ;;
        2)
            success "You selected ${options[2]}"
            return 1
        ;;
        *)
            warning "Option not supportted, please select again"
            setOptions
        ;;
    esac
}

alias so=setOptions