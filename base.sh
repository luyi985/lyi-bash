#!/bin/bash
# Define script_dir if not already set (central definition)
if [ -z "$script_dir" ]; then
    export script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
fi

set -a
source $script_dir/.env
set +a


function rb() {
    current_cmd_dir=$(pwd)
    source ~/.bashrc 2>&1
    cd $current_cmd_dir
}


function eb() {
    current_cmd_dir=$(pwd)
    code $script_dir
}

function h () {
    cd $main_workdir
}

