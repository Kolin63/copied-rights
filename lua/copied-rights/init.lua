-- SPDX-License-Identifier: MIT
-- Copyright (c) Colin Melican 2025

local M = {}

local util = require("copied-rights/util")
local clean_file_name = util.clean_file_name
local diff_string = util.diff_string

local config = require("copied-rights/config")

-- setup config
M.setup = function(input)
  if input.headers ~= nil then
    for _, header in ipairs(input.headers) do config.add_header(header) end
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
      for _, i in ipairs(file_input) do config.add_header(i) end
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
