-- File: ~/.config/nvim/lua/plugins/latex.lua

return {
	-- VIMTEX: The core LaTeX plugin
	{
		"lervag/vimtex",
		ft = { "tex" },
		config = function()
			vim.g.vimtex_compiler_method = "latexmk"
			vim.g.vimtex_compiler_latexmk = {
				build_dir = "build",
				options = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "-file-line-error" },
			}
			vim.g.vimtex_view_method = "general"
			vim.g.vimtex_view_general_viewer = "evince"
			vim.g.vimtex_compiler_continuous_automatic = 1
			vim.g.vimtex_syntax_conceal_enabled = 0
		end,
	},
}

--   -- LSP & LINTING for LaTeX (grammar, spell, completion, etc.)
--   {
--     "neovim/nvim-lspconfig",
--     ft = { "tex" },
--     config = function()
--       local lspconfig = require("lspconfig")
--       lspconfig.ltex.setup({
--         settings = { ltex = { language = "en-US" } },
--       })
--       lspconfig.texlab.setup({}) -- <-- Enable texlab for completion
--     end,
--   },
--
--   -- AUTOCOMPLETION source for LaTeX
--   {
--     "hrsh7th/nvim-cmp",
--     dependencies = { "micangl/cmp-vimtex" },
--     ft = { "tex" },
--     opts = function(_, opts)
--       opts.sources = opts.sources or {}
--       table.insert(opts.sources, { name = "vimtex" })
--       return opts
--     end,
--   },
-- }
