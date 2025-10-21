return {
  {
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
  },

  {
    "folke/snacks.nvim",
    opts = {
      -- NOTE: show "hidden" files (basically all .* files)
      picker = {
        ui_select = true,
        sources = {
          explorer = {
            hidden = true,
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
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      -- NOTE: Disable inlay hints by default
      inlay_hints = { enabled = false },
    },
  },
}
