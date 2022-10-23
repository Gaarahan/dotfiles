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

NVIM_HOME="$HOME/.config/nvim"
NVIMRC="$NVIM_HOME/init.lua"
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

  if [[ -d "$NVIM_HOME" ]]; then
    mv "$NVIM_HOME" "${NVIM_HOME}_back"
    ok "BackUp $NVIM_HOME to ${NVIM_HOME}_back"
  fi
  ln -s "$(getPath "../../vim/init.lua")" "$NVIMRC"
  ln -s "$(getPath "../../vim/nvim")" "$NVIM_HOME"

  ok "Config success"
else
  info "Skip config nvim"
fi


bot "Would you like to install vim plugins/LSPs right now? (y/N)"
read -r
if [ "$REPLY" == 'y' ] || [ "$REPLY" == 'Y' ]; then
  action "Start install vim plugins"
  nvim +'PackerInstall' +qa

  action "Start install coc plugins"
  nvim +'CocI' +qa

  ok "Install vim plugins and LSPs success"
  ok "After install, pls restart your terminal"
fi
