return {
  'coder/claudecode.nvim',
  -- El plugin depende de snacks.nvim para algunas funcionalidades de interfaz,
  -- que normalmente ya viene incluido en LazyVim moderno.
  dependencies = { 'folke/snacks.nvim' },
  -- Se carga de forma diferida solo cuando ejecutas el comando o usas un atajo
  cmd = 'ClaudeCode',
  keys = {
    -- Atajo para abrir el terminal de Claude
    { '<leader>cc', '<cmd>ClaudeCode<cr>', desc = 'Abrir Claude Code' },
    -- Este atajo funciona en modo visual. Si seleccionas código y pulsas 'as',
    -- enviará esa selección directamente al contexto de Claude
    { 'as', "<cmd>lua require('claudecode').send_at_mention()<cr>", desc = 'Enviar selección a Claude', mode = { 'n', 'x' } },
  },
  config = function()
    require('claudecode').setup {}
  end,
}
