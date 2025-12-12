-- lua/config/transparent.lua
local M = {}

-- List of highlight groups to clear bg for when enabling transparency
M.groups = {
    "Normal",
    "NormalNC",
    "SignColumn",
    "MsgArea",
    "StatusLine",
    "StatusLineNC",
    "VertSplit",
    "Folded",
    "CursorLine",
    "NonText",
    "LineNr",
    "CursorColumn",
    "ColorColumn",
    "Pmenu",
    "PmenuSel",
    "PmenuThumb",
    "FloatBorder",
    "NormalFloat",
    "TelescopeBorder",
    "TelescopeNormal",
    "WhichKeyFloat",
    "CmpItemAbbrDeprecated",
    "CmpItemAbbrMatch",
    "CmpItemAbbrMatchFuzzy",
}

local function set_none(group)
    pcall(vim.api.nvim_set_hl, 0, group, { bg = "none" })
end

local function restore_default(group)
    -- Removing highlight will fallback to colorscheme defaults; using nil in nvim_set_hl resets attribute
    pcall(vim.api.nvim_set_hl, 0, group, {})
end

M.enabled = false

function M.enable()
    for _, g in ipairs(M.groups) do set_none(g) end
    -- optional: make floating windows and popups transparent too
    pcall(vim.api.nvim_set_hl, 0, "NormalFloat", { bg = "none" })
    pcall(vim.api.nvim_set_hl, 0, "TelescopeNormal", { bg = "none" })
    M.enabled = true
    vim.notify("Transparency: ON")
end

function M.disable()
    for _, g in ipairs(M.groups) do restore_default(g) end
    M.enabled = false
    vim.notify("Transparency: OFF")
end

function M.toggle()
    if M.enabled then M.disable() else M.enable() end
end

return M

