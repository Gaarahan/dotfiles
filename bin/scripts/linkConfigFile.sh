bot "Link './zsh/zshrc' to '~/.zshrc, this will backup the old file? (y/N)"
read -r

if [ "$REPLY" == 'y' ] || [ "$REPLY" == 'Y' ]; then
  info "Start config zsh"
  if [ -e "$ZSHRC" ]; then
    rm "$ZSHRC.bak" > /dev/null 2>&1
    mv "$ZSHRC" "$ZSHRC.bak"
  fi
  ln -s "$(getPath "../../zsh/zshrc")" "$ZSHRC"
  ok "Config success"

else
  info "Skip config zsh"
fi

VIMRC="$HOME/.vimrc"
VIM_HOME="$HOME/.vim"
NVIM_HOME="$HOME/.config/nvim"
NVIMRC="$NVIM_HOME/init.vim"

info "Start config nvim"

if [ -e "$NVIMRC" ]; then
  rm "$NVIMRC.bak" >/dev/null 2>&1
  mv "$NVIMRC" "$NVIMRC.bak"
fi

if [ -e "$VIMRC" ]; then
  rm "$VIMRC.bak" >/dev/null 2>&1
  mv "$VIMRC" "$VIMRC.bak"
fi

ln -s "$(getPath "../../vim/vimrc")" "$VIMRC"
if [[ ! -d "$NVIM_HOME" ]]; then
  mkdir "$NVIM_HOME"
fi
ln -s "$(getPath "../../vim/init.vim")" "$NVIMRC"

if [[ -d "$VIM_HOME" ]]; then
  mv "$VIM_HOME" "${VIM_HOME}_back"
  ok "BackUp $VIM_HOME to ${VIM_HOME}_back"
fi
ln -s "$(getPath "../../vim/vim")" "$HOME/.vim"
ok "Config vim success, you can now open it and run 'PlugInstall'.
After install plugin, you could install your perfer language support, like:
CocInstall coc-html coc-css coc-tsserver coc-vetur coc-json coc-sh coc-clangd coc-markdownlint"

TMUX_CONF="$HOME/.tmux.conf"

bot "Link 'tmux/tmux.conf' to '~/.tmux.conf', this will backup the old file? (y/N)"
read -r

if [ "$REPLY" == 'y' ] || [ "$REPLY" == 'Y' ]; then
  info "Start config tmux"

  if [ -e "$TMUX_CONF" ]; then
    rm "$TMUX_CONF.bak" >/dev/null 2>&1
    mv "$TMUX_CONF" "$TMUX_CONF.bak"
  fi
  ln -s "$(getPath "../../tmux/tmux.conf")" "$TMUX_CONF"
  ok "Config success"
fi
