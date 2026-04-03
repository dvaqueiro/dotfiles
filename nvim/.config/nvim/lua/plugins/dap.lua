return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',         -- Interfaz visual hermosa para el debugger
    'nvim-neotest/nvim-nio',        -- Dependencia de dap-ui
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim', -- Puente entre mason y dap
    'theHamsta/nvim-dap-virtual-text',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    -- 1. Configurar Mason para que instale el adaptador de PHP
    require('mason-nvim-dap').setup {
      ensure_installed = { 'php' }, -- Esto instala 'php-debug-adapter' automáticamente
      handlers = {},
    }

    -- Activar el texto virtual con su configuración por defecto
    require('nvim-dap-virtual-text').setup {
      commented = true,              -- Muestra el valor como un comentario (ej: // 5)
      -- 1. Mostrar en todas partes
      only_first_definition = false, -- No limitarlo solo a la declaración original
      all_references = true,         -- Mostrar el valor en todas las líneas donde se use esa variable
      -- 2. Mantener el código limpio
      virt_text_pos = 'eol',         -- 'eol' = End Of Line. Lo pone pegado al margen derecho, no entre tu código.
      -- 3. Limpieza automática
      clear_on_continue = true,      -- Borra el texto virtual cuando sueltas la pausa (F5) para que no haya "fantasmas"
    }

    -- 2. Configurar la Interfaz (DAP UI) personalizada
    dapui.setup {
      layouts = {
        {
          -- PANEL LATERAL (A la derecha)
          elements = {
            { id = 'scopes',  size = 0.60 }, -- Variables locales: 60% del espacio
            { id = 'watches', size = 0.20 }, -- Expresiones vigiladas: 20%
            { id = 'stacks',  size = 0.20 }, -- Pila de llamadas (útil en Symfony): 20%
            -- He eliminado 'breakpoints' visuales de aquí para ahorrar espacio,
            -- ya los ves con el punto rojo en el código.
          },
          size = 55,          -- Ancho del panel (el defecto es 40, lo hacemos más ancho para leer bien PHP)
          position = 'right', -- Lo movemos a la derecha
        },
        {
          -- PANEL INFERIOR
          elements = {
            { id = 'repl', size = 1.0 }, -- REPL ocupa todo el panel inferior
            -- He eliminado 'console' porque en Xdebug no escupe nada útil
          },
          size = 8, -- Lo hacemos más bajito para que no te coma tanta pantalla
          position = 'bottom',
        },
      },
    }

    -- Abrir y cerrar la UI automáticamente cuando Xdebug se conecta/desconecta
    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated['dapui_config'] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited['dapui_config'] = function()
      dapui.close()
    end
    dap.listeners.before.disconnect['dapui_config'] = function()
      dapui.close()
    end
    -- Evaluar expresión bajo el cursor
    vim.keymap.set({ 'n', 'v' }, '<leader>de', function()
      require('dapui').eval()
    end, { desc = 'DAP: Evaluar bajo el cursor' })
    -- Poner Breakpoint Condicional
    vim.keymap.set('n', '<leader>bc', function()
      local condition = vim.fn.input 'Condición PHP (ej: $count > 5): '
      if condition ~= '' then
        require('dap').set_breakpoint(condition)
      end
    end, { desc = 'DAP: Breakpoint Condicional' })
    -- Poner un LogPoint
    vim.keymap.set('n', '<leader>bl', function()
      local message = vim.fn.input 'Mensaje a loguear (puedes usar {expresion}): '
      if message ~= '' then
        require('dap').set_breakpoint(nil, nil, message)
      end
    end, { desc = 'DAP: LogPoint' })

    -- Configuración específica de PHP para Docker
    dap.configurations.php = {
      {
        type = 'php',
        request = 'launch',
        name = 'Docker (Mapeo: /var/www/html)',
        port = 9003,
        pathMappings = {
          ['/var/www/html'] = vim.fn.getcwd(),
        },
      },
      {
        type = 'php',
        request = 'launch',
        name = 'Docker (Mapeo: /app)',
        port = 9003,
        pathMappings = {
          ['/app'] = vim.fn.getcwd(),
        },
      },
    }

    -- 3. Atajos de teclado básicos
    vim.keymap.set('n', '<F5>', function()
      dap.continue()
    end, { desc = 'DAP: Iniciar/Continuar' })
    vim.keymap.set('n', '<F10>', function()
      dap.step_over()
    end, { desc = 'DAP: Siguiente línea' })
    vim.keymap.set('n', '<F11>', function()
      dap.step_into()
    end, { desc = 'DAP: Entrar en función' })
    vim.keymap.set('n', '<F12>', function()
      dap.step_out()
    end, { desc = 'DAP: Salir de función' })
    vim.keymap.set('n', '<leader>b', function()
      dap.toggle_breakpoint()
    end, { desc = 'DAP: Poner/Quitar Breakpoint' })
    -- Alternar la interfaz visual (abrir/cerrar)
    vim.keymap.set('n', '<leader>du', function()
      require('dapui').toggle()
    end, { desc = 'DAP: Toggle UI' })
    -- Terminar la sesión de golpe y cerrar todo
    vim.keymap.set('n', '<leader>dx', function()
      require('dap').terminate()
      require('dapui').close()
    end, { desc = 'DAP: Cerrar sesión y UI' })

    -- Configurar iconos y colores para los Breakpoints y la línea actual
    local dap_signs = {
      DapBreakpoint = { text = '🔴', texthl = 'DiagnosticSignError', linehl = '', numhl = '' },
      DapBreakpointCondition = { text = '🟡', texthl = 'DiagnosticSignWarn', linehl = '', numhl = '' },
      DapBreakpointRejected = { text = '❌', texthl = 'DiagnosticSignError', linehl = '', numhl = '' },
      DapLogPoint = { text = '💬', texthl = 'DiagnosticSignInfo', linehl = '', numhl = '' },
      DapStopped = { text = '👉', texthl = 'DiagnosticSignWarn', linehl = 'Visual', numhl = 'DiagnosticSignWarn' },
    }

    for name, dict in pairs(dap_signs) do
      vim.fn.sign_define(name, dict)
    end
  end,
}
