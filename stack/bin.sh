#!/bin/bash

# Docker stack management functions

_stack_dir() {
    if [ -n "$BASH_SOURCE" ]; then
        echo "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
    elif [ -n "$ZSH_VERSION" ]; then
        echo "$(cd -- "$(dirname -- "${(%):-%x}")" &> /dev/null && pwd)"
    else
        echo "$(cd -- "$(dirname -- "$0")" &> /dev/null && pwd)"
    fi
}

stackUp() {
    echo "Starting Docker stack..."
    local stack_dir="$(_stack_dir)"
    podman compose -f "$stack_dir/docker-compose.yml" up -d && echo "Stack is up!" || { echo "Error: Failed to start stack. Make sure Docker is running."; return 1; }
}

stackDown() {
    echo "Stopping Docker stack..."
    local stack_dir="$(_stack_dir)"
    podman compose -f "$stack_dir/docker-compose.yml" down && echo "Stack is down!" || { echo "Error: Failed to stop stack."; return 1; }
}

stackReload() {
    echo "Reloading Docker stack..."
    local stack_dir="$(_stack_dir)"
    podman compose -f "$stack_dir/docker-compose.yml" restart && echo "Stack is reloaded!" || { echo "Error: Failed to reload stack."; return 1; }
}
