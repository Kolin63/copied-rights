-- SPDX-License-Identifier: MIT
-- Copyright (c) Colin Melican 2025

local M = {}

local util = require("copied-rights/util")
local config = require("copied-rights/config")

-- if a new header should be added rather than replace an old one
M.should_add = function(lines)
  local buf_lines = vim.api.nvim_buf_get_lines(0, 0, #lines, false)

  for i = 1, #lines do
    if util.diff_string(lines[i], buf_lines[i]) > config.get().max_diff then
      return true
    end
  end
  return false
end

return M
