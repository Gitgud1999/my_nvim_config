return {
  {
  "folke/todo-comments.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-lua/plenary.nvim" },
  confi = function()
    require("todo-comments").setup({})
  end,
 }
}
