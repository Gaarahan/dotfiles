# ###########################################################
# install required packages
# ###########################################################
brewCheckOrInstall curl
brewCheckOrInstall wget
brewCheckOrInstall git

brewCheckOrInstall node
brewCheckOrInstall yarn
brewCheckOrInstall python3
brewCheckOrInstall ruby

brewCheckOrInstall zsh
brewCheckOrInstall tmux
brewCheckOrInstall lazygit

brewCheckOrInstall luajit
brewCheckOrInstall neovim

brewCheckOrInstall fzf
brewCheckOrInstall bat
brewCheckOrInstall ag

# TODO: change terminal font?
brewCheckOrInstall font-hack-nerd-font

defaults write com.googlecode.iterm2 "Normal Font" -string "SourceCodePro-Regular"
defaults write com.googlecode.iterm2 "Non Ascii Font" -string "SourceCodePro-Regular"

bot "Install packages for neovim:"
running "Install neovim on python3"
pip3 install --upgrade neovim
ok

running "Install neovim on nodejs"
npm install -g neovim
ok

running "gem install neovim"
gem install neovim
ok

brew update && brew upgrade && brew cleanup

bot "All done"
