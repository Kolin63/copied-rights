-- SPDX-License-Identifier: MIT
-- Copyright (c) Colin Melican 2025

local M = {}

local config = require("copied-rights/config")
local util = require("copied-rights/util")

-- if a new header should be added rather than replace an old one
M.should_add = function(lines)
  local buf_lines = vim.api.nvim_buf_get_lines(0, 0, #lines, false)

  for i = 1, #lines do
    if util.diff_string(lines[i], buf_lines[i]) > config.get().max_diff then
      return true
    end
  end
  return false
end

-- returns header that matches file name
-- returns nil if it does not exist
M.get = function(file, command)
  local headers = config.get().headers
  for _, i in ipairs(headers) do
    if util.glob(file, i.file) and command == i.command then
      return i
    end
  end
  return nil
end

-- percent substitution formats lines
M.format = function(lines)
  for i = 1, #lines do
    lines[i] = os.date(lines[i])
  end
  return lines
end

-- inserts header at top of file, given file name
M.insert = function(file, command)
  header = M.get(file, command)
  if header == nil then
    local msg = file
    if command ~= nil then msg = msg .. " : " .. command end
    print("Copied Rights: ERROR: Could not find header for " .. msg)
    return
  end

  -- format lines
  local lines = M.format(header.lines)

  local line_end = 0
  if not M.should_add(lines) then line_end = #lines end

  vim.api.nvim_buf_set_lines(0, 0, line_end, false, lines)
end

return M
