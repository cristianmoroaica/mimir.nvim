-- lua/mimir/api.lua
local M = {}

-- Sends a prompt to Claude and calls the provided callback with the response.
function M.send_prompt(prompt, callback)
  local api_key = os.getenv("CLAUDE_API_KEY")
  if not api_key then
    print("CLAUDE_API_KEY not set")
    return
  end

  local json_prompt = vim.fn.json_encode({
    model = "claude-3-haiku-20240307",
    max_tokens = 1000,
    messages = {
      { role = "user", content = prompt },
    },
  })

  local cmd = string.format(
    'curl -s https://api.anthropic.com/v1/messages -H "x-api-key: %s" -H "anthropic-version: 2023-06-01" -H "content-type: application/json" -d %s',
    api_key, vim.fn.shellescape(json_prompt)
  )

  local output = vim.fn.system(cmd)
  local ok, result = pcall(vim.fn.json_decode, output)
  if not ok then
    print("Error decoding API response")
    return
  end

  callback(result)
end

return M

