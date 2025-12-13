#!/bin/bash
echo "lyi_script loaded."

# Get script_dir temporarily to source base.sh
script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

# nvidia-smi
# Source base.sh which exports script_dir and loads .env
source $script_dir/base.sh
source $script_dir/conda.sh
source $script_dir/nvm.sh
source $script_dir/alias.sh