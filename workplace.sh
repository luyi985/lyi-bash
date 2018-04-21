function loadPython() {
	[ -f ~/git/python-learn/python.sh ] || echo "No Python.sh found at ${~/git/python-learn/python.sh}"
	[ -f ~/git/python-learn/python.sh ] || exit 1;
	[ -f ~/git/python-learn/python.sh ] && source ~/git/python-learn/python.sh
}

editBash() {
	subl -a $LYI_BASH || code -a $LYI_BASH
	[[ -f "${HOME}/.bashrc" ]] && { subl -a ${HOME}/.bashrc || code -a ${HOME}/.bashrc; }
	[[ -f "${HOME}/.bash_profile" ]] && { subl -a ${HOME}/.bash_profile || code -a ${HOME}/.bash_profile; }
	[[ $1 == 'h' ]] && cd $LYI_BASH
}

alias eb=editBash
alias rf="npm cache clear"
alias k="killall node"
alias sub="subl -a ."
alias cod="code -a ."
alias pyOn=loadPython
