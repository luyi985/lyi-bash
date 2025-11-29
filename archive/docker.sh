#!/bin/bash
function docker-rmi() {
	[ -z $(docker images -q) ] || docker rmi $(docker images -q)
}

function docker-stp() {
	[ -z $(docker ps -aq) ] || docker stop $(docker ps -aq)
}

function docker-rm() {
	[ -z $(docker ps -aq) ] || docker rm $(docker ps -aq)
}

function docker-clean() {
	[ -z $(docker images -f 'dangling=true' -q) ] || docker rmi -f $(docker images -f 'dangling=true' -q)
}

function docker-build() {
	[ -z $1 ] || (docker build -t=$1 .; docker-clean;)
}

alias docker-rmi=docker-rmi
alias docker-stp=docker-stp
alias docker-rm=docker-rm
alias docker-build=docker-build
alias docker-clean=docker-clean
alias docker-clear-all="docker-stp && docker-rm && docker-rmi"