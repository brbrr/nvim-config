---@class BrHelp: BrHelpOptions
---@field lualine BrHelp.lualine
---@field root BrHelp.root
---@field lsp BrHelp.lsp
---@field mini BrHelp.mini
---@field ui BrHelp.ui
local M = {}
BrHelp = M

BrHelp.lualine = require 'brbrr.brhelp.lualine'
BrHelp.root = require 'brbrr.brhelp.root'
BrHelp.lsp = require 'brbrr.brhelp.lsp'
BrHelp.mini = require 'brbrr.brhelp.mini'
BrHelp.ui = require 'brbrr.brhelp.ui'

---@class BrHelpOptions
local defaults = {

  icons = {
    misc = {
      dots = '󰇘',
    },
    ft = {
      octo = '',
    },
    dap = {
      Stopped = { '󰁕 ', 'DiagnosticWarn', 'DapStoppedLine' },
      Breakpoint = ' ',
      BreakpointCondition = ' ',
      BreakpointRejected = { ' ', 'DiagnosticError' },
      LogPoint = '.>',
    },
    diagnostics = {
      Error = ' ',
      Warn = ' ',
      Hint = ' ',
      Info = ' ',
    },
    git = {
      added = ' ',
      modified = ' ',
      removed = ' ',
    },
    kinds = {
      Array = ' ',
      Boolean = '󰨙 ',
      Class = ' ',
      Codeium = '󰘦 ',
      Color = ' ',
      Control = ' ',
      Collapsed = ' ',
      Constant = '󰏿 ',
      Constructor = ' ',
      Copilot = ' ',
      Enum = ' ',
      EnumMember = ' ',
      Event = ' ',
      Field = ' ',
      File = ' ',
      Folder = ' ',
      Function = '󰊕 ',
      Interface = ' ',
      Key = ' ',
      Keyword = ' ',
      Method = '󰊕 ',
      Module = ' ',
      Namespace = '󰦮 ',
      Null = ' ',
      Number = '󰎠 ',
      Object = ' ',
      Operator = ' ',
      Package = ' ',
      Property = ' ',
      Reference = ' ',
      Snippet = '󱄽 ',
      String = ' ',
      Struct = '󰆼 ',
      Supermaven = ' ',
      TabNine = '󰏚 ',
      Text = ' ',
      TypeParameter = ' ',
      Unit = ' ',
      Value = ' ',
      Variable = '󰀫 ',
    },
  },
}

local lutil = require 'lazy.util'
M.norm = function(path)
  return lutil.norm(path)
end

---@generic T
---@param list T[]
---@return T[]
function M.dedup(list)
  local ret = {}
  local seen = {}
  for _, v in ipairs(list) do
    if not seen[v] then
      table.insert(ret, v)
      seen[v] = true
    end
  end
  return ret
end

function M.is_loaded(name)
  local Config = require 'lazy.core.config'
  return Config.plugins[name] and Config.plugins[name]._.loaded
end

---@param name string
---@param fn fun(name:string)
function M.on_load(name, fn)
  if M.is_loaded(name) then
    fn(name)
  else
    vim.api.nvim_create_autocmd('User', {
      pattern = 'LazyLoad',
      callback = function(event)
        if event.data == name then
          fn(name)
          return true
        end
      end,
    })
  end
end

M.merge = function(...)
  return lutil.merge(...)
end

---@param name string
function M.get_plugin(name)
  return require('lazy.core.config').spec.plugins[name]
end

---@param name string
function M.opts(name)
  local plugin = M.get_plugin(name)
  if not plugin then
    return {}
  end
  local Plugin = require 'lazy.core.plugin'
  return Plugin.values(plugin, 'opts', false)
end

---@type BrHelpOptions
local options

---@param opts? BrHelpOptions
M.setup = function(opts)
  options = vim.tbl_deep_extend('force', defaults, opts or {}) or {}
end

setmetatable(M, {
  __index = function(_, key)
    if options == nil then
      return vim.deepcopy(defaults)[key]
    end

    ---@cast options BrHelpOptions
    return options[key]
  end,
})

return M
