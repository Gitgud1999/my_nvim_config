return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup({
      window = {
        width = 30,        -- 📏 set sidebar width
        position = "left", -- ⬅️ you can also use "right"
        mappings = {
          ["<space>"] = "toggle_node", -- expand/collapse
        },
      },
      filesystem = {
        filtered_items = {
          visible = true, -- show hidden files like .gitignore
        },
      },
    })

    -- 🔑 Keybindings to open Neo-tree
    vim.keymap.set("n", "<C-n>", ":Neotree filesystem reveal left<CR>", {})
    vim.keymap.set("n", "<leader>bf", ":Neotree buffers reveal float<CR>", {})
  end,
}
