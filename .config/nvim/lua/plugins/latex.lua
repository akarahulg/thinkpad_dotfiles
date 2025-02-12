return {
  {
    "lervag/vimtex",
    lazy = false, -- Load VimTeX immediately
    config = function()
      -- Set the LaTeX compiler to latexmk
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_latexmk = {
        continuous = 1, -- Auto-compile on save
        callback = 1,
        build_dir = "build", -- Store compiled files in 'build/'
        options = {
          "-pdf",                 -- Compile to PDF
          "-interaction=nonstopmode", -- Don't stop on warnings
          "-synctex=1",           -- Enable SyncTeX
          "-file-line-error",      -- Show line numbers in errors
          "-halt-on-error",        -- Stop only on fatal errors
          "-silent",               -- Reduce log output
          "-quiet",                -- Hide warnings
        },
      }

      -- Set the PDF viewer (Evince by default)
      vim.g.vimtex_view_general_viewer = "evince" -- Change to "zathura" if preferred
      --
      -- Conceal settings for a cleaner look
      vim.g.vimtex_syntax_conceal = {
        accents = 1,
        ligatures = 1,
        math_delimiters = 1,
        greek = 1,
        subscripts = 1,
        superscripts = 1,
      }

      -- Enable folding of LaTeX sections
      vim.g.vimtex_fold_enabled = 1
    end,
  },
}

