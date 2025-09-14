-- SPDX-License-Identifier: MIT
-- Copyright (c) Colin Melican 2025

local M = {}

local config = require("copied-rights/config")

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
