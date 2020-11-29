doInstall() {
	echo "installing ~"
  mkdir -p ~/.config/nvim
  # https://vi.stackexchange.com/questions/12794/how-to-share-config-between-vim-and-neovim
  printf "set runtimepath^=~/.vim\nruntimepath+=~/.vim/after\nlet &packpath=&runtimepath\nsource ~/.vimrc" >> ~/.config/nvim
}
