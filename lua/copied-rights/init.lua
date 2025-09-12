-- SPDX-License-Identifier: MIT
-- Copyright (c) Colin Melican 2025

local M = {}

local config = {
  headers = {},
  search_stop = { ".git/" },
  max_search = 4
}

-- debug function for printing all headers
M.debug = function()
  for _, header in ipairs(config.headers) do
    print("file: " .. header.file)
    for _, line in ipairs(header.lines) do
      print(line)
    end
    print("\n")
  end
end

-- setup config
M.setup = function(input)
  if input.headers ~= nil then config.headers = input.headers end
  if input.search_stop ~= nil then config.search_stop = input.search_stop end
  if input.max_search ~= nil then config.max_search = input.max_search end

  local file_path = ".copied-rights.lua"
  for search_depth = 0, config.max_search do
    file = io.open(file_path)
    if io.type(file) == nil then
      -- if file is not in this directory, go back one
      file_path = "../" .. file_path
    else
      -- get table from file
      file_input = dofile(file_path)
      file:close()
      -- put table in config
      -- replaces a header if the file type is the same
      -- otherwise, inserts at end
      for _, i in ipairs(file_input) do
        for ji, j in ipairs(config.headers) do
          if i.file == j.file then
            table.remove(config.headers, ji)
            table.insert(config.headers, ji, i)
            goto header_replaced
          end
        end
        table.insert(config.headers, i)
        ::header_replaced::
      end
    end
  end
  ::stop_file_search::

  M.debug()

end

return M
