return {
    {
        "nvim-neorg/neorg",
        lazy = false,  -- Disable lazy loading
        version = "*", -- Pin to the latest stable version
        config = function()
            -- Neorg configuration goes here
            require("neorg").setup {}
        end,
    },
}
