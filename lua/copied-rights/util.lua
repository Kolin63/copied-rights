-- SPDX-License-Identifier: MIT
-- Copyright (c) Colin Melican 2025

local M = {}

local config = require("copied-rights/config")

-- returns file name given path
-- ex: /home/colin/.vimrc will return .vimrc
M.get_file_name = function(path)
  file = ""

  if path:sub(#path, #path) == "/" then
    path = path:sub(1, #path - 1)
  end

  while path:sub(#path, #path) ~= "/" do
    file = path:sub(#path, #path) .. file
    path = path:sub(1, #path - 1)
  end
  return file
end

-- returns true if file matches glob pattern
M.glob = function(file, glob)
  while #file > 0 do
    local glob_char = glob:sub(#glob, #glob)
    local prev_glob_char = glob:sub(#glob - 1, #glob - 1)
    local file_char = file:sub(#file, #file)
    local checking_for = ""

    if glob_char == "*" then checking_for = prev_glob_char
    else checking_for = glob_char end

    if glob_char == "*" then
      sub_file = file
      for _ = #file, 0, -1 do
        -- prev sub file char
        local psfc = sub_file:sub(#sub_file - 1, #sub_file - 1)
        if psfc == checking_for or psfc == "" then
          file = sub_file
        end
        sub_file = sub_file:sub(1, #sub_file - 1)
      end
      glob = glob:sub(1, #glob - 1)
    end

    if glob_char ~= "*" and file_char == checking_for then
      file = file:sub(1, #file - 1)
      glob = glob:sub(1, #glob - 1)
    elseif glob_char ~= "*" and file_char ~= checking_for then
      return false
    end

  end
  return true
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
