#!/bin/bash

# Setup PATH if directory exists and not already in PATH
setup_path_if_needed() {
	local dir="$1"
	if [ -d "$dir" ] && [[ ":$PATH:" != *":$dir:"* ]]; then
		export PATH="$dir:$PATH"
	fi
}

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
	setup_path_if_needed "$PYENV_ROOT/bin"

	# Lazy-load pyenv: only run 'pyenv init' when python/pip/python3 are first used
	pyenv() {
		unset -f pyenv
		if command -v pyenv >/dev/null 2>&1; then
			eval "$(pyenv init - zsh)"
		fi
		pyenv "$@"
	}
}

install_pyenv_if_needed
setup_pyenv_env

# Ensure ~/.local/bin is in PATH (uv and other tools install there)
setup_path_if_needed "$HOME/.local/bin"

function install_uv_if_needed() {
	if command -v uv >/dev/null 2>&1; then
		return 0
	fi

	echo "uv not found. Installing uv..."
	curl -LsSf https://astral.sh/uv/install.sh | sh

	# Source uv into current shell session
	setup_path_if_needed "$HOME/.local/bin"
}

install_uv_if_needed
