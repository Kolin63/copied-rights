-- SPDX-License-Identifier: MIT
-- Copyright (c) Colin Melican 2025

local M = {}

local config = {
  headers = {},
  search_stop = { ".git/" },
  max_search = 4,
  max_diff = 4,
}

M.get = function() return config end
M.set = function(c) config = c end

M.set_search_stop = function(x) config.search_stop = x end
M.set_max_search = function(x) config.max_search = x end

-- neatly adds header to config, and checks for file type conflicts
M.add_header = function(header)
  if header.file ~= nil then
    if header.file:sub(1, 1) == "*" then header.file = header.file:sub(2) end
    if header.file:sub(1, 1) == "." then header.file = header.file:sub(2) end
  else
    -- without a file type, it is invalid
    print("Copied Rights: ERROR: Header must include a file type")
    goto exception
  end

  if header.lines ~= nil then
    -- lines must be a table
    if type(header.lines) ~= "table" then
      header.lines = { header.lines }
    end
  else
    -- without lines, it is invalid
    print("Copied Rights: ERROR: Header must include lines")
    goto exception
  end

  -- remove conflicting file types
  for idx, i in ipairs(config.headers) do
    if header.file == i.file then
      table.remove(config.headers, idx)
      goto conflict_resolved
    end
  end
  ::conflict_resolved::

  table.insert(config.headers, header)

  ::exception::
end


return M
