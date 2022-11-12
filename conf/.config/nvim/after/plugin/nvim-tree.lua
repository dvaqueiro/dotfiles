-- empty setup using defaults
require("nvim-tree").setup({
    view = {
        side = "left",
        adaptive_size = true
    },
    actions = {
        open_file = {
            quit_on_open = true
        }
    },
    filters = {
        dotfiles = true,
    },
})
