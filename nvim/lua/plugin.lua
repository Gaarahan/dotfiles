local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()
local packer = require('packer')
local use = packer.use

packer.startup(function()
    use 'wbthomason/packer.nvim' -- Package manager

    -- LSP
    use 'neovim/nvim-lspconfig' -- Configurations for Nvim LSP
    use { 'williamboman/mason.nvim', config = function() require('mason').setup() end }-- install LSP servers, DAP servers, linters, and formatters
    use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
    use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
    use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
    use 'L3MON4D3/LuaSnip' -- Snippets plugin

    -- Appearance customize
    use 'mhinz/vim-startify'                       -- customize the startup page
    use 'glepnir/oceanic-material'                  -- theme
    use 'morhetz/gruvbox'
    use 'nvim-lualine/lualine.nvim'               -- buffer line and status line
    use 'romgrk/barbar.nvim'

    --  plug for dir_tree
    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons',
        },
    }

    -- Plug for base input
    use 'jiangmiao/auto-pairs'                     -- auto pair bracket when input
    use { 'andymass/vim-matchup', event = 'VimEnter' }                    -- make '%' support more feature
    use 'kamykn/popup-menu.nvim'
    use 'kamykn/spelunker.vim'
    use 'tpope/vim-surround'
    use {
        'heavenshell/vim-jsdoc', ft = { 'javascript', 'javascript.jsx', 'typescript' }, cmd = 'make install'
    }

    use 'voldikss/vim-translator'                  -- select block and enter Translate*
    use 'junegunn/vim-easy-align'                  -- select block and enter 'ga[align-char]' to align by special char
    use 'easymotion/vim-easymotion'                -- use <leader><leader> to active plugin, use w/f to use more powerful function
    use 'kevinoid/vim-jsonc'                       -- support JSON with Comments
    use 'terrortylor/nvim-comment'                 -- use :CommentToggle to toggle comment

    use 'sbdchd/neoformat'
    use 'yuttie/comfortable-motion.vim'            -- move smooth when use like <C-f>

    -- Plug for html
    use 'alvan/vim-closetag'
    use 'mxw/vim-jsx'

    -- plug for markdown
    use 'godlygeek/tabular'
    use {
        'plasticboy/vim-markdown', setup = function()
            vim.g.vim_markdown_fenced_languages = { 'css', 'java', 'javascript', 'js=javascript', 'sass', 'xml', 'typescrtpt', 'ts=typescrtpt' }
        end
    }
    use { 'iamcco/markdown-preview.nvim', cmd = 'cd app && yarn install', ft = { 'markdown', 'vim-plug' } }

    -- Plug for git
    use 'kdheepak/lazygit.nvim'

    use 'nvim-lua/plenary.nvim' -- required by gitsigns
    use 'lewis6991/gitsigns.nvim'

    use { 'junegunn/fzf', run = ":call fzf#install()" }
    use { 'junegunn/fzf.vim' }

    if packer_bootstrap then
        require('packer').sync()
    end
end)

require("mason").setup()
