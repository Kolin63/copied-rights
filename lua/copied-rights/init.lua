-- SPDX-License-Identifier: MIT
-- Copyright (c) Colin Melican 2025

local M = {}

local util = require("copied-rights/util")
local clean_file_name = util.clean_file_name
local diff_string = util.diff_string

local config = require("copied-rights/config")

-- neatly adds header to config
-- does not check for file type conflicts
function add_header(header)
  if header.file ~= nil then
    header.file = clean_file_name(header.file)
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

  config.insert_header(header)

  ::exception::
end

-- setup config
M.setup = function(input)
  if input.headers ~= nil then
    for _, header in ipairs(input.headers) do add_header(header) end
  end
  if input.search_stop ~= nil then config.set_search_stop(input.search_stop) end
  if input.max_search ~= nil then config.set_max_search(input.max_search) end

  local file_path = ".copied-rights.lua"
  for search_depth = 0, config.get().max_search do
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
        for ji, j in ipairs(config.get().headers) do

          -- without a file type, it is invalid
          if i.file == nil then
            print("Copied Rights: ERROR: Header must include a file type")
            goto header_replaced
          end

          -- remove any extra syntax
          i.file = clean_file_name(i.file)

          if i.file == j.file then
            config.remove_header(ji)
            add_header(i)
            goto header_replaced
          end
        end
        add_header(i)
        ::header_replaced::
      end
    end

    -- check for search stop files
    for _, sfile_path in ipairs(config.get().search_stop) do
      sfile = io.open(sfile_path)
      if io.type(sfile) ~= nil then
        sfile:close()
        goto stop_file_search
      end
    end

  end
  ::stop_file_search::

  util.debug()

end

return M
