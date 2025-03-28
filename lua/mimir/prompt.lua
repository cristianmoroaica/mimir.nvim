-- lua/mimir/prompt.lua
local M = {}
local ui = require("mimir.ui")
local context = require("mimir.context")
local api = require("mimir.api")
local actions = require("mimir.actions")

function M.refactor_selection()
  local mode = vim.fn.mode()
  local selection = ""
  if mode == "v" or mode == "V" or mode == "\22" then
    local _, start_row, start_col, _ = unpack(vim.fn.getpos("'<"))
    local _, end_row, end_col, _ = unpack(vim.fn.getpos("'>"))
    local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)
    if #lines > 0 then
      lines[1] = string.sub(lines[1], start_col)
      lines[#lines] = string.sub(lines[#lines], 1, end_col)
    end
    selection = table.concat(lines, "\n")
  else
    print("Please select a region in visual mode.")
    return
  end

  local registered_context = context.get_context()
  local prompt = "Refactor the following code with improvements:\n\n" .. selection
  if registered_context ~= "" then
    prompt = prompt .. "\n\nContext:\n" .. registered_context
  end

  ui.open_window()
  ui.set_content("Sending prompt to Claude...")

  api.send_prompt(prompt, function(response)
    actions.handle_response(response, selection)
  end)
end

return M

