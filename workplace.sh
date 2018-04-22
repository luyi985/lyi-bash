loadPython() {
	[ -f ~/git/python-learn/python.sh ] || echo "No Python.sh found at ${~/git/python-learn/python.sh}"
	[ -f ~/git/python-learn/python.sh ] || exit 1;
	[ -f ~/git/python-learn/python.sh ] && source ~/git/python-learn/python.sh
}

editBash() {
	[[ -f "${HOME}/.bashrc" ]] && lyiEdit "${HOME}/.bashrc"
	[[ -f "${HOME}/.bash_profile" ]] && lyiEdit "${HOME}/.bash_profile"
	[[ $1 == 'h' ]] && cd $LYI_BASH
}


alias eb=editBash
alias rf="npm cache clear"
alias k="killall node"
alias sub="subl -a ."
alias cod="code -a ."
alias pyOn=loadPython
