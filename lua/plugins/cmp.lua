-- nvim/lua/plugins/cmp.lua
-- Autocompletion config for nvim-cmp (Neovim 0.11)
return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-nvim-lsp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
    },
    config = function()
        local ok_cmp, cmp = pcall(require, "cmp")
        if not ok_cmp then
            vim.notify("nvim-cmp not available", vim.log.levels.WARN)
            return
        end

        local ok_luasnip, luasnip = pcall(require, "luasnip")
        if not ok_luasnip then
            -- snippets optional; keep plugin loads lazy-friendly
            luasnip = nil
        end

        -- load friendly-snippets if available (optional)
        pcall(function() require("luasnip.loaders.from_vscode").lazy_load() end)

        cmp.setup({
            completion = {
                completeopt = "menu,menuone,noselect",
            },
            snippet = {
                expand = function(args)
                    if luasnip then
                        luasnip.lsp_expand(args.body)
                    end
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<CR>"] = cmp.mapping.confirm({ select = true }),
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip and luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip and luasnip.jumpable(-1) then
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
            experimental = {
                ghost_text = false, -- toggle if you like inline ghost completions
            },
        })

        -- Optional: enable cmp for command-line (/: and ?/)
        pcall(function()
            cmp.setup.cmdline("/", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = { { name = "buffer" } },
            })
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
            })
        end)
    end,
}

