if has("nvim")
  let g:plug_home = stdpath('data') . '/plugged'
endif

call plug#begin()

Plug 'morhetz/gruvbox'
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'nvim-lualine/lualine.nvim'
Plug 'cohama/lexima.vim'
Plug 'tpope/vim-fugitive'
"Plug 'dense-analysis/ale'

if has("nvim")
   Plug 'nvim-lua/plenary.nvim'
   Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }
   Plug 'nvim-telescope/telescope-file-browser.nvim'
   Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
   Plug 'nvim-telescope/telescope-symbols.nvim'
   Plug 'kyazdani42/nvim-web-devicons'
   Plug 'kyazdani42/nvim-tree.lua'
   Plug 'neovim/nvim-lspconfig'
   Plug 'hrsh7th/cmp-nvim-lsp'
   Plug 'hrsh7th/cmp-buffer'
   Plug 'hrsh7th/cmp-path'
   Plug 'hrsh7th/nvim-cmp'
   Plug 'ray-x/lsp_signature.nvim'
   Plug 'onsails/lspkind.nvim'
   Plug 'lewis6991/gitsigns.nvim'
   Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
   Plug 'saadparwaiz1/cmp_luasnip'  " Snippets source
   Plug 'L3MON4D3/LuaSnip'          " Snippet engine
   Plug 'mfussenegger/nvim-dap'
   Plug 'rcarriga/nvim-dap-ui'
   Plug 'theHamsta/nvim-dap-virtual-text'
   "Plug 'glepnir/lspsaga.nvim', { 'branch': 'main' }
endif

call plug#end()
