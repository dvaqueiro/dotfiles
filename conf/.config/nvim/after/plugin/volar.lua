require'lspconfig'.volar.setup{
    filetypes = {'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json'},
    init_options = {
    typescript = {
      -- tsdk = '/path/to/.npm/lib/node_modules/typescript/lib'
      -- Alternative location if installed as root:
      -- tsdk = '/usr/local/lib/node_modules/typescript/lib'
      --tsdk = '/usr/lib/node_modules/typescript/lib/'
      tsdk = ''
    }
  }
}
