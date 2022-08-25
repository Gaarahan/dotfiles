# ###########################################################
# Config ZSH
# ###########################################################

ZSHRC="$HOME/.zshrc"
bot "Link './zsh/zshrc' to '~/.zshrc, this will backup the old file? (y/N)"
read -r

if [ "$REPLY" == 'y' ] || [ "$REPLY" == 'Y' ]; then
  info "Start config zsh"
  if [ -e "$ZSHRC" ]; then
    check_rm "$ZSHRC.bak"
    mv "$ZSHRC" "$ZSHRC.bak"
  fi
  ln -s "$(getPath "../../zsh/zshrc")" "$ZSHRC"
  ok "Config success"

else
  info "Skip config zsh"
fi

# ###########################################################
# Config Tmux
# ###########################################################

TMUX_CONF="$HOME/.tmux.conf"

bot "Link 'tmux/tmux.conf' to '~/.tmux.conf', this will backup the old file? (y/N)"
read -r

if [ "$REPLY" == 'y' ] || [ "$REPLY" == 'Y' ]; then
  info "Start config tmux"

  if [ -e "$TMUX_CONF" ]; then
    check_rm "$TMUX_CONF.bak"
    mv "$TMUX_CONF" "$TMUX_CONF.bak"
  fi
  ln -s "$(getPath "../../tmux/tmux.conf")" "$TMUX_CONF"
  ok "Config success"
else
  info "Skip config tmux"
fi

# ###########################################################
# Config NeoVim
# ###########################################################

VIMRC="$HOME/.vimrc"
VIM_HOME="$HOME/.vim"
NVIM_HOME="$HOME/.config/nvim"
NVIMRC="$NVIM_HOME/init.vim"
RG_CONF="$HOME/.ripgreprc"

bot "Start config nvim? (y/N)"
read -r

if [ "$REPLY" == 'y' ] || [ "$REPLY" == 'Y' ]; then
  info "Start config nvim"

  if [ -e "$RG_CONF" ]; then
    check_rm "$RG_CONF.bak"
    mv "$RG_CONFIG" "$RG_CONF.bak"
  fi
  ln -s "$(getPath "../../ripgrep/ripgreprc")" "$RG_CONF"

  if [ -e "$NVIMRC" ]; then
    check_rm "$NVIMRC.bak"
    mv "$NVIMRC" "$NVIMRC.bak"
  fi

  if [ -e "$VIMRC" ]; then
    check_rm "$VIMRC.bak"
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

  ok "Config success"
else
  info "Skip config nvim"
fi


bot "Would you like to install vim plugins/LSPs right now? (y/N)"
read -r
if [ "$REPLY" == 'y' ] || [ "$REPLY" == 'Y' ]; then
  action "Start install vim plugins"
  nvim +'PlugInstall --sync' +qa

  action "Start install coc plugins"
  nvim +'CocI' +qa

  ok "Install vim plugins and LSPs success"
  ok "After install, pls restart your terminal"
fi
