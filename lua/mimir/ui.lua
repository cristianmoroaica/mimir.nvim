-- lua/mimir/ui.lua
local M = {}

local win_id, buf_id

function M.open_window()
  if win_id and vim.api.nvim_win_is_valid(win_id) then
    return win_id
  end

  buf_id = vim.api.nvim_create_buf(false, true)
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  win_id = vim.api.nvim_open_win(buf_id, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
  })
  vim.api.nvim_buf_set_option(buf_id, "buftype", "prompt")
  return win_id
end

function M.close_window()
  if win_id and vim.api.nvim_win_is_valid(win_id) then
    vim.api.nvim_win_close(win_id, true)
    win_id = nil
    buf_id = nil
  end
end

function M.set_content(content)
  if buf_id and vim.api.nvim_buf_is_valid(buf_id) then
    vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, vim.split(content, "\n"))
  end
end

return M

