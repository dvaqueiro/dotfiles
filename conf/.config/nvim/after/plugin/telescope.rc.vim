" Find files using Telescope command-line sugar.
"nnoremap <leader>ff <cmd>Telescope find_files<cr>
"nnoremap <leader>fg <cmd>Telescope live_grep<cr>
"nnoremap <leader>fb <cmd>Telescope buffers<cr>
"nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Using Lua functions
" nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

lua << EOF
vim.keymap.set('n', '<Leader>ff', "<cmd>lua require('telescope.builtin').find_files()<cr>")
vim.keymap.set('v', '<C-f>', 'y<ESC>:Telescope live_grep default_text=<c-r>0<CR>')

require('telescope').setup{
defaults = {
    layout_strategy = 'horizontal',
    layout_config = { width = 0.99 },
  },
  extensions = {
    file_browser = {
      theme = "ivy",
    },
  },
}

require('telescope').load_extension('fzf')
require("telescope").load_extension "file_browser"
EOF
