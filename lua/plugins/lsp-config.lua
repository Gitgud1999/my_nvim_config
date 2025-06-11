return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- Setup Mason first
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })
      
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
      
      -- Setup mason-lspconfig for automatic server installation
      local servers = {
        "ts_ls",
        "solargraph", 
        "html",
        "lua_ls",
        "clangd",
        "pyright",
        "rust_analyzer",
        "julials",
        "bashls",
        "yamlls",
        "jsonls",
        "fortls",  -- Fortran language server
      }
      
      require("mason-lspconfig").setup({
        ensure_installed = servers,
        automatic_installation = true,
      })
      
      -- Setup each server
      for _, server in ipairs(servers) do
        if lspconfig[server] and lspconfig[server].setup then
          lspconfig[server].setup({
            capabilities = capabilities,
            on_attach = on_attach,
          })
        else
          vim.notify("LSP server '" .. server .. "' is not available in lspconfig", vim.log.levels.WARN)
        end
      end
    end,
  },
}
