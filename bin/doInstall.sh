#!/bin/bash

source "./utils.sh"

ZSHRC='~/.zshrc'
VIMRC="~/.vimrc"
TMUX_CONF='~/.tmux.conf'

echo $(pwd)

if [ $(isLinux) != true ]; then
	error 'Sorry, the current script only works on linux'
	exit 1
fi

bot "Append './zsh/zshrc' to '~/.zshrc? (y/N)"
read

echo $REPLY
if [ $REPLY=='y' -o $REPLY=='Y' ]; then
	cat ../zsh/zshrc >> $ZSHRC
fi

running "Start config nvim"

bot "Link 'vim/vimrc' to '~/.vimrc', this will backup the old file? (y/N)"
read
if [ $REPLY=='y' -o $REPLY=='Y' ]; then
	if [ -e $VIMRC ]; then 
		mv $VIMRC "$VIMRC.bak"
	fi
  ln ../vim/vimrc $VIMRC
fi

running "Start config tmux"

bot "Link 'tmux/tmux.conf' to '~/.tmux.conf', this will backup the old file? (y/N)"
read

if [ $REPLY=='y' -o $REPLY=='Y' ]; then

	if [ -e $TMUX_CONF ]; then 
		mv $TMUX_CONF "$TMUX_CONF.bak"
	fi
	ln ../tmux/tmux.conf $TMUX_CONF 
fi


