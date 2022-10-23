local packer = require('packer')
local use = packer.use

packer.startup(function()
  use 'wbthomason/packer.nvim' -- Package manager

  use 'neovim/nvim-lspconfig' -- Configurations for Nvim LSP

  -- Appearance customize
  use 'mhinz/vim-startify'                       -- customize the startup page
  use 'glepnir/oceanic-material'                  -- theme
  use 'morhetz/gruvbox'
  use 'nvim-lualine/lualine.nvim'               -- buffer line and status line
  use 'romgrk/barbar.nvim'
  use 'kyazdani42/nvim-web-devicons'

  --  plug for dir_tree
  use 'kristijanhusak/defx-icons'
  use {'Shougo/defx.nvim',  cmd = ':UpdateRemotePlugins' }

  -- Plug for base input
  use 'jiangmiao/auto-pairs'                     -- auto pair bracket when input
  use {'neoclide/coc.nvim', branch = 'release'} -- auto complete
  use  {'andymass/vim-matchup', event = 'VimEnter'}                    -- make '%' support more feature
  use 'kamykn/popup-menu.nvim'
  use 'kamykn/spelunker.vim'
  use 'tpope/vim-surround'
  use {
    'heavenshell/vim-jsdoc', ft = {'javascript', 'javascript.jsx','typescript'}, cmd = 'make install' 
  } 


  use 'voldikss/vim-translator'                  -- select block and enter Translate*
  use 'junegunn/vim-easy-align'                  -- select block and enter 'ga[align-char]' to align by special char
  use 'easymotion/vim-easymotion'                -- use <leader><leader> to active plugin, use w/f to use more powerful function
  use 'kevinoid/vim-jsonc'                       -- support JSON with Comments
  use 'terrortylor/nvim-comment'                 -- use :CommentToggle to toggle comment

  use 'sbdchd/neoformat'
  use 'yuttie/comfortable-motion.vim'            -- move smooth when use like <C-f>

  -- Plug for html
  use 'mattn/emmet-vim'                          
  use 'alvan/vim-closetag'
  use 'mxw/vim-jsx'

  -- plug for vue
  use 'posva/vim-vue'
  use 'ThePrimeagen/vim-be-good'

  -- plug for markdown
  use 'godlygeek/tabular'
  use  {
    'plasticboy/vim-markdown', setup = function () 
      vim.g.vim_markdown_fenced_languages = {'css', 'java', 'javascript', 'js=javascript', 'sass', 'xml', 'typescrtpt', 'ts=typescrtpt'}
    end
  }
  use {'iamcco/markdown-preview.nvim',  cmd = 'cd app && yarn install', ft =  {'markdown', 'vim-plug'}}

  -- Plug for git
  use 'kdheepak/lazygit.nvim'

  use 'nvim-lua/plenary.nvim' -- required by gitsigns
  use 'lewis6991/gitsigns.nvim'

  use {'junegunn/fzf',  cmd = 'fzf#install' }
  use 'junegunn/fzf.vim'


end)
