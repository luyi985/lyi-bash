#!/bin/bash

function install_pyenv_if_needed() {
	if [ -d "$HOME/.pyenv" ] || command -v pyenv >/dev/null 2>&1; then
		return 0
	fi

	echo "pyenv not found. Installing pyenv..."
	if command -v curl >/dev/null 2>&1; then
		curl -fsSL https://pyenv.run | bash
	else
		echo "curl is required to install pyenv automatically."
		return 1
	fi
}

function setup_pyenv_env() {
	if [ ! -d "$HOME/.pyenv" ]; then
		return 0
	fi

	export PYENV_ROOT="$HOME/.pyenv"
	if [[ -d $PYENV_ROOT/bin ]] && [[ ":$PATH:" != *":$PYENV_ROOT/bin:"* ]]; then
		export PATH="$PYENV_ROOT/bin:$PATH"
	fi

	if command -v pyenv >/dev/null 2>&1; then
		eval "$(pyenv init - zsh)"
	fi
}

install_pyenv_if_needed
setup_pyenv_env
