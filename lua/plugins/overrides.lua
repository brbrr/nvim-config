local lsp = {
  "neovim/nvim-lspconfig",
  opts = {
    -- NOTE: Disable inlay hints by default
    inlay_hints = { enabled = false },
    codelens = { enabled = true },
    servers = {
      gopls = {
        settings = {
          gopls = {
            gc_details = true,
            gofumpt = true,
            codelenses = {
              gc_details = true,
              generate = true,
              regenerate_cgo = true,
              run_govulncheck = true,
              test = true,
              tidy = true,
              upgrade_dependency = true,
              vendor = true,
            },
            annotations = { bounds = true, escape = true, inline = true, ["nil"] = true },
          },
        },
      },
    },
  },
}

local lualine = {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    -- NOTE: Make it so the file path is not truncated
    opts.sections.lualine_c[4] = { LazyVim.lualine.pretty_path({ length = 0 }) }
    -- local icons = LazyVim.config.icons
    -- opts.sections.lualine_c = {
    --   LazyVim.lualine.root_dir(),
    --   {
    --     "diagnostics",
    --     symbols = {
    --       error = icons.diagnostics.Error,
    --       warn = icons.diagnostics.Warn,
    --       info = icons.diagnostics.Info,
    --       hint = icons.diagnostics.Hint,
    --     },
    --   },
    --   { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
    --   { LazyVim.lualine.pretty_path() },
    -- }
  end,
}

local find_scratch = function(buf)
  local file = vim.api.nvim_buf_get_name(buf)
  return vim.iter(Snacks.scratch.list()):find(function(s)
    return s.file == file
  end)
end
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("scratch_diagnostic", { clear = true }),
  pattern = "markdown",
  callback = function(e)
    if find_scratch(e.buf) then
      vim.diagnostic.enable(false, { bufnr = e.buf })
    end
  end,
})

local snacks = {
  "folke/snacks.nvim",
  opts = {
    scroll = {
      enabled = false,
    },
    -- NOTE: Force scratch to use markdown
    scratch = {
      ft = "markdown",
    },
    -- NOTE: show "hidden" files (basically all .* files)
    picker = {
      ui_select = true,
      sources = {
        explorer = {
          hidden = true,
          layout = { layout = { position = "right" } },
        },
        files = {
          hidden = true,
        },
        grep = {
          hidden = true,
        },
      },
      formatters = {
        file = {
          truncate = 400,
        },
      },
      -- Extended layout
      layouts = {
        default = {
          -- default
          layout = {
            width = 0.95,
            height = 0.9,
          },
        },
      },
    },
  },
}

return {
  lsp,
  lualine,
  snacks,
}
