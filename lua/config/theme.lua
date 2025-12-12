-- lua/config/theme.lua
-- Theme manager: toggle light/dark, persist last choice, and manage transparency persistence.
local M = {}

-- Configure these to the colorscheme names you have installed
M.dark = "catppuccin-mocha"   -- change to your dark theme name
M.light = "catppuccin-latte"  -- change to your light theme name

-- file paths for persistence
local data_dir = vim.fn.stdpath("data")
local theme_state_file = data_dir .. "/last_theme"         -- stores "dark" or "light"
local transparent_state_file = data_dir .. "/transparent" -- stores "1" or "0"

-- utility: write a small file atomically
local function write_state(path, content)
    -- content should be a string or number
    local ok, err = pcall(vim.fn.writefile, { tostring(content) }, path, "b")
    if not ok then
        vim.notify("Failed to write state to " .. path .. ": " .. tostring(err), vim.log.levels.WARN)
    end
end

local function read_state(path)
    if vim.fn.filereadable(path) == 0 then return nil end
    local lines = vim.fn.readfile(path)
    return lines and lines[1] or nil
end

-- apply theme and persist choice
function M.apply(mode)
    mode = mode or "dark"
    local scheme = (mode == "dark") and M.dark or M.light
    -- set background for some plugins and themes
    if mode == "dark" then
        vim.o.background = "dark"
    else
        vim.o.background = "light"
    end
    local ok, _ = pcall(vim.cmd, "colorscheme " .. scheme)
    if not ok then
        vim.notify("Colorscheme '" .. scheme .. "' failed to load", vim.log.levels.WARN)
    end
    -- persist
    write_state(theme_state_file, mode)
    M.mode = mode
end

function M.toggle()
    local next = (M.mode == "dark") and "light" or "dark"
    M.apply(next)
end

-- Transparency: uses the same approach as earlier transparent.lua but persists state.
M._groups = {
    "Normal", "NormalNC", "SignColumn", "MsgArea", "StatusLine",
    "StatusLineNC", "VertSplit", "Folded", "CursorLine", "NonText",
    "LineNr", "CursorColumn", "ColorColumn", "Pmenu", "PmenuSel",
    "PmenuThumb", "FloatBorder", "NormalFloat", "TelescopeNormal",
    "TelescopeBorder"
}

local function set_none(group)
    pcall(vim.api.nvim_set_hl, 0, group, { bg = "none" })
end

local function restore_default(group)
    pcall(vim.api.nvim_set_hl, 0, group, {})
end

M.transparent_enabled = false

function M.enable_transparent()
    for _, g in ipairs(M._groups) do set_none(g) end
    M.transparent_enabled = true
    write_state(transparent_state_file, "1")
    vim.notify("Neovim transparency: ON")
end

function M.disable_transparent()
    for _, g in ipairs(M._groups) do restore_default(g) end
    M.transparent_enabled = false
    write_state(transparent_state_file, "0")
    vim.notify("Neovim transparency: OFF")
end

function M.toggle_transparent()
    if M.transparent_enabled then
        M.disable_transparent()
    else
        M.enable_transparent()
    end
end

-- Commands
function M.setup_commands()
    vim.api.nvim_create_user_command("ToggleTheme", function() M.toggle() end, { desc = "Toggle dark/light theme (persists)" })
    vim.api.nvim_create_user_command("ToggleTransparency", function() M.toggle_transparent() end, { desc = "Toggle Neovim transparency (persists)" })
end

-- Re-apply transparency after any colorscheme change (colorschemes may reset highlights)
function M.setup_autocmds()
    vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
            if M.transparent_enabled then
                -- re-apply transparency highlights
                for _, g in ipairs(M._groups) do
                    pcall(vim.api.nvim_set_hl, 0, g, { bg = "none" })
                end
            end
        end,
    })
end

-- bootstrap: read saved state and apply
function M.setup()
    -- restore theme
    local saved = read_state(theme_state_file)
    if saved == "light" or saved == "dark" then
        M.mode = saved
    else
        -- default to dark if unknown
        M.mode = "dark"
    end
    M.apply(M.mode)

    -- restore transparency
    local t = read_state(transparent_state_file)
    if t == "1" then
        M.transparent_enabled = false -- will be enabled by enable_transparent below
        M.enable_transparent()
    else
        M.transparent_enabled = false
    end

    -- commands + autocmds
    M.setup_commands()
    M.setup_autocmds()

    return M
end

return M

