-- File: ~/.config/nvim/lua/plugins/colorscheme.lua
--
-- return {
--   "folke/tokyonight.nvim",
--   lazy = false, -- make sure we load this during startup if it is your main colorscheme
--   priority = 1000, -- make sure to load this before all the other start plugins
--   config = function()
--     -- Load the colorscheme here
--     vim.cmd.colorscheme("tokyonight")
--
--     -- You can configure highlights by doing something like:
--     -- vim.cmd.hi("Comment gui=italic")
--   end,
-- }
--

-- -- For Kanagawa
return {
  "rebelot/kanagawa.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("kanagawa")
  end,
}
