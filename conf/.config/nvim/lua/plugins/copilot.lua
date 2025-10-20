return {
  'github/copilot.vim',
  vim.api.nvim_set_keymap('i', '<C-j>', 'copilot#Accept("<CR>")', { expr = true, silent = true }),
}
