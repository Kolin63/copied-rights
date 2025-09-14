-- SPDX-License-Identifier: MIT
-- Copyright (c) Colin Melican 2025

local M = {}

local config = require("copied-rights/config")

-- returns file name extension given file name
-- ex: file.abc.vim will return vim
M.get_extension = function(file)
  ext = ""
  while file:sub(#file, #file) ~= "." do
    ext = file:sub(#file, #file) .. ext
    file = file:sub(1, #file - 1)
  end
  return ext
end

-- debug function for printing all headers
M.debug = function()
  local c = config.get()

  print("search stops:")
  for _, ss in ipairs(c.search_stop) do
    print(ss)
  end
  print("\n")

  print("max search: " .. c.max_search .. "\n\n")

  for _, header in ipairs(c.headers) do
    print("file: " .. header.file)
    for _, line in ipairs(header.lines) do
      print(line)
    end
    print("\n")
  end
end

return M
