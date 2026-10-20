return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'echasnovski/mini.icons', -- Provee los iconos que ves junto a los títulos
  },
  opts = {
    -- Es crucial añadir "codecompanion" para que el plugin actúe sobre esos buffers
    file_types = { 'markdown', 'codecompanion' },
    anti_conceal = {
      -- This enables hiding added text on the line the cursor is on.
      enabled = false,
    },
  },
}
