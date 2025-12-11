-- nvim/lua/plugins/conform.lua
-- Conform format-on-save configuration, with Biome and other formatters.
return {
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        opts = {
            format_on_save = function(bufnr)
                return {
                    timeout_ms = 1500,
                    lsp_fallback = true,
                }
            end,
            -- mapping ft -> formatter name(s). These names must match keys we register below.
            formatters_by_ft = {
                javascript = { "biome" },
                typescript = { "biome" },
                javascriptreact = { "biome" },
                typescriptreact = { "biome" },
                tsx = { "biome" },
                jsx = { "biome" },
                json = { "biome" },
                css = { "biome" },
                html = { "biome" },
                python = { "black" },      -- ruff can also do formatting; change if you prefer ruff
                go = { "goimports" },
                c = { "clang_format" },
                cpp = { "clang_format" },
                rust = { "rustfmt" },
                sh = { "shfmt" },
                bash = { "shfmt" },
                java = { "google_java_format" },
                _ = { "trim_whitespace" },
            },
        },
        config = function(_, opts)
            local ok, conform = pcall(require, "conform")
            if not ok then
                vim.notify("conform.nvim not available", vim.log.levels.WARN)
                return
            end

            conform.setup(opts)

            -- Register CLI formatters. Names here should match formatters_by_ft above.

            -- Biome (JS/TS/HTML/CSS/etc)
            conform.formatters.biome = {
                command = "biome",
                -- Biome supports reading from stdin given --stdin-file-path
                args = { "format", "--stdin-file-path", "$FILENAME" },
                stdin = true,
            }

            -- clang-format
            conform.formatters.clang_format = {
                command = "clang-format",
                args = { "--assume-filename", "$FILENAME" },
                stdin = true,
            }

            -- rustfmt
            conform.formatters.rustfmt = {
                command = "rustfmt",
                args = { "--emit", "stdout" },
                stdin = true,
            }

            -- goimports (falls back to gofmt if not present)
            conform.formatters.goimports = {
                command = "goimports",
                args = {},
                stdin = true,
            }

            -- black (python)
            conform.formatters.black = {
                command = "black",
                args = { "-" },
                stdin = true,
            }

            -- shfmt
            conform.formatters.shfmt = {
                command = "shfmt",
                args = { "-i", "2", "-" },
                stdin = true,
            }

            -- google-java-format (many folks wrap the jar as a binary named google-java-format)
            conform.formatters.google_java_format = {
                command = "google-java-format",
                args = { "-" },
                stdin = true,
            }

            -- trim trailing whitespace fallback
            conform.formatters.trim_whitespace = {
                command = "sed",
                args = { "-E", "s/[ \t]+$//g" },
                stdin = true,
            }
        end,
    },
}

