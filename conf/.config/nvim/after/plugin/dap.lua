local dap, dapui = require("dap"), require("dapui")

dapui.setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

require("nvim-dap-virtual-text").setup()

dap.adapters.php = {
  type = 'executable',
  command = 'node',
  args = { os.getenv('HOME') .. '/Documents/dev/vscode-php-debug/out/phpDebug.js' }
}

dap.configurations.php = {
  {
    type = 'php',
    request = 'launch',
    name = 'Listen for Xdebug',
    port = 9003,
    log = true
  }
}

vim.keymap.set('n', '<F5>', "<cmd>lua require'dap'.continue()<CR>")
vim.keymap.set('n', '<F10>', "<cmd>lua require'dap'.step_over()<CR>")
vim.keymap.set('n', '<F11>', "<cmd>lua require'dap'.step_out()<CR>")
vim.keymap.set('n', '<F12>', "<cmd>lua require'dap'.step_into()<CR>")
vim.keymap.set('n', '<Leader>b', "<cmd>lua require'dap'.toggle_breakpoint()<CR>")
vim.keymap.set('n', '<Leader>B', "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
