# ###########################################################
# install required packages
# ###########################################################
brewCheckOrInstall curl
brewCheckOrInstall wget
brewCheckOrInstall git

brewCheckOrInstall nvm
profilePath="/Users/$(whoami)/.bashrc"
if [ -f "$profilePath" ] && grep -q "NVM_DIR" "$profilePath"; then
  warn "skip nvm path config"
else
  action "add nvm to path"
  echo 'export NVM_DIR="$HOME/.nvm"' >> "$profilePath"
  echo '[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm' >> "$profilePath"
  echo '[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion' >> "$profilePath"
  ok
fi
source "$profilePath"

brewCheckOrInstall yarn
brewCheckOrInstall python3
brewCheckOrInstall rust

brewCheckOrInstall raycast --cask # use raycast for search app and commands
brewCheckOrInstall maccy  # use maccy for clipboard manage
brewCheckOrInstall rectangle --cask  # use rectangle for window manage
brewCheckOrInstall shottr --cask  # use shottr for screenshot

# zsh and plugins
brewCheckOrInstall zsh
brewCheckOrInstall zsh-autosuggestions
brewCheckOrInstall zsh-syntax-highlighting

brewCheckOrInstall tmux
brewCheckOrInstall lazygit
brewCheckOrInstall git-delta

brewCheckOrInstall luajit
brewCheckOrInstall neovim

brewCheckOrInstall fzf
brewCheckOrInstall bat
brewCheckOrInstall ripgrep
brewCheckOrInstall knqyf263/pet/pet
brewCheckOrInstall gnu-sed

#  change terminal font
brewCheckOrInstall --cask font-hack-nerd-font

# defaults write com.googlecode.iterm2 "Normal Font" -string "Monaco"
# defaults write com.googlecode.iterm2 "Non Ascii Font" -string "Hack Nerd Font Mono"

bot "Install packages for neovim:"
running "Install neovim on python3"
brewCheckOrInstall neovim
ok

running "Install neovim on nodejs"
nvm install node
npm install -g neovim
ok

brew update && brew upgrade && brew cleanup

bot "All done"
