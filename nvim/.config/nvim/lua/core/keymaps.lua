-- Set leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disable the spacebar key's default behaiviour in Normal and Visual Modes
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- For conciseness
local opts = { noremap = true, silent = true }

-- Save files an save files without autoformatting
vim.keymap.set('n', '<C-s>', '<cmd> w <CR>', opts)
vim.keymap.set('n', '<leader>sn', '<cmd>noautocmd w <CR>', opts)

-- delete single char without copy to register
vim.keymap.set('n', 'x', '"_x', opts)

-- Vertical scroll and center
vim.keymap.set('n', '<C-d>', '<C-d>zz', opts)
vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)

-- Find and center
vim.keymap.set('n', 'n', 'nzzzv', opts)
vim.keymap.set('n', 'N', 'Nzzzv', opts)

-- Resize with arrows
vim.keymap.set('n', '<Up>', ':resize -2<CR>', opts)
vim.keymap.set('n', '<Down>', ':resize +2<CR>', opts)
vim.keymap.set('n', '<Left>', ':vertical resize -2<CR>', opts)
vim.keymap.set('n', '<Right>', ':vertical resize +2<CR>', opts)

-- Toggle line wrapping
vim.keymap.set('n', '<leader>lw', '<cmd>set wrap!<CR>', opts)

-- Stay in indent mode
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)

-- Keep last yanked when pasting
vim.keymap.set('v', 'p', '"_dP', opts)

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Base64 decode/encode
vim.keymap.set('v', '<Leader>64d', 'y:let @"=system(\'base64 -w 0 --decode\', @")<cr>gvP', opts)
vim.keymap.set('v', '<Leader>64e', 'y:let @"=system(\'base64 -w 0\', @")<cr>gvP', opts)

vim.api.nvim_create_user_command('CopyPHPClass', function()
  -- Obtener todo el contenido del buffer actual
  local content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), '\n')

  -- 1. Buscar el namespace (ej: namespace App\Models;)
  local namespace = content:match 'namespace%s+([%w\\]+);'

  -- 2. Buscar el nombre de la entidad (Clase, Interface o Trait)
  -- Lua evalúa los 'or' en orden, quedándose con el primero que encuentre.
  local object_name = content:match 'class%s+([%w_]+)' or content:match 'interface%s+([%w_]+)' or content:match 'trait%s+([%w_]+)'

  if namespace and object_name then
    -- Construir el FQCN (Fully Qualified Class Name)
    local full_name = namespace .. '\\' .. object_name

    -- Copiar al registro por defecto (") y al del sistema (+)
    vim.fn.setreg('"', full_name)
    vim.fn.setreg('+', full_name)

    print('Copiado al portapapeles: ' .. full_name)
  else
    print 'No pude encontrar un namespace y una clase/interface/trait válidos.'
  end
end, {})

-- Mismo atajo sugerido
vim.keymap.set('n', '<leader>cp', ':CopyPHPClass<CR>', { desc = 'Copiar PHP Class path' })
