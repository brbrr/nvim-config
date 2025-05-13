-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- LazyVim root dir detection
-- Each entry can be:
-- * the name of a detector function like `lsp` or `cwd`
-- * a pattern or array of patterns like `.git` or `lua`.
-- * a function with signature `function(buf) -> string|string[]`
-- NOTE: default is: { "lsp", { ".git", "lua" }, "cwd" }
-- Update to below to support multi-lanugage codebases
-- vim.g.root_spec = { { ".git", "lua" }, "lsp", "cwd" }
vim.g.root_spec = { "cwd", { ".git", "lua" }, "lsp" }

-- Set to "basedpyright" to use basedpyright instead of pyright.
vim.g.lazyvim_python_lsp = "basedpyright"
