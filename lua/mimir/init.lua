-- lua/mimir/init.lua
local M = {}

M.context = require("mimir.context")
M.ui = require("mimir.ui")
M.prompt = require("mimir.prompt")
M.api = require("mimir.api")
M.actions = require("mimir.actions")

-- Open the floating window (for chat state or responses)
vim.api.nvim_create_user_command("MimirOpen", function()
  M.ui.open_window()
end, {})

-- Add the current buffer to the session context
vim.api.nvim_create_user_command("MimirContextAdd", function()
  M.context.add_current_buffer()
end, {})

-- List all context files in a floating window
vim.api.nvim_create_user_command("MimirContextList", function()
  local list = M.context.list_context_files()
  M.ui.open_window()
  M.ui.set_content("Context Files:\n\n" .. list)
end, {})

-- In visual mode, send selected code to Claude for refactoring
vim.api.nvim_create_user_command("MimirRefactor", function()
  M.prompt.refactor_selection()
end, {})

return M

