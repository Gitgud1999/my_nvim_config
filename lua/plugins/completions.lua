return {
  {
    "hrsh7th/cmp-nvim-lsp",
  },
  {
    "hrsh7th/cmp-buffer",
  },
  {
    "hrsh7th/cmp-path",
  },
  {
    "hrsh7th/cmp-nvim-lua",
  },
  {
    "hrsh7th/cmp-cmdline",
  },
  {
    "hrsh7th/cmp-calc",
  },
  {
    "hrsh7th/cmp-emoji",
  },
  {
    "petertriho/cmp-git",
    dependencies = "nvim-lua/plenary.nvim",
  },
  {
    "David-Kunz/cmp-npm",
    dependencies = "nvim-lua/plenary.nvim",
  },
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "onsails/lspkind.nvim", -- for pretty icons
    },
    config = function()
      local cmp = require("cmp")
      local lspkind = require("lspkind")
      
      require("luasnip.loaders.from_vscode").lazy_load()
      
      -- Setup completion for different filetypes
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        formatting = {
          format = lspkind.cmp_format({
            mode = 'symbol_text',
            maxwidth = 50,
            ellipsis_char = '...',
            before = function(entry, vim_item)
              -- Source name
              vim_item.menu = ({
                nvim_lsp = "[LSP]",
                luasnip = "[Snippet]",
                buffer = "[Buffer]",
                path = "[Path]",
                nvim_lua = "[Lua]",
                calc = "[Calc]",
                emoji = "[Emoji]",
                git = "[Git]",
                npm = "[NPM]",
              })[entry.source.name]
              return vim_item
            end,
          }),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif require("luasnip").expand_or_jumpable() then
              require("luasnip").expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif require("luasnip").jumpable(-1) then
              require("luasnip").jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip", priority = 750 },
          { name = "path", priority = 500 },
          { name = "nvim_lua", priority = 400 },
          { name = "calc", priority = 300 },
          { name = "emoji", priority = 200 },
        }, {
          { name = "buffer", priority = 500 },
        }),
      })

      -- Setup for specific filetypes
      
      -- Git commits
      cmp.setup.filetype('gitcommit', {
        sources = cmp.config.sources({
          { name = 'git' },
          { name = 'buffer' },
        })
      })
      
      -- Package.json files
      cmp.setup.filetype({ "json" }, {
        sources = cmp.config.sources({
          { name = "npm" },
          { name = "nvim_lsp" },
          { name = "buffer" },
        })
      })
      
      -- DAP REPL (only if you have nvim-dap installed)
      -- cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
      --   sources = {
      --     { name = "dap" },
      --   },
      -- })
      
      -- Python specific (enhanced with common libraries)
      cmp.setup.filetype("python", {
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer", keyword_length = 3 },
          { name = "path" },
        })
      })
      
      -- JavaScript/TypeScript
      cmp.setup.filetype({ "javascript", "typescript", "javascriptreact", "typescriptreact" }, {
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "npm" },
          { name = "buffer", keyword_length = 3 },
          { name = "path" },
        })
      })
      
      -- Rust
      cmp.setup.filetype("rust", {
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer", keyword_length = 3 },
          { name = "path" },
        })
      })
      
      -- C/C++
      cmp.setup.filetype({ "c", "cpp" }, {
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer", keyword_length = 3 },
          { name = "path" },
        })
      })
      
      -- Command line completion
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })
      
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        })
      })
      
      -- Git setup
      require("cmp_git").setup()
    end,
  },
}
