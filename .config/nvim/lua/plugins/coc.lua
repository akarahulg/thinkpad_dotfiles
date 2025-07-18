-- ~/.config/nvim/lua/plugins/coc.lua
return {
	{
		"neoclide/coc.nvim",
		branch = "release",
		build = "yarn install --frozen-lockfile",
		event = "VeryLazy", -- <- This tells Lazy to actually load it
		config = function()
			vim.g.coc_global_extensions = {
				"coc-snippets",
				"coc-html",
				"coc-css",
				"coc-json",
				"coc-tsserver",
				"coc-lua",
				"coc-pyright",
				"coc-vimtex"
			}
		end,
	}
}
