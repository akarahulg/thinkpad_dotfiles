return {
	-- Clipboard integration using OSC52 (works in most terminals)
	{
		"ojroques/nvim-osc52",
		event = "VeryLazy",
		config = function()
			require("osc52").setup({
				max_length = 0,
				silent = false,
				trim = false,
			})
			vim.api.nvim_create_autocmd("TextYankPost", {
				callback = function()
					if vim.v.event.operator == "y" and vim.v.event.regname == "" then
						require("osc52").copy_register("")
					end
				end,
			})
		end,
	},

	-- Indentation guides
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		event = "BufReadPre",
		opts = {
			indent = { char = "│" },
			scope = { enabled = false }, -- Set to true if you want scope highlighting
		},
	},

	-- Core Syntax Engine (absolutely essential)
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"c", "lua", "vim", "vimdoc", "query",
					"python", "javascript", "typescript", "html", "css"
				},
				sync_install = false,
				highlight = { enable = true },
				indent = { enable = true },
				-- The two plugins below are now included in nvim-treesitter
				-- autotag = { enable = true },
				-- textobjects = { enable = true },
			})
		end,
	},

	-- Treesitter autotag (auto-close/rename HTML/XML tags)
	-- Note: This is now often included directly in nvim-treesitter's config
	{
		"windwp/nvim-ts-autotag",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		event = "InsertEnter",
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},

	-- ===================================================================
	-- LSP, Autocompletion, and Mason Setup (The Fix)
	-- ===================================================================

	-- Mason: Manages LSP servers, linters, and formatters
	{
		"williamboman/mason.nvim",
		lazy = false, -- ensure it loads at startup
		config = function()
			require("mason").setup()
		end,
	},

	-- -- Mason-LSPConfig: Bridges Mason with nvim-lspconfig
	-- {
	-- 	"williamboman/mason-lspconfig.nvim",
	-- 	dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
	-- 	config = function()
	-- 		-- This setup will automatically install the servers and set up handlers.
	-- 		require("mason-lspconfig").setup({
	-- 			ensure_installed = { "pyright", "tsserver", "cssls", "html", "lua_ls" },
	-- 			handlers = {
	-- 				-- The default handler will call `lspconfig` for each installed server.
	-- 				function(server_name)
	-- 					require("lspconfig")[server_name].setup({})
	-- 				end,
	--
	-- 				-- Custom setup for lua_ls to specify runtime settings
	-- 				["lua_ls"] = function()
	-- 					require("lspconfig").lua_ls.setup({
	-- 						settings = {
	-- 							Lua = {
	-- 								runtime = { version = "LuaJIT" },
	-- 								diagnostics = { globals = { "vim" } },
	-- 							},
	-- 						},
	-- 					})
	-- 				end,
	-- 			},
	-- 		})
	-- 	end,
	-- },

	-- nvim-lspconfig: The core plugin to configure LSP servers
	-- {
	-- 	"neovim/nvim-lspconfig",
	-- 	event = "BufReadPre",
	-- 	config = function()
	-- 		-- This on_attach function will be called for every LSP that attaches to a buffer.
	-- 		-- It's the perfect place to set up LSP-related keybindings.
	-- 		local on_attach = function(client, bufnr)
	-- 			local opts = { noremap = true, silent = true, buffer = bufnr }
	-- 			vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
	-- 			vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
	-- 			vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
	-- 			vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
	-- 			vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
	-- 			vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
	-- 			vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
	-- 			vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, opts)
	-- 		end
	--
	-- 		-- Here, we're just overriding the on_attach function for all servers.
	-- 		-- The actual server setup is handled by mason-lspconfig above.
	-- 		local lsp_flags = { debounce_text_changes = 150 }
	-- 		require("lspconfig").util.default_config = vim.tbl_deep_extend(
	-- 			"force",
	-- 			require("lspconfig").util.default_config,
	-- 			{
	-- 				on_attach = on_attach,
	-- 				flags = lsp_flags,
	-- 			}
	-- 		)
	-- 	end
	-- },
	--
	-- nvim-cmp: The completion engine
	--[[
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", -- Source for LSP completions
			"hrsh7th/cmp-buffer", -- Source for buffer text completions
			"hrsh7th/cmp-path", -- Source for file path completions
			"L3MON4D3/LuaSnip", -- Snippet engine
			"saadparwaiz1/cmp_luasnip", -- Bridge between nvim-cmp and LuaSnip
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					['<C-b>'] = cmp.mapping.scroll_docs(-4),
					['<C-f>'] = cmp.mapping.scroll_docs(4),
					['<C-Space>'] = cmp.mapping.complete(),
					['<C-e>'] = cmp.mapping.abort(),
					['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item.
					-- Use Tab to navigate through suggestions
					['<Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					['<S-Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
				}),
			})
		end,
	},
	]]
}
