
updateConfig() {
    source "$LYI_BASH/config/config.sh"
    return $?
}

setWorkPlace(){
    infoOutput "Please input the workplace path"
    read WORK_PLACE
    WORK_PLACE=${WORK_PLACE%/}
    [[ -d "${WORK_PLACE}" ]] || {
        errorAlert "Can not find folder at \(${WORK_PLACE}\)"
        setWorkPlace
    }
    [[ -d "${WORK_PLACE}" ]] && {
        echo "export WORK_PLACE=\"${WORK_PLACE}\"" > $LYI_BASH/config/workplace.config
        [[ $? -eq 0 ]] && {
            export WORK_PLACE && success "Set workplace path ${WORK_PLACE}"       
        }

        [[ $? -eq 0 ]] || {
            errorAlert "Fail to set workplace"
            setWorkPlace
        }
    }
}

addProjectFolders() {
    [[ -z ${WORK_PLACE} ]] && setWorkPlace
    [[ -z ${WORK_PLACE} ]] || {
        infoOutput "Here is the subfolder under ${WORK_PLACE}"
        local INDEX=0
        local folderArr=( $(ls -d ${WORK_PLACE}/*) )
        for i in ${!folderArr[*]}; do
            infoOutput "${i}: ${folderArr[$i]}"
        done
        infoOutput "Please select number before folders and split with space"
        read selectedFolderIndex
        local indexArr=(${selectedFolderIndex})
        local selectedFolder
        for id in ${indexArr[@]}; do 
            warning "${folderArr[$id]}"
            selectedFolder+=(${folderArr[$id]})
        done
        echo "export SITE_ARR=( $(echo ${selectedFolder[@]}) )" > "${LYI_BASH}/config/project.config"
        [[ $? -eq 0 ]] && {
            export SITE_ARR=( $(echo ${selectedFolder[@]}) ) && success "Set SITE_ARR ${SITE_ARR[*]}" 
        }

        [[ $? -eq 0 ]] || {
            errorAlert "Fail to set workplace"
            addProjectFolders
        }
    }
}

setOptions() {
    infoOutput "You can select following setting options"
    infoOutput "Select by typing a number before option"
    local options=( "[0] Set workplace folder" "[1] Add project folders" )
    local status
    for op in "${options[@]}"; do
        infoOutput "$op"
    done

    read currentOptions

    case "${currentOptions}" in
        0)
            success "You selected ${options[0]}"
            setWorkPlace && addProjectFolders
        ;;
        1)
            success "You selected ${options[1]}"
            addProjectFolders
            status=0
        ;;
        *)
            errorAlert "Option not support"
            setOptions
            status=$?
        ;;
    esac
    return $status
}

alias setup=setOptions

