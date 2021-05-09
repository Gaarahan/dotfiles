#!/bin/bash

###
# judge function
###

isLinux() {
	if [ "$(uname)" == 'Linux' ]; then
		echo true
		return
	fi
	echo false
}


###
# format print
###

# Colors
ESC_SEQ="\x1b["
COL_RESET=$ESC_SEQ"39;49;00m"
COL_RED=$ESC_SEQ"31;01m"
COL_GREEN=$ESC_SEQ"32;01m"
COL_BLUE=$ESC_SEQ"34;01m"

COL_RESET=$ESC_SEQ"39;49;00m"
COL_RED=$ESC_SEQ"31;01m"

ok() {
    printf  "\t${COL_GREEN}[ok]${COL_RESET} %s\n" "$1"
}

bot() {
    printf  "${COL_GREEN}\[._.]/${COL_RESET} - %s\n" "$1"
}

info() {
    printf "\t${COL_BLUE}[➭]${COL_RESET} %s\n" "$1"
}

error() {
    printf "\t${COL_RED}[error]${COL_RESET} %s\n" "$1"
}


