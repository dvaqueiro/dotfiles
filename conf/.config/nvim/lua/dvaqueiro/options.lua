local options = {
    number = true,              -- set line numbers
    relativenumber = true,      -- set relative line numbers
    fileencoding = 'utf-8',     -- file encoding on write
    cursorline = true,          -- highligth current cursor line
    scrolloff = 8,
    wrap = true,                -- wrap long lines
    expandtab = true,           -- convert tabs to spaces
    mouse = '',                 -- disable mouse support
    tabstop = 4,                -- default tab length
    softtabstop = 4,
    shiftwidth = 4,
    autoindent = true,
    hlsearch = false,           -- /search beahivour
    incsearch = true,           -- \
    backup = false,             -- /
    swapfile = false,           -- | history beahivour
    undofile = true,            -- \
    updatetime = 300,
    guifont = 'Hack 14',
    listchars = 'tab:→ ,eol:↲,nbsp:␣,trail:•,extends:⟩,precedes:⟨',
    showbreak = '↪',
    foldlevel = 20
}

for k, v in pairs(options) do
    vim.opt[k] = v
end

-- Fillchars
vim.opt.fillchars = {
  vert = "│",
  fold = "⠀",
  eob = " ", -- suppress ~ at EndOfBuffer
  --diff = "⣿", -- alternatives = ⣿ ░ ─ ╱
  msgsep = "‾",
  foldopen = "▾",
  foldsep = "│",
  foldclose = "▸",
}
