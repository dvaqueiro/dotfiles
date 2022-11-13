require('dvaqueiro.options')
require('dvaqueiro.keymaps')

-- remove trailing whitespace when saving files
-- vim.cmd(autocmd BufWritePre *.php :%s/\s\+$//e) For php files only
vim.api.nvim_create_augroup('Misc', {clear = true})
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  group = 'Misc',
  command = '%s/\\s\\+$//e'
})

