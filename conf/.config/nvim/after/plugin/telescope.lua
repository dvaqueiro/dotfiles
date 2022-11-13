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
