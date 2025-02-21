return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false, -- Load immediately
    priority = 1000, -- Ensure it loads before other plugins
    config = function()
      require("kanagawa").setup({
        compile = false, -- Set to true if you want faster startup
        transparent = false, -- Set to true for a transparent background
        theme = "wave", -- Options: "wave", "dragon", "lotus"
        colors = {
          theme = {
            all = {
              ui = {
                bg_gutter = "none", -- Remove side panel background
              },
            },
          },
        },
      })
      vim.cmd("colorscheme kanagawa") -- Apply the colorscheme
    end,
  },
}

