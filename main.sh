#!/bin/bash
echo "lyi_script loaded."

# Get script_dir temporarily to source base.sh (compatible with both bash and zsh)
if [ -n "$BASH_SOURCE" ]; then
    script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
elif [ -n "$ZSH_VERSION" ]; then
    script_dir=$(cd -- "$(dirname -- "${(%):-%x}")" &> /dev/null && pwd)
else
    script_dir=$(cd -- "$(dirname -- "$0")" &> /dev/null && pwd)
fi

# nvidia-smi
# Source base.sh which exports script_dir and loads .env
source $script_dir/base.sh
source $script_dir/conda.sh
source $script_dir/nvm.sh
source $script_dir/alias.sh