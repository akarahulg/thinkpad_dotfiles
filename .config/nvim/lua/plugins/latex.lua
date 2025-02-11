return {
  {
    "lervag/vimtex",
    lazy = false, -- Load immediately
    config = function()
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_latexmk = {
        continuous = 1, -- Auto-compile on save
        callback = 1,
        build_dir = "build",
        options = {
          "-pdf",
          "-interaction=nonstopmode",
          "-synctex=1",
          "-silent",
          "-quiet",
        },
      }
      -- Conceal certain symbols for cleaner look
      vim.g.vimtex_syntax_conceal = {
        accents = 1,
        ligatures = 1,
        math_delimiters = 1,
        greek = 1,
        subscripts = 1,
        superscripts = 1,
      }
      vim.g.vimtex_fold_enabled = 1 -- Enable section folding
    end,
  },
}
