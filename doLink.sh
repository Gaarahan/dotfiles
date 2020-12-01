#!/bin/bash

echo -n "Link 'vim/vimrc' to '~/.vimrc', this will remove the old file? (y/N)"
read
if [ $REPLY=='y' -o $REPLY=='Y' ]; then
  rm ~/.vimrc
  ln ./vim/vimrc ~/.vimrc
fi

echo -n "Link 'tmux/tmux.conf' to '~/.tmux.conf', this will remove the old file? (y/N)"
read
if [ $REPLY=='y' -o $REPLY=='Y' ]; then
  rm ~/.tmux.conf
  ln ./tmux/tmux.conf ~/.tmux.conf
fi

