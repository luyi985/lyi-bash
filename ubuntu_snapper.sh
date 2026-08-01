#!/bin/bash

showAll() {
    sudo snapper list
}

backup(){
    sudo snapper create -d "$1"
}

restore(){
    snapper rollback $1
}

if [ "$system" = "ubuntu" ]; then
    echo "We can use snapper to backup/restore snapshot"
fi