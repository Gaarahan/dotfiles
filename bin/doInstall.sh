#!/usr/bin/env bash


# debug mode {{
getopts "d" isDebugMode;

if [ "${isDebugMode}" == 'd' ]; then
  set -x
  set -v
fi
# }}

# get absolute path from relative path {{
SHELL_POSITION=$(dirname "$(readlink -f "$0")")
getPath() {
  # need install realpath in macos
  # brew install coreutils
  realpath "$SHELL_POSITION/$1"
}
# }}

UTILS_PATH=$(getPath "./utils.sh")
# shellcheck disable=SC1090
source "$UTILS_PATH"

ZSHRC="$HOME/.zshrc"

if [ "$(isSupported)" != true ]; then
  error 'Sorry, the current script only works on linux and macos'
  exit 1
fi

bot "Link './zsh/zshrc' to '~/.zshrc, this will backup the old file? (y/N)"
read -r

if [ "$REPLY" == 'y' ] || [ "$REPLY" == 'Y' ]; then
  info "Start config zsh"
    if [ -e "$ZSHRC" ]; then
    rm "$ZSHRC.bak" >/dev/null
    mv "$ZSHRC" "$ZSHRC.bak"
  fi
  ln -s "$(getPath "../zsh/zshrc")" "$ZSHRC"

else
  info "Skip config zsh"
fi

VIMRC="$HOME/.vimrc"
VIM_HOME="$HOME/.vim"
NVIM_HOME="$HOME/.config/nvim"
NVIMRC="$NVIM_HOME/init.vim"

bot "Which configuration do you want?
1) Start from scratch
2) Only link the config file
"

read -r
if [ "$REPLY" == '1' ]; then
  error "Sorry, totally config is under development"
elif [ "$REPLY" == '2' ]; then
  info "Start config nvim"

  if [ -e "$NVIMRC" ]; then
    rm "$NVIMRC.bak" >/dev/null
    mv "$NVIMRC" "$NVIMRC.bak"
  fi

  if [ -e "$VIMRC" ]; then
    rm "$VIMRC.bak" >/dev/null
    mv "$VIMRC" "$VIMRC.bak"
  fi

  ln -s "$(getPath "../vim/vimrc")" "$VIMRC"
  if [[ ! -d "$NVIM_HOME" ]]; then
    mkdir "$NVIM_HOME"
  fi
  ln -s "$(getPath "../vim/init.vim")" "$NVIMRC"

  if [[ -d "$VIM_HOME" ]]; then
    mv "$VIM_HOME" "${VIM_HOME}_back"
    ok "BackUp $VIM_HOME to ${VIM_HOME}_back"
  fi
  ln -s "$(getPath "../vim/vim")" "$HOME/.vim"
  ok "Config vim success, you can now open it and run 'PlugInstall'"
fi

TMUX_CONF="$HOME/.tmux.conf"

bot "Link 'tmux/tmux.conf' to '~/.tmux.conf', this will backup the old file? (y/N)"
read -r

if [ "$REPLY" == 'y' ] || [ "$REPLY" == 'Y' ]; then
  info "Start config tmux"

  if [ -e "$TMUX_CONF" ]; then
    rm "$TMUX_CONF.bak" >/dev/null
    mv "$TMUX_CONF" "$TMUX_CONF.bak"
  fi
  ln -s "$(getPath "../tmux/tmux.conf")" "$TMUX_CONF"
fi
