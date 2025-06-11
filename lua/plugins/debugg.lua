return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "mfussenegger/nvim-dap-python",
    "nvim-neotest/nvim-nio", -- Required for nvim-dap-ui
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")
    
    -- Setup DAP UI
    dapui.setup({
      icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
      mappings = {
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
      },
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.25 },
            "breakpoints",
            "stacks",
            "watches",
          },
          size = 40,
          position = "left",
        },
        {
          elements = {
            "repl",
            "console",
          },
          size = 0.25,
          position = "bottom",
        },
      },
      controls = {
        enabled = true,
        element = "repl",
        icons = {
          pause = "",
          play = "",
          step_into = "",
          step_over = "",
          step_out = "",
          step_back = "",
          run_last = "↻",
          terminate = "□",
        },
      },
      floating = {
        max_height = nil,
        max_width = nil,
        border = "single",
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
      windows = { indent = 1 },
      render = {
        max_type_length = nil,
        max_value_lines = 100,
      },
    })
    
    -- Setup DAP Python (you need to specify Python path)
    require("dap-python").setup("python") -- or specify full path like "/usr/bin/python3"
    
    -- DAP UI auto-open/close
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end
    
    -- Key mappings
    vim.keymap.set('n', '<Leader>dt', function() dap.toggle_breakpoint() end, { desc = "Toggle Breakpoint" })
    vim.keymap.set('n', '<Leader>dc', function() dap.continue() end, { desc = "Continue" })
    vim.keymap.set('n', '<Leader>dso', function() dap.step_over() end, { desc = "Step Over" })
    vim.keymap.set('n', '<Leader>dsi', function() dap.step_into() end, { desc = "Step Into" })
    vim.keymap.set('n', '<Leader>dsO', function() dap.step_out() end, { desc = "Step Out" })
    vim.keymap.set('n', '<Leader>dr', function() dap.repl.open() end, { desc = "Open REPL" })
    vim.keymap.set('n', '<Leader>dl', function() dap.run_last() end, { desc = "Run Last" })
    vim.keymap.set('n', '<Leader>du', function() dapui.toggle() end, { desc = "Toggle DAP UI" })
    vim.keymap.set('n', '<Leader>dh', function() require('dap.ui.widgets').hover() end, { desc = "DAP Hover" })
    vim.keymap.set('n', '<Leader>dp', function() require('dap.ui.widgets').preview() end, { desc = "DAP Preview" })
    vim.keymap.set('n', '<Leader>df', function()
      local widgets = require('dap.ui.widgets')
      widgets.centered_float(widgets.frames)
    end, { desc = "DAP Frames" })
    vim.keymap.set('n', '<Leader>ds', function()
      local widgets = require('dap.ui.widgets')
      widgets.centered_float(widgets.scopes)
    end, { desc = "DAP Scopes" })
    
    -- Conditional breakpoint
    vim.keymap.set('n', '<Leader>dC', function()
      dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
    end, { desc = "Conditional Breakpoint" })
    
    -- Log point
    vim.keymap.set('n', '<Leader>dL', function()
      dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
    end, { desc = "Log Point" })
    
    -- Basic adapters for common languages
    
    -- Python (already handled by dap-python)
    -- JavaScript/TypeScript (Node.js)
    dap.adapters.node2 = {
      type = 'executable',
      command = 'node',
      args = {os.getenv('HOME') .. '/.local/share/nvim/mason/packages/node-debug2-adapter/out/src/nodeDebug.js'},
    }
    
    dap.configurations.javascript = {
      {
        name = 'Launch',
        type = 'node2',
        request = 'launch',
        program = '${file}',
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = 'inspector',
        console = 'integratedTerminal',
      },
      {
        name = 'Attach to process',
        type = 'node2',
        request = 'attach',
        processId = require'dap.utils'.pick_process,
      },
    }
    
    dap.configurations.typescript = dap.configurations.javascript
    
    -- Signs for breakpoints
    vim.fn.sign_define('DapBreakpoint', {text='🔴', texthl='', linehl='', numhl=''})
    vim.fn.sign_define('DapBreakpointCondition', {text='🟡', texthl='', linehl='', numhl=''})
    vim.fn.sign_define('DapLogPoint', {text='📝', texthl='', linehl='', numhl=''})
    vim.fn.sign_define('DapStopped', {text='▶️', texthl='', linehl='debugPC', numhl=''})
    vim.fn.sign_define('DapBreakpointRejected', {text='❌', texthl='', linehl='', numhl=''})
  end,
}
