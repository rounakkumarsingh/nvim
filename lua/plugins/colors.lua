-- nvim/lua/plugins/colors.lua
return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "mocha", -- default dark
            })
        end,
    },

    {
        "folke/tokyonight.nvim",
        priority = 1000,
    },

    {
        "sainnhe/everforest",
        priority = 1000,
    },
}

