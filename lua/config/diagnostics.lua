-- diagnostics.lua  (paste this into init.lua or require it)
-- Pretty signs in the sign column
local signs = {
    Error = "✘",
    Warn  = "▲",
    Hint  = "●",
    Info  = "⚑",
}
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- Global diagnostic config
vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "✘",
            [vim.diagnostic.severity.WARN]  = "▲",
            [vim.diagnostic.severity.INFO]  = "●",
            [vim.diagnostic.severity.HINT]  = "⚑",
        },
    },
    virtual_text = {
        prefix = "●", -- could be '●', '▎', etc.
        spacing = 4,
        -- show only for severity >= WARN? Uncomment next line to restrict
        -- severity = { min = vim.diagnostic.severity.WARN },
    },
    signs = true,               -- show signs in sign column
    underline = true,           -- underline problematic bits (very visible)
    severity_sort = true,       -- show more severe items first
    update_in_insert = false,   -- don't update while typing (less noisy)
    float = {
        border = "rounded",
        focusable = false,
        header = "",
        prefix = "", -- prefix for each diagnostic line
        source = "always", -- show source (eg. ruff/pyright)
        format = function(d)
            -- Example: include code id if available: "message [E123]"
            if d.code then
                return string.format("%s [%s]", d.message, tostring(d.code))
            end
            return d.message
        end,
    },
})

-- Show diagnostics in a floating window on CursorHold
-- You probably already map K to LSP hover; this is separate: it shows diagnostics.
vim.cmd([[
augroup ShowDiagnosticsOnHover
autocmd!
" Show diagnostics in a small floating window when cursor stays on a line
autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, { scope = "cursor", focus = false })
augroup END
]])

vim.cmd([[
highlight DiagnosticSignError guifg=#ff0000
highlight DiagnosticSignWarn  guifg=#ffaa00
highlight DiagnosticSignHint  guifg=#00aaff
highlight DiagnosticSignInfo  guifg=#00ff00
]])

-- Useful keymaps for navigating diagnostics
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)        -- show diagnostics under cursor
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)       -- put diagnostics into loclist

-- Optional toggle for virtual text (handy for presentations)
_G.toggle_virtual_text = function()
    local cfg = vim.diagnostic.config()
    local cur = cfg.virtual_text
    if cur and cur ~= false then
        vim.diagnostic.config({ virtual_text = false })
        vim.notify("Diagnostic virtual_text: OFF")
    else
        vim.diagnostic.config({ virtual_text = { prefix = "●", spacing = 4 } })
        vim.notify("Diagnostic virtual_text: ON")
    end
end
vim.keymap.set("n", "<leader>vt", "<cmd>lua _G.toggle_virtual_text()<cr>", { noremap = true, silent = true })

