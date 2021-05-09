#!/usr/bin/env bash

SHELL_POSITION=$(dirname "$(readlink -f "$0")")
getPath() {
  realpath "$SHELL_POSITION/$1"
}

UTILS_PATH=$(getPath "./utils.sh")
# shellcheck disable=SC1090
source "$UTILS_PATH"

ZSHRC="$HOME/.zshrc"

if [ "$(isLinux)" != true ]; then
  error 'Sorry, the current script only works on linux'
  exit 1
fi

bot "Append './zsh/zshrc' to '~/.zshrc? (y/N)"
read -r

if [ "$REPLY" == 'y' ] || [ "$REPLY" == 'Y' ]; then
  info "Start config zsh"
  cat ../zsh/zshrc >>"$ZSHRC"
else
  info "Skip config zsh"
fi

VIMRC="$HOME/.vimrc"
VIM_HOME="$HOME/.vim"
NVIMRC="$HOME/.config/nvim/init.vim"

bot "Which configuration do you want? "

echo "1) Start from scratch"
echo "2) Only link the config file"

read -r
if [ "$REPLY" == '1' ]; then

  #  nvim, py2, py3
  # neovim module : pip2/pip3 install neovim
  # node
  # vim-plug

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

  ln "$(getPath "../vim/vimrc")" "$VIMRC"
  ln "$(getPath "../vim/init.vim")" "$NVIMRC"

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
    mv "$TMUX_CONF" "$TMUX_CONF.bak"
  fi
  ln ../tmux/tmux.conf "$TMUX_CONF"
fi
