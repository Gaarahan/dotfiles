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
