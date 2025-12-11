-- nvim/lua/plugins/lsp.lua
-- LSP wiring for Neovim 0.11+ using vim.lsp.config / vim.lsp.enable
return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            -- safe requires
            local ok_mason, mason = pcall(require, "mason")
            if ok_mason then
                mason.setup()
            else
                vim.notify("mason not available", vim.log.levels.WARN)
            end

            local ok_mason_lsp, mason_lspconfig = pcall(require, "mason-lspconfig")
            if not ok_mason_lsp then
                vim.notify("mason-lspconfig not available", vim.log.levels.WARN)
                return
            end

            -- list of servers we want installed/enabled
            local servers = {
                "clangd",
                "ts_ls",         -- new recommended name (replaces tsserver)
                "jdtls",
                "gopls",
                "pyright",
                "rust_analyzer",
                "bashls",
                "lua_ls",
                "tailwindcss",
            }

            mason_lspconfig.setup({
                ensure_installed = servers,
                automatic_installation = true,
            })

            -- optional mason-tool-installer (for other binaries)
            local ok_tool_installer, toolinstaller = pcall(require, "mason-tool-installer")
            if ok_tool_installer then
                toolinstaller.setup({
                    ensure_installed = { "codelldb" }, -- extend if you want
                    run_on_start = false,
                })
            end

            -- capabilities: integrate with nvim-cmp if available
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            local ok_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
            if ok_cmp_nvim_lsp and cmp_nvim_lsp and cmp_nvim_lsp.default_capabilities then
                capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())
            end

            -- on_attach: buffer-local mappings & behavior
            local function on_attach(client, bufnr)
                local function bufmap(mode, lhs, rhs, desc)
                    vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, buffer = bufnr, desc = desc })
                end

                bufmap("n", "gd", vim.lsp.buf.definition, "LSP: goto definition")
                bufmap("n", "K", vim.lsp.buf.hover, "LSP: hover")
                bufmap("n", "gr", vim.lsp.buf.references, "LSP: references")
                bufmap("n", "<leader>rn", vim.lsp.buf.rename, "LSP: rename")
                bufmap("n", "<leader>ca", vim.lsp.buf.code_action, "LSP: code action")
                bufmap("n", "<leader>f", function() vim.lsp.buf.format { async = true } end, "LSP: format")

                -- Disable formatting capability for servers we intend to use external formatters for
                local noformat = { ts_ls = true, bashls = true }
                if noformat[client.name] and client.server_capabilities then
                    client.server_capabilities.documentFormattingProvider = false
                    client.server_capabilities.documentRangeFormattingProvider = false
                end

                -- enable inlay hints if supported and Neovim has the function
                if client.server_capabilities and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
                    pcall(vim.lsp.inlay_hint, bufnr, true)
                end
            end

            -- Set global defaults applied to all servers (merged with per-server config)
            vim.lsp.config("*", {
                capabilities = capabilities,
                on_attach = on_attach,
                -- You may add 'root_markers' or other defaults here if you like.
            })

            -- Server-specific settings (only when you want to override defaults)
            -- Lua
            vim.lsp.config("lua_ls", {
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                        workspace = { library = vim.api.nvim_get_runtime_file("", true) },
                        telemetry = { enable = false },
                    },
                },
            })

            -- TypeScript: tsserver -> ts_ls modern name
            vim.lsp.config("ts_ls", {
                init_options = { hostInfo = "neovim" },
                -- (don't need to set cmd unless you want a custom path)
            })

            -- Rust specifics
            vim.lsp.config("rust_analyzer", {
                settings = { ["rust-analyzer"] = { check = { command = "clippy" } } },
            })

            -- Go specifics
            vim.lsp.config("gopls", {
                settings = { gopls = { gofumpt = true } },
            })

            -- If you need to supply a cmd manually (eg jdtls), do it like:
            -- vim.lsp.config('jdtls', { cmd = {'/path/to/jdtls'} })

            -- Finally enable all configured servers so they hook into filetypes:
            -- vim.lsp.enable takes a list of server names to enable (it will use servers from runtime lsp configs + nvim-lspconfig's shipped configs)
            pcall(function()
                vim.lsp.enable(servers)
            end)
        end,
    },
}

