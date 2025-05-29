return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "ts_ls",
        "solargraph", 
        "html",
        "lua_ls",
        "clangd",       -- C/C++
        "pyright",      -- Python
        "rust_analyzer", -- Rust (systems/embedded)
        "verilog_ls",   -- Verilog/SystemVerilog
        "svls",         -- SystemVerilog
        "julials",      -- Julia (scientific computing)
        "r_language_server", -- R (data analysis)
        "bashls",       -- Bash scripting
        "yamlls",       -- YAML configs
        "jsonls",       -- JSON configs
      },
      auto_install = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = { 
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      
      local on_attach = function(_, bufnr)
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, silent = true, noremap = true })
        end
        map("n", "K", vim.lsp.buf.hover, "LSP Hover")
        map("n", "<leader>gd", vim.lsp.buf.definition, "Go to Definition")
        map("n", "<leader>gr", vim.lsp.buf.references, "Find References")
        map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
        map("n", "<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
        map("n", "<leader>fm", function() vim.lsp.buf.format({ async = true }) end, "Format File")
      end
      
      -- Manual server configuration
      lspconfig.ts_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
      
      lspconfig.solargraph.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
      
      lspconfig.html.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
      
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
      
      lspconfig.clangd.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
      
      lspconfig.pyright.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
      
      lspconfig.rust_analyzer.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
      
      lspconfig.verilog_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
      
      lspconfig.svls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
      
      lspconfig.julials.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
      
      lspconfig.r_language_server.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
      
      lspconfig.bashls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
      
      lspconfig.yamlls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
      
      lspconfig.jsonls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
    end,
  },
}
