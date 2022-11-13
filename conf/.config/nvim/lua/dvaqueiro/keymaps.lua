local opts = { noremap = true, silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

-- Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Disable arrow keys
keymap("n", "<Up>", "<Nop>", opts)
keymap("n", "<Down>", "<Nop>", opts)
keymap("n", "<Left>", "<Nop>", opts)
keymap("n", "<Right>", "<Nop>", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Show next matched string at the center of the screen
keymap("n", "n", "nzz", opts)
keymap("n", "N", "Nzz", opts)

-- Special functions
keymap("n", "<F2>", ":set list!", opts)
keymap("n", "<S-F2>", ":IndentLinesToggle<CR>", opts)
keymap("n", "<F3>", ":set hlsearch!", opts)
keymap("n", "<F4>", ":set number!", opts)
keymap("v", ".", ":normal .<CR>", opts)

-- Toggle Nvin Tree
keymap("n", "<leader>ex", ":NvimTreeFindFileToggle<CR>", opts)
