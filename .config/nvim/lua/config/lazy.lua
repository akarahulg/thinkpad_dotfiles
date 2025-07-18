-- File: ~/.config/nvim/lua/lazy.lua (The Minimal Foundation)

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- This is the crucial part:
    -- We are NOT importing "LazyVim/LazyVim" anymore.
    -- We are ONLY importing our own plugins from the `lua/plugins/` directory.
    { import = "plugins" },
  },
  -- Sensible defaults for a custom setup
  defaults = {
    lazy = true, -- Lazy load plugins by default for maximum speed
    version = false,
  },
  checker = {
    enabled = false, -- Disable update checking
  },
  performance = {
    rtp = {
      -- Disable some standard Vim plugins we don't need
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

require("config.options")
require("config.keymaps")
require("config.autocmds")
