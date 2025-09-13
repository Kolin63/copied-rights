-- SPDX-License-Identifier: MIT
-- Copyright (c) Colin Melican 2025

local M = {}

local config = {
  headers = {},
  search_stop = { ".git/" },
  max_search = 4
}

M.get = function() return config end
M.set = function(c) config = c end

M.insert_header = function(value) table.insert(config.headers, value) end
M.remove_header = function(pos) table.remove(config.headers, pos) end

M.set_search_stop = function(x) config.search_stop = x end
M.set_max_search = function(x) config.max_search = x end

return M
