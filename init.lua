require("rounakkumarsingh")
require("config.lazy")
require("config.diagnostics")
local theme = require("config.theme")

theme.apply(theme.dark)

vim.keymap.set("n", "<leader>tt", function ()
    theme.toggle()
end, { desc = "Toggle light/dark themes" })
vim.o.termguicolors = true

-- require theme manager and call setup
theme.setup()

-- Optional: create a simple keymap still for theme toggle (if you want)
-- vim.keymap.set("n", "<leader>ut", function() require("config.theme").toggle() end, { desc = "Toggle theme" })

