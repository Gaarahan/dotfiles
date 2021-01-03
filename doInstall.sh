#!/bin/bash

VIMRC='~/.vimrc'
TMUX_CONF='~/.tmux.conf'

echo -n "Link 'vim/vimrc' to '~/.vimrc', this will remove the old file? (y/N)"
read
if [ $REPLY=='y' -o $REPLY=='Y' ]; then
	if [ -e $VIMRC ]; then 
		rm $VIMRC
	fi
  ln ./vim/vimrc $VIMRC
fi

echo -n "Link 'tmux/tmux.conf' to '~/.tmux.conf', this will remove the old file? (y/N)"
read

if [ $REPLY=='y' -o $REPLY=='Y' ]; then

	if [ -e $TMUX_CONF ] then 
		rm $TMUX_CONF
	fi
	ln ./tmux/tmux.conf $TMUX_CONF 
fi


echo -n "Append './zsh/zshrc' to '~/.zshrc"
read

if [ $REPLY=='y' -o $REPLY=='Y' ]; then
cat ./zsh/zshrc >> ~/.zshrc
fi
