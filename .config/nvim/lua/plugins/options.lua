-- File: ~/.config/nvim/lua/plugins/options.lua
-- This file contains core editor settings.

return {
  "nvim-lua/plenary.nvim", -- A dependency for the clipboard integration, just in case
  {
    "AstroNvim/astrocore", -- We use a helper from AstroCore to handle clipboard setup
    ---@type AstroCoreOpts
    opts = {
      options = {
        opt = {
          -- This is the crucial setting that enables the system clipboard
          clipboard = "unnamedplus",
        },
      },
    },
  },
}
