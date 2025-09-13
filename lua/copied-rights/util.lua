-- SPDX-License-Identifier: MIT
-- Copyright (c) Colin Melican 2025

local M = {}

local config = require("copied-rights/config")

-- removes any extra syntax from file name
M.clean_file_name = function(file)
  if file:sub(1, 1) == "*" then file = file:sub(2) end
  if file:sub(1, 1) == "." then file = file:sub(2) end
  return file
end

-- returns an int of how many characters are different between two strings
M.diff_string = function(x, y)
  local diff_count = 0
  for i = 1, math.max(#x, #y) do
    if x:sub(i, i) ~= y:sub(i, i) then
      diff_count = diff_count + 1
    end
  end
  return diff_count
end

-- debug function for printing all headers
M.debug = function()
  for _, header in ipairs(config.get().headers) do
    print("file: " .. header.file)
    for _, line in ipairs(header.lines) do
      print(line)
    end
    print("\n")
  end
end

return M
