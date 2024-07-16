# ###########################################################
# install required packages
# ###########################################################
brewCheckOrInstall curl
brewCheckOrInstall wget
brewCheckOrInstall git

brewCheckOrInstall nvm
brewCheckOrInstall yarn
brewCheckOrInstall python3
brewCheckOrInstall ruby
brewCheckOrInstall rust
brewCheckOrInstall raycast --cask

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
brewCheckOrInstall fg
brewCheckOrInstall ripgrep
brewCheckOrInstall pet
brewCheckOrInstall gnu-sed

#  change terminal font
brewCheckOrInstall homebrew/cask-fonts/font-hack-nerd-font

defaults write com.googlecode.iterm2 "Normal Font" -string "Monaco"
defaults write com.googlecode.iterm2 "Non Ascii Font" -string "Hack Nerd Font Mono"

bot "Install packages for neovim:"
running "Install neovim on python3"
pip3 install --upgrade neovim
ok

running "Install neovim on nodejs"
nvm install node
npm install -g neovim
ok

running "gem install neovim"
gem install neovim
ok

brew update && brew upgrade && brew cleanup

bot "All done"
