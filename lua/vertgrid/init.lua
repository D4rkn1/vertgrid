local M = {}

local size = 5
local group = 'Vertgrid'
local ns_id = vim.api.nvim_create_namespace('Vertns')
vim.api.nvim_set_hl(ns_id, group, { bg = "#222222" })
vim.api.nvim_create_augroup(group, { clear = true })

function M.setup(opts)
    if not opts then opts = {} end
    if opts.size then size = opts.size end
end

local function Highlight(target)
    if target - 1 < 1 then return end
    vim.api.nvim_win_set_hl_ns(0, ns_id)
    vim.api.nvim_buf_set_extmark(0, ns_id, target - 1, 0, {
        line_hl_group = group,
    })
end


local function Render()
    vim.api.nvim_buf_clear_highlight(0, ns_id, 1, -1)
    local cursor_position = vim.api.nvim_win_get_cursor(0)[1]
    local first_line = vim.fn.line('w0')
    local last_line = vim.fn.line('w$')

    for i = cursor_position - size, first_line, -size do
        Highlight(i)
    end
    for i = cursor_position + size, last_line, size do
        Highlight(i)
    end
end

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter", "CursorMoved" }, {
    group = group,
    callback = function()
        vim.schedule(function()
            Render()
        end)
    end
})

return M
