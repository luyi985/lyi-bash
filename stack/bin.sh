#!/bin/bash

# Docker stack management functions

stackUp() {
    echo "Starting Docker stack..."
    cd "$(dirname "${BASH_SOURCE[0]}")" || return
    docker compose up -d
    if [ $? -eq 0 ]; then
        echo "Stack is up!"
    else
        echo "Error: Failed to start stack. Make sure Docker is running."
        return 1
    fi
}

stackDown() {
    echo "Stopping Docker stack..."
    cd "$(dirname "${BASH_SOURCE[0]}")" || return
    docker compose down
    if [ $? -eq 0 ]; then
        echo "Stack is down!"
    else
        echo "Error: Failed to stop stack."
        return 1
    fi
}
