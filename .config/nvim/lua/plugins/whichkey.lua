return {
  "folke/which-key.nvim",
  lazy = false, -- Load at startup
  config = function()
    require("which-key").setup({})
  end,
}