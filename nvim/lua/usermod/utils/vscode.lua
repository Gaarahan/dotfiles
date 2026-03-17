-- compact with vscode settings file in lsp config 

local M = {}

local settings_cache = {}

---@param path string
---@return boolean
local function exists(path)
  return vim.uv.fs_stat(path) ~= nil
end

---@param text string
---@return table | nil
local function decode_jsonc(text)
  local ok, decoded = pcall(vim.json.decode, text)
  if ok and type(decoded) == "table" then
    return decoded
  end

  -- settings.json is sometimes JSONC. Try a light normalization before giving up.
  local stripped = text
    :gsub("/%*.-%*/", "") -- block comments (/* ... */)
    :gsub("\n%s*//.-\n", "\n") -- line comments (best-effort)
    :gsub(",%s*}", "}") -- trailing commas before object end
    :gsub(",%s*%]", "]") -- trailing commas before array end

  local ok2, decoded2 = pcall(vim.json.decode, stripped)
  if ok2 and type(decoded2) == "table" then
    return decoded2
  end

  return nil
end

---@param root_dir string
---@return table | nil
function M.get_vscode_settings(root_dir)
  if type(root_dir) ~= "string" or root_dir == "" then
    return nil
  end
  if settings_cache[root_dir] ~= nil then
    return settings_cache[root_dir] or nil
  end

  local settings_path = root_dir .. "/.vscode/settings.json"
  if not exists(settings_path) then
    settings_cache[root_dir] = false
    return nil
  end

  local ok, lines = pcall(vim.fn.readfile, settings_path)
  if not ok or type(lines) ~= "table" then
    settings_cache[root_dir] = false
    return nil
  end

  local content = table.concat(lines, "\n")
  if content == "" then
    settings_cache[root_dir] = false
    return nil
  end

  local decoded = decode_jsonc(content)
  settings_cache[root_dir] = decoded or false
  return decoded
end

---@param settings table
---@param config vim.lsp.ClientConfig
---@return boolean changed
local function apply_eslint_settings(settings, config)
  local node_path = settings["eslint.nodePath"]
  if type(node_path) == "string" and node_path ~= "" then
    config.settings = config.settings or {}
    config.settings.nodePath = node_path
    return true
  end
  return false
end

---@param server_name string
---@param config vim.lsp.ClientConfig
---@return boolean changed
function M.apply_lsp_compat(server_name, config)
  if type(server_name) ~= "string" then
    return false
  end
  if type(config) ~= "table" then
    return false
  end

  local root_dir = config.root_dir
  if type(root_dir) ~= "string" or root_dir == "" then
    return false
  end

  local settings = M.get_vscode_settings(root_dir)
  if type(settings) ~= "table" then
    return false
  end

  if server_name == "eslint" then
    return apply_eslint_settings(settings, config)
  end

  return false
end

return M

