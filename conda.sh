#!/bin/bash

# Lazy-load conda: only initialize when 'conda' is first invoked
conda() {
    unset -f conda  # remove this wrapper function

    # Determine conda base directory (prefer miniconda3, fallback to miniforge3, etc.)
    local conda_base=""
    for candidate in "$HOME/miniconda3" "$HOME/miniforge3" "$HOME/anaconda3" "/opt/homebrew/Caskroom/miniconda/base"; do
        if [ -f "$candidate/bin/conda" ]; then
            conda_base="$candidate"
            break
        fi
    done

    if [ -z "$conda_base" ]; then
        echo "conda: not found in any standard location. Install miniconda first." >&2
        return 1
    fi

    # Initialize conda for the current shell
    __conda_setup="$("$conda_base/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "$conda_base/etc/profile.d/conda.sh" ]; then
            . "$conda_base/etc/profile.d/conda.sh"
        else
            export PATH="$conda_base/bin:$PATH"
        fi
    fi
    unset __conda_setup

    # Now run the actual conda command
    conda "$@"
}
