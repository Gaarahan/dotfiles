#!/bin/bash

# print utils {{

# Colors
ESC_SEQ="\x1b["
COL_RESET=$ESC_SEQ"39;49;00m"
COL_RED=$ESC_SEQ"31;01m"
COL_GREEN=$ESC_SEQ"32;01m"
COL_YELLOW=$ESC_SEQ"33;01m"
COL_BLUE=$ESC_SEQ"34;01m"
COL_MAGENTA=$ESC_SEQ"35;01m"
COL_CYAN=$ESC_SEQ"36;01m"

ok() {
  if [ $# -eq 0 ]; then
    printf "\n${COL_GREEN}[ok]${COL_RESET}"
  else
    printf "\n${COL_GREEN}[ok]${COL_RESET} %b" "$1"
  fi
}

bot() {
  printf "\n${COL_GREEN}\[._.]/${COL_RESET} - %b" "$1"
}

running() {
  printf "\n${COL_GREEN} ⇒ ${COL_RESET} %b: " "$1"
}

info() {
  printf "${COL_BLUE}[➭]${COL_RESET} %b" "$1"
}

error() {
  printf "\n${COL_RED}[error]${COL_RESET} %b" "$1"
}

action() {
  printf "\n$COL_YELLOW[action]:$COL_RESET\n ⇒ %b...\n" "$1"
}

warn() {
  printf "\n$COL_YELLOW[warning]$COL_RESET %b" "$1"
}


# }}

brewCheckOrInstall() {
    running "brew $1 $2"
    brew list $1 > /dev/null 2>&1 | true
    if [[ ${PIPESTATUS[0]} != 0 ]]; then
        action "brew install $1 $2"
        HOMEBREW_NO_AUTO_UPDATE=1 brew install $1 $2
        if [[ $? != 0 ]]; then
            error "failed to install $1! aborting..."
            # exit -1
        fi
    fi
    ok
}

check_rm() {
  if [ -e $1 ]; then
    rm -rf $1
  fi
}

