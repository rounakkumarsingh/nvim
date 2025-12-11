-- nvim/lua/plugins/tools.lua
-- utility/plugins list (mason, treesitter, dap, conform, cmp)
-- NOTE: we intentionally do NOT re-declare nvim-lspconfig here to avoid duplication
return {
    -- mason UI and installer
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        build = ":MasonUpdate",
    },

    {
        "williamboman/mason-lspconfig.nvim",
    },

    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
    },

    -- conform (formatting) - actual config in conform.lua
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
    },

    -- completion - actual config in cmp.lua
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
    },

    -- debugging (optional)
    {
        "mfussenegger/nvim-dap",
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap" },
    },

    -- Treesitter for highlighting & incremental selection
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        -- recommended: lazy-load on BufRead to speed startup
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            ensure_installed = {
                "python", "go", "java", "c", "cpp", "javascript", "typescript",
                "tsx", "jsx", "html", "css", "lua", "bash", "json", "rust",
            },
            highlight = { enable = true },
            indent = { enable = true },
        },
    },
}

