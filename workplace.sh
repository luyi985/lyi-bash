UPDATE_BASH(){
    [[ -f "${HOME}/.bashrc" ]] && source "${HOME}/.bashrc"
    [[ -f "${HOME}/.bash_profile" ]] && source "${HOME}/.bash_profile"
    ret_code=$?
	echo $ret_code
}

function loadPython() {
	[ -f ~/git/python-learn/python.sh ] || echo "No Python.sh found at ${~/git/python-learn/python.sh}"
	[ -f ~/git/python-learn/python.sh ] || exit 1;
	[ -f ~/git/python-learn/python.sh ] && source ~/git/python-learn/python.sh
}

alias eb="code -a $LYI_BASH"
alias rb=UPDATE_BASH
alias rf="npm cache clear"
alias k="killall node"
alias sub="code -a ."
alias pyOn=loadPython