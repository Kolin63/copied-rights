-- SPDX-License-Identifier: MIT
-- Copyright (c) Colin Melican 2025

local M = {}

local config = {
  headers = {},
  search_stop = { ".git/" },
  max_search = 4,
  max_diff = 4,
  override_file = ".copied-rights.lua",
}

M.get = function() return config end
M.set = function(c) config = c end

M.set_search_stop = function(x) config.search_stop = x end
M.set_max_search = function(x) config.max_search = x end
M.set_max_diff = function(x) config.max_diff = x end
M.set_override_file = function(x) config.override_file = x end

-- neatly adds header to config, and checks for file type conflicts
-- fast: if conflicting file type checks should be skipped
M.add_header = function(header, fast)
  if header.file == nil then
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
  if fast then goto conflict_resolved end
  for idx, i in ipairs(config.headers) do
    if header.file == i.file and header.command == i.command then
      table.remove(config.headers, idx)
      goto conflict_resolved
    end
  end
  ::conflict_resolved::

  table.insert(config.headers, header)

  ::exception::
end

-- finds local file headers and adds them to the config
M.find_local_files = function()
  local file_path = config.override_file
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
      for _, i in ipairs(file_input) do M.add_header(i) end
    end

    -- check for search stop files
    for _, sfile_path in ipairs(config.search_stop) do
      sfile = io.open(sfile_path)
      if io.type(sfile) ~= nil then
        sfile:close()
        goto stop_file_search
      end
    end

  end
  ::stop_file_search::
end

return M
