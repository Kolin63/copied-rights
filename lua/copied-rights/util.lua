-- SPDX-License-Identifier: MIT
-- Copyright (c) Colin Melican 2025

local M = {}

-- removes any extra syntax from file name
M.clean_file_name = function(file)
  if file:sub(1, 1) == "*" then file = file:sub(2) end
  if file:sub(1, 1) == "." then file = file:sub(2) end
  return file
end

return M
