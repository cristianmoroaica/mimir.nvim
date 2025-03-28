-- lua/mimir/context.lua
local M = {}

M.context_files = {}

function M.add_current_buffer()
  local buf = vim.api.nvim_get_current_buf()
  local file_path = vim.api.nvim_buf_get_name(buf)
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local content = table.concat(lines, "\n")
  M.context_files[file_path] = content
  print("Added current buffer to context: " .. file_path)
end

function M.get_context()
  local context = {}
  for file, content in pairs(M.context_files) do
    table.insert(context, "-- File: " .. file .. "\n" .. content)
  end
  return table.concat(context, "\n\n")
end

-- New function to list the file paths registered as context.
function M.list_context_files()
  local files = {}
  for file, _ in pairs(M.context_files) do
    table.insert(files, file)
  end
  if next(files) == nil then
    return "No context files added."
  end
  return table.concat(files, "\n")
end

return M

