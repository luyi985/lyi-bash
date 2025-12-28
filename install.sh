#!/bin/bash
export script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
export current_cmd_dir=$(pwd)

echo "Starting installation script..."

if [ -f ~/.bashrc ]; then
    echo "~/.bashrc found."
    echo "source \"$script_dir/main.sh\"" >> ~/.bashrc
elif [ -f ~/.zshrc ]; then
    echo "~/.zshrc found."
    echo "source \"$script_dir/main.sh\"" >> ~/.zshrc
else
    echo "~/.bashrc not found. Creating one."
    touch ~/.bashrc
    echo "source \"$script_dir/main.sh\"" >> ~/.bashrc
fi

# bash $script_dir/install_nvm.sh
# bash $script_dir/install_ollama.sh