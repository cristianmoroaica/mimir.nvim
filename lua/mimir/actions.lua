-- lua/mimir/actions.lua
local M = {}
local ui = require("mimir.ui")

function M.handle_response(response, original_selection)
  local new_code = response.completion or "No response field found."
  ui.set_content("Claude Response:\n\n" .. new_code .. "\n\nPress 'r' to replace selection, 'q' to close.")

  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_keymap(buf, "n", "r", "<cmd>lua require('mimir.actions').replace_selection(" .. vim.fn.json_encode(new_code) .. ")<CR>", { nowait = true, noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>lua require('mimir.ui').close_window()<CR>", { nowait = true, noremap = true, silent = true })
end

function M.replace_selection(new_code)
  -- Implement your replacement logic here.
  vim.api.nvim_command('echo "Replacing selection with new code:"')
  vim.api.nvim_command('echo "' .. new_code:gsub('"', '\\"') .. '"')
  require("mimir.ui").close_window()
end

return M

