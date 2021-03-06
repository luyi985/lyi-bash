hasBranch() {
    local branch=$(git branch | grep "^  ${1}$")
    [ -z $branch ] && {
        branch=$(git branch | grep "^* ${1}$")
    }

    branch=${branch#"*"}
    branch=${branch#" "}
    branch=${branch#" "}

    if [[ $1 == ${branch} ]]
    then
        infoOutput "* Found Branch ${1} in the repo"
        return 0
    else
        infoOutput "* Fail to find Branch ${1} in the repo"
        return 1
    fi
}

isOnBranch() {
    local branch=$(git branch | grep -i "*")
    branch=${branch#"*"}
    branch=${branch#" "}

    if [[ $1 == $branch ]] 
    then
        infoOutput "* It is on Branch ${1}"
        return 0
    else
        infoOutput "* It is not on Branch ${1}"
        return 1
    fi
}

isClean(){
    if [[ $(git status | grep -i "modified:" | wc -l) -eq 0 && $(git status | grep -i "Untracked files:" | wc -l) -eq 0 ]]
    then
        infoOutput "* Branch is clean"
        return 0
    else
        warning "* Warning: branch is not clean, save changes with commit \"temp save changes\"";
        return 1
    fi
}

isGit(){
    echo "---------Check git folder-------------"
    git status > /dev/null
    [[ $? -eq 0 ]] || { errorAlert "Fail: $(pwd) is not a valid git repo"; return 1; }

    hasBranch master
    [[ $? -eq 0 ]] || { errorAlert "Fail: $(pwd) has no master branch found"; return 1; }

    infoOutput "* $(pwd) is a valid git repo"
    return 0
}

makeCodeClean(){
    echo "---------Make sure your branch is clean-------------"
    isOnBranch master
    [[ $? -eq 0 ]] && {
        infoOutput "* It is on master branch"
        isClean || {
            git reset --hard;
            git clean -f;
            infoOutput "* Just cleaned master branch"
        }
    }

    [[ $? -eq 0 ]] || {
        infoOutput "* It is not on master branch"
        isClean || {
            git add --all;
            git commit -m "temp save changes";
        }
        git checkout master
        infoOutput "* Switch to master"
    }
}

getLatestCode(){
    echo "---------Get latest code-------------"
    git pull --quiet
    infoOutput "* Git pull, get latest update"

    hasBranch "${1}"
    [[ $? -eq 0 ]] && {
        git checkout "${1}"
        infoOutput "* Switch to branch ${1}"
    }

    [[ $? -eq 0 ]] || {
        git checkout -b "${1}"
        infoOutput "* Create new branch ${1}"
        infoOutput "* Switch to branch ${1}"
    }
    
    git rebase master
    [[ $? -eq 0 ]] && {
        colorEcho lyellow "$(git log -1)"
        success "SUCCESS: ${1} got the latest code"
    }

    [[ $? -eq 0 ]] || {
        errorAlert "* Fail: ${1} rebase fail, manual process required"
        git rebase --abort
        errorAlert "* Git rebase --abort"
    }
}

gitInput() {
    infoOutput "Please enter your new branch name:"
    unset newBranchName
    read newBranchName
    export newBranchName
}

singleGitProcess(){
    isGit && makeCodeClean && getLatestCode $1
}

alias sp=singleGitProcess