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
# Config LazyGit
# ###########################################################

LAZY_GIT_CONF="$XDG_CONFIG_HOME/lazygit/config.yml"

bot "Link 'lazygit/config.yml' to $LAZY_GIT_CONF, this will backup the old file? (y/N)"
read -r

if [ "$REPLY" == 'y' ] || [ "$REPLY" == 'Y' ]; then
  info "Start config LazyGit"

  if [ -e "$LAZY_GIT_CONF" ]; then
    check_rm "$LAZY_GIT_CONF.bak"
    mv "$LAZY_GIT_CONF" "$LAZY_GIT_CONF.bak"
  fi
  ln -s "$(getPath "../../lazygit/config.yml")" "$LAZY_GIT_CONF"
  ok "Config success"
else
  info "Skip config LazyGit"
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
    mv "$RG_CONF" "$RG_CONF.bak"
  fi
  ln -s "$(getPath "../../ripgrep/ripgreprc")" "$RG_CONF"

  if [ -e "$NVIMRC" ]; then
    check_rm "$NVIMRC.bak"
    mv "$NVIMRC" "$NVIMRC.bak"
  fi

  if [[ -d "$NVIM_HOME" ]]; then
    check_rm "${NVIM_HOME}_back"
    mv "$NVIM_HOME" "${NVIM_HOME}_back"
    bot "BackUp $NVIM_HOME to ${NVIM_HOME}_back"
  fi

  running "link config file"
  ln -s "$(getPath "../../nvim")" "$HOME/.config"
  running "install packer.nvim"
  git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

  ok "Config success"
else
  info "Skip config nvim"
fi
