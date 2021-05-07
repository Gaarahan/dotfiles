#!/bin/bash

###
# judge function
###

isLinux() {
	if [ $(uname) == 'Linux' ]; then
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
COL_YELLOW=$ESC_SEQ"33;01m"
COL_BLUE=$ESC_SEQ"34;01m"
COL_MAGENTA=$ESC_SEQ"35;01m"
COL_CYAN=$ESC_SEQ"36;01m"

COL_RESET=$ESC_SEQ"39;49;00m"
COL_RED=$ESC_SEQ"31;01m"

ok() {
    printf  "$COL_GREEN[ok]$COL_RESET $1"
}

bot() {
    printf  "\n$COL_GREEN\[._.]/$COL_RESET - $1"
}

running() {
    printf  "$COL_YELLOW ⇒ $COL_RESET $1 "
}

action() {
    printf  "\n$COL_YELLOW[action]:$COL_RESET\n ⇒ $1..."
}

warn() {
    printf  "$COL_YELLOW[warning]$COL_RESET "$1
}

error() {
    printf  "$COL_RED[error]$COL_RESET "$1
}


