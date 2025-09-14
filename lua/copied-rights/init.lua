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
    for _, header in ipairs(input.headers) do
      config.add_header(header, true)
    end
  end
  if input.search_stop ~= nil then config.set_search_stop(input.search_stop) end
  if input.max_search ~= nil then config.set_max_search(input.max_search) end
  if input.max_diff ~= nil then config.set_max_diff(input.max_diff) end
  if input.override_file ~= nil then
    config.set_override_file(input.override_file)
  end

  -- make the commands
  vim.api.nvim_create_user_command("CopiedRights", function(args)
    config.find_local_files()

    local insert = require("copied-rights/header").insert
    if #args.fargs == 0 then
      insert(vim.api.nvim_buf_get_name(0))
    else
      insert(vim.api.nvim_buf_get_name(0), args.fargs[1])
    end
  end, { nargs = '?' })

end

return M
