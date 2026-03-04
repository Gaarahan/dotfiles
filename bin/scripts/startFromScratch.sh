# ###########################################################
# install required packages
# ###########################################################

# NOTE: This repo's install flow is intended for macOS only.

brewCheckOrInstall curl
brewCheckOrInstall wget
brewCheckOrInstall git

brewCheckOrInstall nvm

# Load nvm for this script session (do NOT write into user's shell rc here).
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
if [ -s "$NVM_DIR/nvm.sh" ]; then
  \. "$NVM_DIR/nvm.sh"
elif command -v brew >/dev/null 2>&1; then
  _nvm_sh="$(brew --prefix nvm 2>/dev/null)/nvm.sh"
  [ -s "$_nvm_sh" ] && \. "$_nvm_sh"
  unset _nvm_sh
fi

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

# use dust to check dir size
brewCheckOrInstall dust

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
