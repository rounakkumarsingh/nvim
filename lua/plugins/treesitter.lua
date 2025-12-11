return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate", -- auto-update parsers
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "c", "lua", "vim", "vimdoc", "markdown", "markdown_inline", "java", "javascript", "typescript", "bash", "jsdoc", "go", "rust" },
				sync_install = false,
				auto_install = true,
				highlight = {
					enable = true, -- <--- COMMA was missing here
					disable = function(lang, buf)
						if lang == "html" then
							print("disabled")
							return true
						end

						local max_filesize = 100 * 1024 -- 100 KB
						local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
						if ok and stats and stats.size > max_filesize then
							vim.notify(
								"File larger than 100KB — treesitter disabled for performance",
								vim.log.levels.WARN,
								{ title = "Treesitter" }
							)
							return true
						end

						return false
					end,
					additional_vim_regex_highlighting = false,
				},
			})
		end,
	},
	{
		"nvim-treesitter/playground",
		config = function()
			require("nvim-treesitter.configs").setup({
				playground = {
					enable = true,
					disable = {},
					updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
					persist_queries = false, -- Whether the query persists across vim sessions
					keybindings = {
						toggle_query_editor = 'o',
						toggle_hl_groups = 'i',
						toggle_injected_languages = 't',
						toggle_anonymous_nodes = 'a',
						toggle_language_display = 'I',
						focus_language = 'f',
						unfocus_language = 'F',
						update = 'R',
						goto_node = '<cr>',
						show_help = '?',
					},
				}

			})
		end
	}
}

